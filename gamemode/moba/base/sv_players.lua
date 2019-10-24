
function GM:Initialize()
end

function GM:PlayerAuthed(ply, steamid, uniqueid)
	net.Start("mb_StartCharacterPick")
	net.Send(ply)
end

function GM:PlayerInitialSpawn( ply )
	//ply:SetTeam( TEAM_BLUE );
	ply:Initialize();
	local theteam = team.BestAutoJoinTeam()
	ply:SetTeam(theteam)
	print(ply:Nick() .. " has joined team " .. theteam)
end

function GM:PlayerSpawn( ply )
	local char = ply:GetCharacterDetails()
	ply:StripWeapons()
	ply:Give(char.Weapon)
	ply:SetModel(char.Model)
	ply:SetMaxHealth(char.Health)
	ply:SetHealth(char.Health)
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
	return false;
end

function GM:PlayerDeathThink(ply)
	if ply.RespawnTime <= CurTime() then
		ply:Spawn()
	end
end

function GM:PlayerCanJoinTeam(ply, index)
	return false
end