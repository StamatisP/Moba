mb_RoundStatus = ROUND_PREGAME // 0 is not started, 1 is started
mb_RoundEnd = nil
function StartRound()
	net.Start("mb_RoundStart")
	net.Broadcast()
	mb_RoundStatus = ROUND_ACTIVE
	mb_RoundEnd = CurTime() + (15 * 60)
	timer.Simple(15 * 60, function()
		EndRound()
	end)
end

function EndRound()
	net.Start("mb_RoundEnd") // i could merge the two net messages and write an int but i dont wanna
	net.Broadcast()
	mb_RoundStatus = ROUND_END
end

function UpdateRoundStatus()

end