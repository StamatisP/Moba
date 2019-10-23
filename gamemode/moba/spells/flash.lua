SPELL.Name		= "Flash";
SPELL.Icon		= "";
SPELL.Range		= 400;
//SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 1;

SPELL.OnInitalize = function()
end

SPELL.OnCast	= function( ply, direction )
	if not ply or not direction then print("no bot or direction!") return end
	ply:SetGravity(0)
	local desired_pos = direction:Forward()
	desired_pos:Mul(MOBA.Spells["flash"].Range)
	if desired_pos.z <= 0 then desired_pos.z = 0 end
	print("Flashing from " .. tostring(ply:GetPos()) .. " to " .. tostring(desired_pos))
	ply:SetPos(desired_pos)
	ply:SetGravity(1)
end