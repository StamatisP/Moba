SPELL.Name		= "Throw Player"
SPELL.Icon		= ""
SPELL.Range		= 200
//SPELL.Sequence	= "canal5breact2" //What sequence/animation should it play
SPELL.Cooldown	= 6

SPELL.Description = "Grabs a player and throws them."

SPELL.OnInitalize = function()
end

SPELL.CanCast = function(ply)
	local target = GetClosestPlayer(ply, 200)
	if not target then print("no player close enough to throw") return end

	if not IsLookingAt(ply, target) then
		print("player is not looking at target!")
		return false
	end

	if ply:GetPos():DistToSqr(target:GetPos()) >= 200 * 200 then
		print("too far away from the player to throw!")
		//ply:ResetSpellCD(1)
		return false
	end
	return true
end

SPELL.OnCast	= function( ply, tgt )
	if not ply then print("no ply!!") return end

	target:SetPos(target:GetPos() + (Vector(0, 0, 60) ))
	target:Freeze(true)
	target:SetMoveType(MOVETYPE_NOCLIP)

	timer.Simple(1, function()
		local desired_pos = ply:GetEyeTrace().HitPos
		local dir = (target:GetPos() - desired_pos) * -1
		print("throwing player")
		target:Freeze(false)
		target:SetMoveType(MOVETYPE_WALK)
		dir:Normalize()
		dir:Mul(650)
		target:SetVelocity(dir)
	end)
end