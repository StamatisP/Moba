local hl2_music = {
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
	[16] = {song = "music/vlvx_song21.mp3", duration = 170}
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
			if err and errorName then
				ErrorNoHalt(err)
				print(errorName)
			end
			MusicChannel = audio_channel
			MusicChannel:SetVolume(0.6)
		end)
		music_duration = CurrentMusic.duration
		timer.Adjust("PlayMusic", music_duration)
	end)
end
hook.Add("mb_RoundStart", "StartMusic", PlayMusic)

local function StopMusic()
	if MusicChannel then
		MusicChannel:Stop()
		timer.Destroy("PlayMusic")
	end
end
hook.Add("mb_RoundEnd", "StopMusic", StopMusic)