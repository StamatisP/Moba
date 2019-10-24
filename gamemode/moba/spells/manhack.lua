SPELL.Name		= "Manhack";
SPELL.Icon		= "";
SPELL.Range		= -1;
SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 8;

SPELL.Description = "Spawns a Manhack pet that chases down enemies."

SPELL.OnInitalize = function()
end

SPELL.OnCast	= function( bot )
	if ( bot.moba.pet ) then 
		bot.moba.pet:Remove();
		bot.moba.pet = nil;
	end
	
	local pos = bot:GetPos() + Vector( 0, 0, 64 );
	pos = pos + ( bot:GetForward() * 12 );
	
	local manhack = ents.Create( "ent_moba_manhack" );
	manhack:SetPos( pos );
	manhack:Spawn();
	manhack:Activate();
	manhack:SetOwner( bot );
	
	bot.moba.pet = manhack;
end