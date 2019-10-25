CHARACTER.Name			= "Metro Police";
CHARACTER.Icon			= "";
CHARACTER.Role			= ROLE_DPS;
CHARACTER.Model			= "models/player/police.mdl";
CHARACTER.Weapon		= "weapon_stunstick";
CHARACTER.Health 		= 200

CHARACTER.Description 	= "A human volunteer that decided to side with the Combine. They stun and disorient players."

CHARACTER.Speed			= 1.2;

CHARACTER.Equipment = { 
	["head"] = "",
	["chest"] = "",
	["legs"] = "",
	["feet"] = ""
};

CHARACTER.Spells	= {
	[1] = "manhack",
	[2] = "",
	[3] = "",
	[4] = ""
};

CHARACTER.OnDeath	= function( ply )
end

CHARACTER.OnInitialize 	= function( ply )
end

CHARACTER.OnAttack	= function( ply, bot, enemy )
end

CHARACTER.OnKill = function(ply, victim)
	
end