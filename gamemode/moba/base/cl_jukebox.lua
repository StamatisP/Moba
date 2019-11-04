hl2_music = {
	[1] = {song = "music/hl1_song10.mp3", duration = 104},
	[2] = {song = "music/hl2_song12_long.mp3", duration = 74},
	[3] = {song = "music/hl2_song14.mp3", duration = 159},
	[4] = {song = "music/hl2_song29.mp3", duration = 135},
	[5] = {song = "music/hl2_song20_submix4.mp3", duration = 139},
	[6] = {song = "music/vlvx_song22.mp3", duration = 195},
	[7] = {song = "music/vlvx_song23.mp3", duration = 167},
	[8] = {song = "music/vlvx_song24.mp3", duration = 128},
	[9] = {song = "music/vlvx_song25.mp3", duration = 168},
	[10] = {song = "music/vlvx_song27.mp3", duration = 211},
	[11] = {song = "music/vlvx_song28.mp3", duration = 194},
	[12] = {song = "music/vlvx_song9.mp3", duration = 76},
	[13] = {song = "music/vlvx_song11.mp3", duration = 79},
	[14] = {song = "music/vlvx_song12.mp3", duration = 121},
	[15] = {song = "music/vlvx_song18.mp3", duration = 185},
	[16] = {song = "music/vlvx_song21.mp3", duration = 170},
	[17] = {song = "music/hl2_song3.mp3", duration = 90},
	[18] = {song = "music/hl2_song16.mp3", duration = 170}
}

intermission_music = {
	[1] = {song = "music/hl1_song17.mp3", duration = 123},
	[2] = {song = "music/hl1_song14.mp3", duration = 90},
	[3] = {song = "music/hl2_song30.mp3", duration = 104},
	[4] = {song = "music/hl2_song2.mp3", duration = 172}
}

local CurrentMusic
local MusicChannel
function PlayMusic(musictab)
	local music_duration = 1
	if timer.Exists("PlayMusic") then timer.Remove("PlayMusic") end
	if MusicChannel then MusicChannel:Stop() end
	timer.Create("PlayMusic", music_duration, 0, function()
		print("game music change")
		math.randomseed(os.time())
		CurrentMusic = musictab[GetPseudoRandomNumber(#musictab)]
		sound.PlayFile("sound/"..CurrentMusic.song, "", function(audio_channel, err, errorName)
			if err and errorName then
				ErrorNoHalt(err)
				print(errorName)
			end
			MusicChannel = audio_channel
			MusicChannel:SetVolume(0.55)
		end)
		music_duration = CurrentMusic.duration
		timer.Adjust("PlayMusic", music_duration + 4)
	end)
end
hook.Add("mb_RoundStart", "StartMusic", PlayMusic)
hook.Add("mb_Intermission", "IntermissionMusic", PlayMusic)

function StopMusic()
	if MusicChannel then
		MusicChannel:Stop()
		timer.Destroy("PlayMusic")
	end
end
hook.Add("mb_RoundEnd", "StopMusic", StopMusic)