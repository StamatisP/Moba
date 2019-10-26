SPELL.Name		= "Manhack Swarm";
SPELL.Icon		= "";
SPELL.Range		= -1;
SPELL.Sequence	= "gesture_signal_forward"; //What sequence/animation should it play
SPELL.Cooldown	= 8;

SPELL.Description = "Spawns a swarm of Manhacks."

SPELL.OnInitalize = function()
end

SPELL.OnCast	= function( ply )
	ply:StartAnimation(MOBA.Spells["manhack_swarm"].Sequence, false, nil, true)
	ply:EmitSound("/npc/metropolice/takedown.wav", 0)
	for i = 1, 15 do
		timer.Simple(math.Rand(0, 1.5), function()
			local pos = ply:GetPos() + Vector( math.random(-59, 50), math.random(-50, 50), math.random(20, 150) );
			pos = pos + ( ply:GetForward() * 12 );
			
			local manhack = ents.Create( "npc_manhack" );
			manhack:SetPos( pos );
			manhack:Spawn();
			manhack:Activate();
			manhack:SetOwner( ply );
			PetIgnoreOwnTeam(ply, manhack)
			
			timer.Simple(math.Rand(15, 17), function() 
				manhack:TakeDamage(999, ply, ply)
			end)
		end)
	end
end