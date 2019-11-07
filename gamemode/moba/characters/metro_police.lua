CHARACTER.Name			= "Metro Police"
CHARACTER.Icon			= ""
CHARACTER.Role			= ROLE_DPS
CHARACTER.Model			= "models/player/police.mdl"
CHARACTER.Weapon		= "weapon_stunstick"
CHARACTER.Health 		= 200

CHARACTER.Description 	= "A human volunteer that decided to side with the Combine. They stun and disorient players."
CHARACTER.StepSounds	= VOMakeList("npc/metropolice/gear#.wav", 6)

CHARACTER.Speed			= 1.1

CHARACTER.Equipment = { 
	["head"] = "",
	["chest"] = "",
	["legs"] = "",
	["feet"] = ""
}

CHARACTER.Spells	= {
	[1] = "manhack",
	[2] = "cityscanner",
	[3] = "hopper_mine",
	[4] = "manhack_swarm"
}

CHARACTER.VoiceOver = {
	sad = {
		[1] = "npc/metropolice/vo/officerneedshelp.wav"
	},
	happy = {
		[1] = "npc/metropolice/vo/chuckle.wav",
		[2] = "npc/metropolice/vo/protectioncomplete.wav"
	},
	angry = {
		[1] = "npc/metropolice/vo/shit.wav"
	},
	death = VOMakeList("/npc/metropolice/die#.wav", 4)
}

CHARACTER.OnDeath	= function( ply )
	ply:PlayerVO("death")
end

CHARACTER.OnInitialize 	= function( ply )
	ply:EmitSound("npc/combine_soldier/vo/teamdeployedandscanning.wav")
end

CHARACTER.OnAttack	= function( ply, bot, enemy )
end

CHARACTER.OnKill = function(ply, victim)
	ply:PlayerVO("happy")
end