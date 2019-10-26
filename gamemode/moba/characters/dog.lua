CHARACTER.Name			= "DOG";
CHARACTER.Icon			= "";
CHARACTER.Role			= ROLE_TANK;
CHARACTER.Model			= "models/dog.mdl";
CHARACTER.Weapon		= nil;
CHARACTER.Health 		= 600

CHARACTER.Description 	= "DOG is the loyal friend and bodyguard of Alyx. Hard to kill, and very slow."
CHARACTER.StepSounds	= VOMakeList("npc/dog/dog_footstep#.wav", 4)
CHARACTER.RunSounds 	= VOMakeList("npc/dog/dog_footstep_run#.wav", 8)

CHARACTER.Speed			= 0.8;

CHARACTER.Equipment = { 
	["head"] = "",
	["chest"] = "",
	["legs"] = "",
	["feet"] = ""
};

CHARACTER.Spells	= {
	[1] = "throw_ball",
	[2] = "return_ball",
	[3] = "throw_player",
	[4] = "dog_slam"
};

// sad is for dying, happy is for winning/kill streaks, angry is for losing
CHARACTER.VoiceOver = {
	sad = {
		[1] = "npc/dog/dog_scared1.wav",
		[2] = "npc/dog/dog_disappointed.wav",
		[3] = "npc/dog/dog_alarmed3.wav"
	},
	happy = {
		[1] = "npc/dog/dog_laugh1.wav",
		[2] = "npc/dog/dog_growl2.wav",
		[3] = "npc/dog/dog_growl3.wav"
	},
	angry = VOMakeList("npc/dog/dog_angry#.wav", 3)
}

CHARACTER.OnDeath	= function( ply, bot )
	ply:EmitSound(RandomVO("dog", "sad"))
	if table.Count(ply.moba.pet) == 1 then
		print("ply has ball, removing") 
		ply.moba.pet[ply.ballindex]:Remove()
		ply.moba.pet[ply.ballindex] = nil
	end
end

CHARACTER.OnInitialize 	= function( ply )
	if ( ply.moba.pet[ply.ballindex] ) then
		print("ply has ball, removing") 
		ply.moba.pet[ply.ballindex]:Remove()
		ply.moba.pet[ply.ballindex] = nil
	end

	local pos = ply:GetPos() + Vector( 0, 0, 64 )
	pos = pos + ( ply:GetForward() * 12 )
	
	local ball = ents.Create( "ent_dog_ball" )
	ball:SetPos( pos )
	ball:Spawn()
	ball:Activate()
	ball:SetOwner( ply )
	
	ply.moba.pet[ball:EntIndex()] = ball
	ply.ballindex = ball:EntIndex()
end

CHARACTER.OnKill = function(ply, victim)
	ply:EmitSound(RandomVO("dog", "happy"))
end