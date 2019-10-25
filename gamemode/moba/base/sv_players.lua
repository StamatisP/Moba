
function GM:Initialize()
end

function GM:PlayerAuthed(ply, steamid, uniqueid)
	net.Start("mb_StartCharacterPick")
	net.Send(ply)
end

function GM:PlayerInitialSpawn( ply )
	//ply:SetTeam( TEAM_BLUE );
	ply:Initialize()
	ply.RespawnTime = CurTime()
	ply:SetTeam(TEAM_SPECTATOR)
end

function GM:PlayerSpawn( ply )
	if ply:Team() == TEAM_UNASSIGNED or ply:Team() == TEAM_SPECTATOR then
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
	ply:SetMaxHealth(char.Health)
	ply:SetHealth(char.Health)
	char.OnInitialize(ply)
	ply:SetupHands()
end

function GM:PlayerDeath( ply )
	
	local char = ply:GetCharacterDetails();
	if ( char ) then
		char.OnDeath( ply );
	end
	ply.RespawnTime = CurTime() + 3
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

function GM:PlayerCanJoinTeam(ply, index)
	return false
end

function GM:PlayerFootstep(ply, pos, foot, sound, volume, filter)
	local char = ply:GetCharacterDetails()
	if char then
		if char.StepSounds then
			local s = char.StepSounds[math.random(#char.StepSounds)]
			ply:EmitSound(s)
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
	end
end

function GM:PlayerDeath(victim, inflictor, attacker)
	print(attacker)
	if not attacker:IsPlayer() and attacker:GetOwner() then attacker = attacker:GetOwner() end
	local char = attacker:GetCharacterDetails()
	if not char then return end
	char.OnKill(attacker, victim)
end

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