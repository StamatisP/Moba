SPELL.Name		= "Dash";
SPELL.Icon		= "";
SPELL.Range		= 600;
//SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 3

SPELL.Description = "Dashes you forward " .. SPELL.Range .. " units."

SPELL.OnInitalize = function()
	
end

SPELL.CanCast = function(ply)
	return true
end

SPELL.OnCast	= function( ply, target )
	if not ply then print("no ply!") return end
	local desired_pos = ply:GetAimVector()
	desired_pos:Mul(MOBA.Spells["dash"].Range)
	desired_pos:Mul(ply:GetMult("Speed"))
	ply:SetVelocity(desired_pos)
end