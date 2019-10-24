CHARACTER.Name			= "Metro Police";
CHARACTER.Icon			= "";
CHARACTER.Role			= ROLE_DPS;
CHARACTER.Range			= 48;
CHARACTER.Model			= "models/player/police.mdl";
CHARACTER.Weapon		= "weapon_stunstick";
CHARACTER.Health 		= 200

CHARACTER.AttackAnim	= "swing";
CHARACTER.AttackTime	= 0.6;
CHARACTER.AttackDmg		= 3;

CHARACTER.Speed			= 1.4;

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

CHARACTER.OnDeath	= function( ply, bot )
end

CHARACTER.OnInitialize 	= function( ply, bot )
end

CHARACTER.OnAttack	= function( ply, bot, enemy )
end