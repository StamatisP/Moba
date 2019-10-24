CHARACTER.Name			= "DOG";
CHARACTER.Icon			= "";
CHARACTER.Role			= ROLE_TANK;
CHARACTER.Model			= "models/dog.mdl";
CHARACTER.Weapon		= nil;
CHARACTER.Health 		= 600

CHARACTER.Description 	= "DOG is the loyal friend and bodyguard of Alyx. Hard to kill, and very slow."
CHARACTER.StepSounds	= {"npc/dog/dog_footstep1.wav",
							"npc/dog/dog_footstep2.wav",
							"npc/dog/dog_footstep3.wav",
							"npc/dog/dog_footstep4.wav"}

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

CHARACTER.OnDeath	= function( ply, bot )
end

CHARACTER.OnInitialize 	= function( ply )
	if ( ply.moba.pet ) then 
		ply.moba.pet:Remove()
		ply.moba.pet = nil
	end

	local pos = ply:GetPos() + Vector( 0, 0, 64 )
	pos = pos + ( ply:GetForward() * 12 )
	
	local ball = ents.Create( "ent_dog_ball" )
	ball:SetPos( pos )
	ball:Spawn()
	ball:Activate()
	ball:SetOwner( ply )
	
	ply.moba.pet = ball
end