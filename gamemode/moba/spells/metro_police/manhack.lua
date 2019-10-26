SPELL.Name		= "Manhack";
SPELL.Icon		= "";
SPELL.Range		= -1;
SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 8;

SPELL.Description = "Spawns a Manhack pet that chases down enemies."

SPELL.OnInitalize = function()
end

SPELL.OnCast	= function( ply )
	if table.Count(ply.moba.pet) >= 2 then
		print("player has too many manhacks!")
		return
	end
	ply:EmitSound("npc/metropolice/vo/visceratordeployed.wav")
	
	local pos = ply:GetPos() + Vector( 0, 12, 64 );
	pos = pos + ( ply:GetForward() * 12 );
	
	local manhack = ents.Create( "npc_manhack" );
	manhack:SetPos( pos );
	manhack:Spawn();
	manhack:Activate();
	manhack:SetOwner( ply );
	PetIgnoreOwnTeam(ply, manhack)
	
	ply.moba.pet[manhack:EntIndex()] = manhack
	timer.Simple(16, function() 
		ply.moba.pet[manhack:EntIndex()]:TakeDamage(999, ply, ply)
		ply.moba.pet[manhack:EntIndex()] = nil
	end)
end