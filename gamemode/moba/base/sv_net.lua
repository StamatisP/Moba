
local function mb_GoPos( len, ply )
	local pos = net.ReadVector();
	ply:SetWaypoint( pos );
end
net.Receive( "mb_GoPos", mb_GoPos );

local function mb_Attak( len, ply )
	local target = net.ReadEntity();
	
	//if ( !IsValid(target) ) then return; end
	ply:AttackTarget( target );
end
net.Receive( "mb_Attak", mb_Attak );

local function mb_SendCharacterPick(len, ply)
	local char = net.ReadString()
	ply:SetCharacter(char)
	local theteam = team.BestAutoJoinTeam()
	ply:SetTeam(theteam)
	print(ply:Nick() .. " has joined team " .. theteam)
	ply:UnSpectate()
	ply:Spawn()
end
net.Receive("mb_SendCharacterPick", mb_SendCharacterPick)