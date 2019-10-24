CHARACTER.Name			= "Alyx Vance";
CHARACTER.Icon			= "";
CHARACTER.Role			= ROLE_HEAL;
CHARACTER.Model			= "models/player/alyx.mdl";
CHARACTER.Weapon		= "weapon_alyx_gun";
CHARACTER.Health 		= 200

CHARACTER.AttackDmg		= 20 * 4; 

CHARACTER.Speed			= 1.8; // this is a multiplier

CHARACTER.Description 	= "A figurehead for the Resistance, Alyx is a highly mobile damage dealer, whose weapon can change into an SMG, pistol, or rifle."

CHARACTER.Equipment = { 
	["head"] = "",
	["chest"] = "",
	["legs"] = "",
	["feet"] = ""
};

CHARACTER.Spells	= {
	[1] = "dash",
	[2] = "",
	[3] = "",
	[4] = ""
};

CHARACTER.OnDeath	= function( ply )
end

CHARACTER.OnInitialize 	= function( ply )
end

CHARACTER.OnAttack	= function( ply, bot, enemy, dmg )
	
end