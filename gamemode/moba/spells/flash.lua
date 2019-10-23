SPELL.Name		= "Flash";
SPELL.Icon		= "";
SPELL.Range		= 500;
//SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 1;

SPELL.OnInitalize = function()
end

SPELL.OnCast	= function( bot, desired_pos )
	if not bot or not desired_pos then print("no bot or desired pos!") return end
	local ply = bot:GetOwner()
	
	print("Flashing from " .. tostring(bot:GetPos()) .. " to " .. tostring(desired_pos))
	bot:SetPos(desired_pos)
end