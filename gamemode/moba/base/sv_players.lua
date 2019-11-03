function GM:Initialize()
	team.SetSpawnPoint(TEAM_BLUE, "hlhs_blue_start")
	team.SetSpawnPoint(TEAM_BLUE, "hlhs_red_start")
end

function GM:PlayerInitialSpawn( ply )
	ply:Initialize()
	//ply:SetTeam(TEAM_BLUE)
	//ply:SetCharacter("alyx_vance")
	if ply:IsBot() then
		ply:SetCharacter("alyx_vance")
		local theteam = team.BestAutoJoinTeam()
		ply:SetTeam(theteam)
		print(ply:Nick() .. " has joined team " .. theteam)
	end
	net.Start("mb_StartCharacterPick")
	net.Send(ply)
	if mb_RoundStatus == ROUND_ACTIVE then
		net.Start("mb_UpdateRoundTime")
			net.WriteUInt(CurTime() - mb_RoundTime, 16)
		net.Send(ply)
	end
end

function GM:PlayerSpawn( ply )
	if ply:Team() == TEAM_UNASSIGNED or ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_CONNECTING then
		ply:StripWeapons()
		ply:Spectate( OBS_MODE_ROAMING )
		return false
	else
		ply:UnSpectate()
	end
	local char = ply:GetCharacterDetails()
	if not char then return end
	ply:StripWeapons()
	if char.Weapon then ply:Give(char.Weapon) end
	ply:SetModel(char.Model)
	ply:SetMaxHealth(char.Health * ply.moba.mults[1])
	ply:SetHealth(char.Health * ply.moba.mults[1])
	char.OnInitialize(ply)
	ply:SetupHands()
end

function GM:PlayerDeath( victim, inflictor, attacker )
	if attacker:IsPlayer() then
		print(attacker:Nick() .. " has killed " .. victim:Nick())
	end
	local char = victim:GetCharacterDetails();
	if ( char ) then
		char.OnDeath( victim );
	end
	victim.RespawnTime = CurTime() + 3

	if not attacker:IsPlayer() and attacker:GetOwner() then attacker = attacker:GetOwner() end
	if attacker == victim then return end
	char = attacker:GetCharacterDetails()
	if not char then return end
	char.OnKill(attacker, victim)
end

function GM:ShouldCollide( ply, bot )
	if ( IsValid( ent1 ) and IsValid( ent2 ) and ent1:IsPlayer() and ent2:IsPlayer() and ent1:Team() == ent2:Team()) then return false end

	return true
end

function GM:PlayerDeathThink(ply)
	if ply.RespawnTime <= CurTime() then
		ply:Spawn()
	end
end

function GM:ShowHelp(ply)
	ply:ConCommand("mb_charmenu")
end

function GM:ShowTeam(ply)
	ply:ConCommand("mb_upgrademenu")
end

function GM:PlayerCanJoinTeam(ply, index)
	return false
end

function GM:PlayerFootstep(ply, pos, foot, sound, volume, filter)
	local char = ply:GetCharacterDetails()
	if char then
		if char.StepSounds then
			local s = char.StepSounds[math.random(#char.StepSounds)]
			ply:EmitSound(s, 75, 100, 0.4)
			return true
		end
	end
end

function GM:PlayerSay(sender, text, teamchat)
	if text == "!reddummy" then
		local dummy = player.CreateNextBot(CurTime())
		if dummy then
			dummy:SetCharacter("alyx_vance")
			dummy:SetTeam(TEAM_RED)
			dummy:UnSpectate()
			dummy:Spawn()
			dummy:SetPos(sender:GetEyeTrace().HitPos + Vector(0, 0, 10))
		end
		return ""
	elseif text == "!bluedummy" then
		local dummy = player.CreateNextBot(CurTime())
		if dummy then
			dummy:SetCharacter("alyx_vance")
			dummy:SetTeam(TEAM_BLUE)
			dummy:UnSpectate()
			dummy:Spawn()
			dummy:SetPos(sender:GetEyeTrace().HitPos + Vector(0, 0, 10))
		end
		return ""
	elseif text == "!stopmovement" then
		SetGlobalBool("botmove", false)
		return ""
	elseif text == "!startmovement" then
		SetGlobalBool("botmove", true)
		return ""
	elseif text == "!testtokens" then
		SetGlobalInt("UpgradeTokens", 20)
		print("New Upgrade Tokens: " .. GetGlobalInt("UpgradeTokens", 0))
		net.Start("mb_UpdateTokenCount")
			net.WriteUInt(GetGlobalInt("UpgradeTokens", 0), 16)
		net.Broadcast()
		return ""
	end
end

hook.Add("EntityTakeDamage", "PreventTeamKill", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if dmginfo:IsDamageType(DMG_FALL) then return end
	if not attacker:IsPlayer() then attacker = attacker:GetOwner() end
	if target:IsPlayer() and attacker then
		if target:Team() == attacker:Team() then
			return true
		end
		dmginfo:ScaleDamage(attacker.moba.mults[3])
	end
end)

/*function GM:Think()
	for k, v in ipairs(player.GetAll()) do
		if not v:Alive() then return end
		local char = v:GetCharacterDetails()
		if char then
			if char.Name == "DOG" then
				local move_dir = v:WorldToLocalAngles(v:GetVelocity():Angle())
				local vel = v:GetVelocity():Length()
				v:SetPoseParameter("move_yaw", move_dir.y)
				if vel > 0 or math.abs(math.AngleDifference(v:GetAngles().y, v:EyeAngles().y)) > 60 then
				    local angs = v:EyeAngles()
				    angs.p = 0  
				    v:SetAngles(angs)
				end
			end
		end
	end
end*/