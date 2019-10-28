
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
	ply:Kill()
	ply:SetCharacter(char)
	local theteam = team.BestAutoJoinTeam()
	ply:SetTeam(theteam)
	print(ply:Nick() .. " has joined team " .. theteam)
	ply:UnSpectate()
	ply:Spawn()
end
net.Receive("mb_SendCharacterPick", mb_SendCharacterPick)

local PerkTranslate = {
	[1] = "Health",
	[2] = "Speed",
	[3] = "Damage"
}
local function mb_ClientRequestUpgrade(len, ply)
	local spendabletokens = GetGlobalInt("UpgradeTokens", 0) - ply.moba.usedtokens
	if spendabletokens <= 0 then return end

	local perk = net.ReadUInt(4)
	local message = "Your %s Multiplier is now %f!"
	if perk == 1 then
		ply.moba.healthmult = ply.moba.healthmult + 0.2
		ply:PrintMessage(HUD_PRINTTALK, string.format(message, PerkTranslate[perk], math.floor(ply.moba.healthmult * 100)))
	elseif perk == 2 then
		ply.moba.speedmult = ply.moba.speedmult + 0.2
		ply:PrintMessage(HUD_PRINTTALK, string.format(message, PerkTranslate[perk], math.floor(ply.moba.speedmult * 100)))
	elseif perk == 3 then
		ply.moba.damagemult = ply.moba.damagemult + 0.2
		ply:PrintMessage(HUD_PRINTTALK, string.format(message, PerkTranslate[perk], math.floor(ply.moba.damagemult * 100)))
	end
end
net.Receive("mb_ClientRequestUpgrade", mb_ClientRequestUpgrade)