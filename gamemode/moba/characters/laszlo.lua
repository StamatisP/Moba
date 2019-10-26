CHARACTER.Name			= "Laszlo"
CHARACTER.Icon			= ""
CHARACTER.Role			= ROLE_TANK
CHARACTER.Model			= "models/humans/group02/male_05.mdl"
CHARACTER.Weapon		= nil
CHARACTER.Health 		= 200

CHARACTER.Description 	= "Being the finest mind of his generation, Laszlo has tamed antlions."
//HARACTER.StepSounds	= VOMakeList("npc/dog/dog_footstep#.wav", 4) // 
//CHARACTER.RunSounds 	= VOMakeList("npc/dog/dog_footstep_run#.wav", 8) // 

CHARACTER.Speed			= 1

CHARACTER.Equipment = { 
	["head"] = "",
	["chest"] = "",
	["legs"] = "",
	["feet"] = ""
}

CHARACTER.Spells	= {
	[1] = "",
	[2] = "",
	[3] = "",
	[4] = ""
}

// sad is for dying, happy is for winning/kill streaks, angry is for losing
CHARACTER.VoiceOver = {
	sad = {

	},
	happy = {

	},
	angry = {

	}
}

CHARACTER.OnDeath	= function( ply, bot )
	
end

CHARACTER.OnInitialize 	= function( ply )
	// on spawn
end

CHARACTER.OnKill = function(ply, victim)
	
end