SPELL.Name		= "Manhack";
SPELL.Icon		= "";
SPELL.Range		= -1;
SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 8;

SPELL.Description = "Spawns a Manhack pet that chases down enemies."

SPELL.OnInitalize = function()
end

SPELL.OnCast	= function( ply )
	if ( ply.moba.pet ) then
		print("player already has a manhack!")
		ply.moba.pet:Remove();
		ply.moba.pet = nil;
	end
	
	local pos = ply:GetPos() + Vector( 0, 0, 64 );
	pos = pos + ( ply:GetForward() * 12 );
	
	local manhack = ents.Create( "ent_moba_manhack" );
	manhack:SetPos( pos );
	manhack:Spawn();
	manhack:Activate();
	manhack:SetOwner( ply );
	
	ply.moba.pet = manhack;
end