local function mb_SendCharacterPick(len, ply)
	local char = net.ReadString()
	ply:Kill()
	ply:SetCharacter(char)
	if ply:Team() != TEAM_BLUE or ply:Team() != TEAM_RED then
		local theteam = team.BestAutoJoinTeam()
		ply:SetTeam(theteam)
		print(ply:Nick() .. " has joined team " .. theteam)
	end
	ply:UnSpectate()
	ply:Spawn()
end
net.Receive("mb_SendCharacterPick", mb_SendCharacterPick)

local message = "Your %s Multiplier is now %i%%!"
local function mb_ClientRequestUpgrade(len, ply)
	local spendabletokens = GetGlobalInt("UpgradeTokens", 0) - ply.moba.usedtokens
	if spendabletokens <= 0 then return end

	local perk = net.ReadUInt(4)
	ply.moba.mults[perk] = ply.moba.mults[perk] + 0.2
	ply:PrintMessage(HUD_PRINTTALK, string.format(message, PerkTranslate[perk], ply.moba.mults[perk] * 100))
end
net.Receive("mb_ClientRequestUpgrade", mb_ClientRequestUpgrade)