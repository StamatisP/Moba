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
	local winning_team = nil
	if team.GetScore(TEAM_BLUE) > team.GetScore(TEAM_RED) then
		print("Blue team win!")
		winning_team = TEAM_BLUE
	elseif team.GetScore(TEAM_RED) > team.GetScore(TEAM_BLUE) then
		print("Red team win!")
		winning_team = TEAM_RED
	else
		print("Stalemate")
		winning_team = 0
	end

	net.Start("mb_RoundEnd") // i could merge the two net messages and write an int but i dont wanna
		net.WriteUInt(winning_team, 4) // what team won
		local entries = 0
		for k, v in ipairs(player.GetAll()) do
			for k2, v2 in pairs(v.moba.accolades) do
				entries = entries + 1
			end
		end
		net.WriteUInt(entries, 32)
		for k, v in ipairs(player.GetAll()) do
			for k2, v2 in pairs(v.moba.accolades) do
				print(v:UserID())
				net.WriteUInt(v:UserID(), 8)
				net.WriteString(k2)
				net.WriteUInt(v2, 16)
			end
		end
	net.Broadcast()
	mb_RoundStatus = ROUND_END
end