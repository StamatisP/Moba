CHARACTER.Name			= "Alyx Vance";
CHARACTER.Icon			= "";
CHARACTER.Role			= ROLE_HEAL;
CHARACTER.Model			= "models/player/alyx.mdl";
CHARACTER.Weapon		= "weapon_pistol";

CHARACTER.AttackDmg		= 20 * 4; 

CHARACTER.Speed			= 220;

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

CHARACTER.OnDeath	= function( ply )
end

CHARACTER.OnInitialize 	= function( ply, bot )
end

CHARACTER.OnAttack	= function( ply, bot, enemy, dmg )
	
end