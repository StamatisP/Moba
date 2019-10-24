CHARACTER.Name			= "DOG";
CHARACTER.Icon			= "";
CHARACTER.Role			= ROLE_TANK;
CHARACTER.Model			= "models/dog.mdl";
CHARACTER.Weapon		= nil;
CHARACTER.Health 		= 600

CHARACTER.AttackAnim	= "pound";
CHARACTER.AttackTime	= 0.6;
CHARACTER.AttackDmg		= 30; 

CHARACTER.Speed			= 0.8;

CHARACTER.Equipment = { 
	["head"] = "",
	["chest"] = "",
	["legs"] = "",
	["feet"] = ""
};

CHARACTER.Spells	= {
	[1] = "",
	[2] = "",
	[3] = "",
	[4] = ""
};

CHARACTER.OnDeath	= function( ply, bot )
end

CHARACTER.OnInitialize 	= function( ply, bot )
end

CHARACTER.OnAttack	= function( ply, bot, enemy, dmg )
end