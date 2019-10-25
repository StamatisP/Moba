SPELL.Name		= "Throw Ball";
SPELL.Icon		= "";
SPELL.Range		= 2000;
//SPELL.Sequence	= "canal5breact2"; //What sequence/animation should it play
SPELL.Cooldown	= 4;

SPELL.Description = "Throws your ball " .. SPELL.Range .. " units."

SPELL.OnInitalize = function()
end

SPELL.OnCast	= function( ply, target )
	if not ply or not ply.moba.pet then print("no ply or ball pet!!") return end
	if ply:GetPos():DistToSqr(ply.moba.pet:GetPos()) >= 200 * 200 then
		print("too far away from the ball to throw!")
		//ply:ResetSpellCD(1)
		return
	end
	local ballphys = ply.moba.pet:GetPhysicsObject()
	ply.moba.pet:EmitSound("Weapon_CombineGuard.Special1")
	
	if ballphys then
		ballphys:SetVelocity(Vector(0, 0, 400))
		timer.Simple(0.3, function() ballphys:EnableMotion(false) end)

		timer.Simple(1.1, function()
			//local desired_pos = ply:GetAimVector()
			local desired_pos = ply:GetEyeTrace().HitPos
			if desired_pos then
				local dir = (ply.moba.pet:GetPos() - desired_pos) * -1
				print("throwing ball")
				ballphys:EnableMotion(true)
				ply.moba.pet:EmitSound("Weapon_AR2.Double")
				//desired_pos:Mul(MOBA.Spells["throw_ball"].Range)
				dir:Mul(2)
				ballphys:SetVelocity(dir)
			end
		end)
	end
end