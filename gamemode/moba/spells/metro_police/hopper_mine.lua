SPELL.Name		= "Hopper Mine"
SPELL.Icon		= ""
SPELL.Range		= 600
//SPELL.Sequence	= "canal5breact2" //What sequence/animation should it play
SPELL.Cooldown	= 12

SPELL.Description = "Spawns a Hopper Mine. It is a neutral mine, and will attack anyone."

SPELL.OnInitalize = function()
end

SPELL.CanCast = function(ply)
	return true
end

SPELL.OnCast	= function( ply, target )
	local hopper = ents.Create("combine_mine")
	if hopper then
		hopper:Spawn()
		hopper:Activate()
		local pos = ply:GetPos() + Vector( 0, 0, 60 )
		pos = pos + ( ply:GetForward() * 100 )
		hopper:SetPos(pos)
		hopper:SetOwner(ply)
		//PetIgnoreOwnTeam(ply, hopper)
	end
end