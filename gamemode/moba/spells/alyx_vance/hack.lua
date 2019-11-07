SPELL.Name		= "Hack"
SPELL.Icon		= ""
SPELL.Range		= 250
//SPELL.Sequence	= "canal5breact2" //What sequence/animation should it play
SPELL.Cooldown	= 15

SPELL.Description = "Hacks anything."

SPELL.OnInitalize = function()
	
end

SPELL.CanCast = function(ply)
	local tr = ply:GetEyeTrace()

	if tr.Entity and tr.Entity:GetPos():DistToSqr(ply:GetPos()) <= 250 * 250 then
		local ent = tr.Entity
		//PrintTable(ent:GetKeyValues())
		//print(ent:GetClass())

		if ent:IsPlayer() then
			// maybe you could slow down a player? speed up your team
			return true
		end
		if ent:GetClass() == "func_movelinear" then
			// open doors? or would this be useless
			//local keyval = ent:GetKeyValues()
			//if keyval["_spawn"] then print("NO SPAWN DOORS!") return false end
			return false
		end
		if ent:GetClass() == "mb_cap_trigger" or ent:GetClass() == "ent_mb_cap_point" then
			// do something wacky with the control point..
			// cant find a way to interact with it
			return false
		end
		if ent:GetClass() == "npc_manhack" or ent:GetClass() == "npc_cscanner" or ent:GetClass() == "combine_mine" then
			// will switch teams of the manhack/scanner to the other side, maybe even buff it? the mines should just trigger immediately
			return true
		end
		return false
	end
	return false
end

SPELL.OnCast	= function( ply, target )
	local tr = ply:GetEyeTrace()

	if tr.Entity and tr.Entity:GetPos():DistToSqr(ply:GetPos()) <= 250 * 250 then
		local ent = tr.Entity
		//print(ent:GetClass())

		if ent:IsPlayer() then
			if ent:Team() == ply:Team() then
				local old = ent.moba.mults[2]
				ent.moba.mults[2] = ent.moba.mults[2] * 1.25
				timer.Simple(5, function()
					ent.moba.mults[2] = old
				end)
			else
				local old = ent.moba.mults[2]
				ent.moba.mults[2] = ent.moba.mults[2] * 0.75
				timer.Simple(5, function()
					ent.moba.mults[2] = old
				end)
			end
		end
		if ent:GetClass() == "func_movelinear" then
			// NOT WORKING BECAUSE I CANT DISTINGUISH SPAWN DOORS
			local keyval = ent:GetKeyValues()
			PrintTable(keyval)
			if keyval["_spawn"] then print("DONT DO THIS TO SPAWN DOORS!") return end
			ent:Fire("Open")
			timer.Simple(5, function()
				ent:Fire("Close")
			end)
		end
		if ent:GetClass() == "mb_cap_trigger" or ent:GetClass() == "ent_mb_cap_point" then
			// do something wacky with the control point..
			return true
		end
		if ent:GetClass() == "npc_manhack" or ent:GetClass() == "npc_cscanner" or ent:GetClass() == "combine_mine" then
			if ent:GetClass() == "combine_mine" then
				ent:Fire("Disarm")
				return
			end
			PetIgnoreOwnTeam(ply, ent)
			ent:SetHealth(ent:Health() * 2)
		end

		ent:EmitSound("AlyxEMP.Discharge")

		local edata = EffectData()
		edata:SetOrigin(ent:GetPos())
		util.Effect("ManhackSparks", edata)
		ply:AddAccolade("alyx_successfulhacks", 1)
	end
end