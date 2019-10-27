SPELL.Name		= "City Scanner";
SPELL.Icon		= "";
SPELL.Range		= 600;
//SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 25;

SPELL.Description = "Blinds enemies."

SPELL.OnInitalize = function()
end

SPELL.CanCast = function(ply)
	return true
end

SPELL.OnCast	= function( ply, target )
	ply:EmitSound("npc/metropolice/vo/airwatchsubjectis505.wav")
	local scanner = ents.Create("npc_cscanner")
	if scanner then
		scanner:Spawn()
		scanner:Activate()
		scanner:SetPos(ply:GetPos() + Vector(0, 0, 100))
		PetIgnoreOwnTeam(ply, scanner)
		timer.Simple(15, function()
			if IsValid(scanner) then
				scanner:TakeDamage(999, ply, ply)
			end
		end)
	end
end