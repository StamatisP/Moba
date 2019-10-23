CHARACTER.Name			= "Alyx Vance";
CHARACTER.Icon			= "";
CHARACTER.Role			= ROLE_HEAL;
CHARACTER.Range			= 200;
CHARACTER.Model			= "models/Alyx.mdl";
CHARACTER.Weapon		= "weapon_pistol";

CHARACTER.AttackAnim	= "shootp1";
CHARACTER.AttackTime	= 0.5;
CHARACTER.AttackDmg		= 20 * 4; 

CHARACTER.Speed			= 180;

CHARACTER.Equipment = { 
	["head"] = "",
	["chest"] = "",
	["legs"] = "",
	["feet"] = ""
};

CHARACTER.Spells	= {
	[1] = "flash",
	[2] = "flash",
	[3] = "flash",
	[4] = "flash"
};

CHARACTER.OnDeath	= function( ply, bot )
end

CHARACTER.OnInitialize 	= function( ply, bot )
end

CHARACTER.OnAttack	= function( ply, bot, enemy, dmg )
	local bullet = {};
		bullet.Num 		  = 1;
		bullet.Src 		  = bot:EyePos();
		bullet.Dir 		  = bot:GetForward() * 32;
		bullet.Spread 	  = Vector(0, 0, 0);
		bullet.Tracer	  = 1;
		bullet.TracerName = "GaussTracer";
		bullet.Force	  = dmg * 0.5;
		bullet.Damage	  = dmg;
		bullet.AmmoType   = "pistol";
		
	bot:FireBullets( bullet );
end