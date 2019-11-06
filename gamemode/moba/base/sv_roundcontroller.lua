mb_RoundStatus = mb_RoundStatus or ROUND_PREGAME // 0 is not started, 1 is started
mb_RoundEnd = mb_RoundEnd
mb_RoundTime = mb_RoundTime or 10 * 60
function StartRound()
	print("Round start!")
	net.Start("mb_RoundStart")
		net.WriteUInt(mb_RoundTime, 16)
	net.Broadcast()
	mb_RoundStatus = ROUND_ACTIVE
	mb_RoundEnd = CurTime() + mb_RoundTime
	for k, v in ipairs(player.GetAll()) do
		v:Spawn()	
	end
	timer.Simple(mb_RoundTime, function()
		EndRound()
	end)
	timer.Create("UpgradeTokenDist", mb_RoundTime / 10, 10, function()
		// okay, my idea for upgrade tokens is like this
		// you can spend a point to upgrade health, speed, or damage
		// each token is a 20% increase, relative to the character
		// dog gets more value out of maxing health than speed or damage, etc
		SetGlobalInt("UpgradeTokens", GetGlobalInt("UpgradeTokens", 0) + 1)
		print("New Upgrade Tokens: " .. GetGlobalInt("UpgradeTokens", 0))
		net.Start("mb_UpdateTokenCount")
			net.WriteUInt(GetGlobalInt("UpgradeTokens", 0), 16)
		net.Broadcast()
	end)
end

timer.Create("RoundCheckStart", 1, 0, function()
	if mb_RoundStatus == ROUND_PREGAME and team.NumPlayers(TEAM_BLUE) >= 2 and team.NumPlayers(TEAM_RED) >= 2 then
		StartRound()
		timer.Destroy("RoundCheckStart")
	end
end)

function EndRound()
	net.Start("mb_RoundEnd") // i could merge the two net messages and write an int but i dont wanna
	net.Broadcast()
	mb_RoundStatus = ROUND_END
	if team.TotalFrags(TEAM_BLUE) > team.TotalFrags(TEAM_RED) then
		print("Blue team win!")
	elseif team.TotalFrags(TEAM_RED) > team.TotalFrags(TEAM_BLUE) then
		print("Red team win!")
	else
		print("Stalemate")
	end
	for k, v in ipairs(player.GetAll()) do
		print(v:Name() .. " Accolades: ")
		PrintTable(v.moba.accolades)
	end
end