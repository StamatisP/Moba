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
	ply:SetColor(team.GetColor(ply:Team()))
	char.OnInitialize(ply)
	ply:SetupHands()
end

/*function GM:PlayerDeath( victim, inflictor, attacker )
	//if attacker:IsPlayer() then
		//print(attacker:Nick() .. " has killed " .. victim:Nick())
	//end
	local char = victim:GetCharacterDetails()
	if ( char ) then
		char.OnDeath( victim )
	end
	victim.RespawnTime = CurTime() + 5

	if attacker:GetClass() == "ent_dog_ball" then
		attacker:GetOwner():AddAccolade("dog_successfulballkills", 1)
	end

	if not attacker:IsPlayer() and attacker.GetOwner then attacker = attacker:GetOwner() end
	if attacker == victim or attacker == game.GetWorld() then return end

	char = attacker:GetCharacterDetails()
	if not char then return end
	char.OnKill(attacker, victim)

	attacker:AddAccolade("kills", 1)

	team.AddScore(attacker:Team(), 1)
	
	// send net message to player

	net.Start("hlhs_PlayerKillPlayer")
		net.WriteEntity( victim )
		net.WriteString( inflictor:GetClass() )
		net.WriteEntity( attacker )
	net.Broadcast()
	MsgAll(attacker:Nick() .. " killed " .. victim:Nick() .. " using " .. inflictor:GetClass() .. "\n" )
end*/

hook.Add("PlayerDeath", "HLHS_Death", function(victim, inflictor, attacker)
	local victimchar = victim:GetCharacterDetails()
	if ( victimchar ) then
		victimchar.OnDeath( victim )
	end
	victim.RespawnTime = CurTime() + 5

	if attacker == victim then return end // if suicide then dont do anything else

	if attacker:GetClass() == "ent_dog_ball" then
		attacker:GetOwner():AddAccolade("dog_successfulballkills", 1)
	end
	if inflictor:GetClass() == "weapon_stunstick" and attacker:IsPlayer() then
		attacker:AddAccolade("metro_successfulstuns", 1)
	end

	if not attacker:IsPlayer() then
		if attacker:GetOwner() then attacker = attacker:GetOwner() end // if the attacker is a pet then get the owner
		if attacker:GetClass() == "func_movelinear" then return end
	end
	local attackchar = attacker:GetCharacterDetails()
	if attackchar then
		attackchar.OnKill(attacker, victim)
	end
	
	attacker:AddAccolade("kills", 1)

	team.AddScore(attacker:Team(), 1)
end)

function GM:ShouldCollide( ent1, ent2 )
	//if ( IsValid( ent1 ) and IsValid( ent2 ) and ent1:IsPlayer() and ent2:IsPlayer() and ent1:Team() == ent2:Team()) then return false end
	// ,may be horribly broken

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
		SetGlobalInt("UpgradeTokens", 100)
		print("New Upgrade Tokens: " .. GetGlobalInt("UpgradeTokens", 0))
		net.Start("mb_UpdateTokenCount")
			net.WriteUInt(GetGlobalInt("UpgradeTokens", 0), 16)
		net.Broadcast()
		return ""
	elseif text == "!endround" then
		EndRound()
		return ""
	end
end

hook.Add("EntityTakeDamage", "PreventTeamKill", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	//print(dmginfo:GetAttacker(), dmginfo:GetDamageType())
	if (attacker == game.GetWorld()) and dmginfo:IsDamageType(DMG_FALL) or dmginfo:IsDamageType(DMG_CRUSH) then return end

	if not attacker:IsPlayer() then attacker = attacker:GetOwner() end
	if target:IsPlayer() and attacker:IsPlayer() then
		if target:Team() == attacker:Team() then
			return true
		end
		dmginfo:ScaleDamage(attacker.moba.mults[3])
		attacker:AddAccolade("damage", dmginfo:GetDamage())
	end
end)