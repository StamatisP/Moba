local hl2_music = {
	[1] = {song = "music/hl1_song10.mp3", duration = 104},
	[2] = {song = "music/hl2_song12_long.mp3", duration = 74},
	[3] = {song = "music/hl2_song14.mp3", duration = 159},
	[4] = {song = "music/hl2_song29.mp3", duration = 135},
	[5] = {song = "music/hl2_song20_submix4.mp3", duration = 139}
}

local CurrentMusic
local MusicChannel
local function PlayMusic()
	local music_duration = 1
	if timer.Exists("PlayMusic") then timer.Remove("PlayMusic") end
	timer.Create("PlayMusic", music_duration, 0, function()
		print("boss music change")
		math.randomseed(os.time())
		CurrentMusic = hl2_music[GetPseudoRandomNumber(#hl2_music)]
		sound.PlayFile("sound/"..CurrentMusic.song, "", function(audio_channel, err, errorName)
			if err then
				ErrorNoHalt(err)
				print(errorName)
			end
			MusicChannel = audio_channel
		end)
		music_duration = CurrentMusic.duration
		timer.Adjust("PlayMusic", music_duration)
	end)
end
//hook.Add("MBRoundStart", "Test", PlayMusic)
//hook.Run("MBRoundStart")