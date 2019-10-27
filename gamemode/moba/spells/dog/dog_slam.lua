SPELL.Name		= "Disruption"
SPELL.Icon		= ""
SPELL.Range		= 300
//SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 1
SPELL.Damage 	= 100

SPELL.Description = "Knocks up every player within " .. SPELL.Range .. " units."

SPELL.OnInitalize = function()
end

SPELL.CanCast = function(ply)
	return true
end

SPELL.OnCast	= function( ply, tgt )
	local targets = GetClosestPlayerTable(ply, MOBA.Spells["dog_slam"].Range)
	if not targets then print("no targets!") end
	
	for i = 1, #targets do
		local enemy = targets[i]
		enemy:TakeDamage(MOBA.Spells["dog_slam"].Damage, ply, ply)
		enemy:SetVelocity(Vector(0, 0, math.random(350, 450)))
	end
	ply:EmitSound("physics/concrete/boulder_impact_hard4.wav")
end