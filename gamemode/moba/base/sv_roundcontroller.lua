mb_RoundStatus = ROUND_PREGAME // 0 is not started, 1 is started
mb_RoundEnd = nil
function StartRound()
	print("Round start!")
	net.Start("mb_RoundStart")
		net.WriteUInt((15 * 60), 16)
	net.Broadcast()
	mb_RoundStatus = ROUND_ACTIVE
	mb_RoundEnd = CurTime() + (15 * 60)
	for k, v in ipairs(player.GetAll()) do
		v:Spawn()	
	end
	timer.Simple(15 * 60, function()
		EndRound()
	end)
end

timer.Create("RoundCheckStart", 1, 0, function()
	if mb_RoundStatus == ROUND_PREGAME and team.NumPlayers(TEAM_BLUE) >= 2 and team.NumPlayers(TEAM_RED) >= 2 then
		StartRound()
	end
end)

function EndRound()
	net.Start("mb_RoundEnd") // i could merge the two net messages and write an int but i dont wanna
	net.Broadcast()
	mb_RoundStatus = ROUND_END
end

function UpdateRoundStatus()

end