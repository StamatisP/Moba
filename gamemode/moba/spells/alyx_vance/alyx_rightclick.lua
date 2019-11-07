SPELL.Name		= "Change \n Firemode \n(Right Click)"
SPELL.Icon		= ""
SPELL.Range		= 9000
//SPELL.Sequence	= "canal5breact2" //What sequence/animation should it play
SPELL.Cooldown	= 1
SPELL.Passive = true

SPELL.Description = "Alyx can right click to change her weapons firemode."

SPELL.OnInitalize = function()
	
end

SPELL.CanCast = function(ply)
	return false
end

SPELL.OnCast	= function( ply, target )
	
end