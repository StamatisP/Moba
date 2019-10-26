SPELL.Name		= "City Scanner";
SPELL.Icon		= "";
SPELL.Range		= 600;
//SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 25;

SPELL.Description = "Blinds enemies."

SPELL.OnInitalize = function()
end

SPELL.OnCast	= function( ply, target )
	local scanner = ents.Create("npc_cscanner")
	if scanner then
		scanner:Spawn()
		scanner:Activate()
		scanner:SetPos(ply:GetPos() + Vector(0, 0, 100))
		for k, v in ipairs(GetAlivePlayers()) do
			if v:Team() == ply:Team() then
				scanner:AddEntityRelationship(v, D_LI, 99)
				print(v:Nick() .. "is friend!")
			else
				scanner:AddEntityRelationship(ply, D_HT, 99)
			end
		end
		scanner:AddEntityRelationship(ply, D_LI, 99)
		timer.Simple(15, function()
			if IsValid(scanner) then
				scanner:TakeDamage(999, ply, ply)
			end
		end)
	end
end