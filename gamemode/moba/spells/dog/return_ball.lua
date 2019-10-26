SPELL.Name		= "Return Ball";
SPELL.Icon		= "";
SPELL.Range		= 600;
//SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 2;

SPELL.Description = "Returns your ball to you."

SPELL.OnInitalize = function()
end

SPELL.OnCast	= function( ply, target )
	if not ply or not ply.moba.pet[ply.ballindex] then print("no ply or pet!") return end
	ply.moba.pet[ply.ballindex]:ReturnToOwner()
end