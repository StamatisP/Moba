SPELL.Name		= "Hack Everything"
SPELL.Icon		= ""
SPELL.Range		= 450
//SPELL.Sequence	= "canal5breact2" //What sequence/animation should it play
SPELL.Cooldown	= 60
SPELL.Ultimate = true

SPELL.Description = "Hacks everything in a ".. SPELL.Range .. " unit radius."

SPELL.OnInitalize = function()
	
end

SPELL.CanCast = function(ply)
	//local enttab = ents.FindInSphere(ply:GetPos(), MOBA.Spells["hack_everything"].Range)

	return true
end

SPELL.OnCast	= function( ply, target )
	local enttab = ents.FindInSphere(ply:GetPos(), MOBA.Spells["hack_everything"].Range)

	for k, v in ipairs(enttab) do
		local ent = v
		//print(ent:GetClass())

		if ent:IsPlayer() then
			if ent:Team() == ply:Team() then
				local old = ent.moba.mults[2]
				ent.moba.mults[2] = ent.moba.mults[2] * 1.5
				timer.Simple(10, function()
					ent.moba.mults[2] = old
				end)
			else
				local old = ent.moba.mults[2]
				ent.moba.mults[2] = ent.moba.mults[2] * 0.75
				timer.Simple(10, function()
					ent.moba.mults[2] = old
				end)
			end
		end
		if ent:GetClass() == "func_movelinear" then
			// NOT WORKING BECAUSE I CANT DISTINGUISH SPAWN DOORS
			/*local keyval = ent:GetKeyValues()
			PrintTable(keyval)
			if keyval["_spawn"] then print("DONT DO THIS TO SPAWN DOORS!") return end
			ent:Fire("Open")
			timer.Simple(5, function()
				ent:Fire("Close")
			end)*/
		end
		if ent:GetClass() == "mb_cap_trigger" or ent:GetClass() == "ent_mb_cap_point" then
			// do something wacky with the control point..
		end
		if ent:GetClass() == "npc_manhack" or ent:GetClass() == "npc_cscanner" or ent:GetClass() == "combine_mine" then
			if ent:GetClass() == "combine_mine" then
				ent:Fire("Disarm")
			else
				PetIgnoreOwnTeam(ply, ent)
				ent:SetHealth(ent:Health() * 2)
			end
		end

		ent:EmitSound("AlyxEMP.Discharge")

		local edata = EffectData()
		edata:SetOrigin(ent:GetPos())
		util.Effect("ManhackSparks", edata)
	end
end