ENT.Base = "base_brush"
ENT.Type = "brush"

if SERVER then
	function ENT:Initialize()
		self:SetSolid(SOLID_BBOX)
		//self:SetCollisionBounds(Vector mins, Vector maxs)
		self.cap_point = ents.FindByName(string.Left(self:GetName(), 4))[1]
		print(string.Left(self:GetName(), 4))
		if not self.cap_point then print("------- NO CAP POINT FOR " .. self:GetName()) end
		self.mins, self.maxs = self:GetCollisionBounds()
	end

	function ENT:StartTouch(entity)
		if not entity:IsPlayer() then return end
		print("yee snaw start")
		//self:TriggerOutput("OnCapTeam1", entity)
	end

	function ENT:EndTouch(entity)
		if not entity:IsPlayer() then return end
		print("yee snaw END")
		//self:TriggerOutput("OnCapTeam2", entity)
	end

	function ENT:AddProgress(team, mult)
		local cap = self.cap_point
		mult = 1
		
		if cap:GetCapProgress() >= (1 / engine.TickInterval()) * cap:GetCapTime() then
			// blue maxed it out
			if cap:GetCapStatus() ~= 1 then
				// blue just capped it
				cap:SetCapStatus(1)
				print("BLUE TEAM HAS CAPTURED THE POINT " .. cap:GetName())
				self:TriggerOutput("OnCapTeam1", entity)
			end
			if team == TEAM_RED then
				// red is attempting to cap maxed out blue cap
				cap:SetCapProgress(math.Approach(cap:GetCapProgress(), -cap:GetMaxProgress(), 1 * mult))
			end
			return
		elseif cap:GetCapProgress() <= (-1 / engine.TickInterval()) * cap:GetCapTime() then
			// red maxed it out
			if cap:GetCapStatus() ~= 2 then
				// red just capped it
				cap:SetCapStatus(2)
				print("RED TEAM HAS CAPTURED THE POINT " .. cap:GetName())
				self:TriggerOutput("OnCapTeam2", entity)
			end
			if team == TEAM_BLUE then
				// blue is attempting to cap maxed out red cap
				cap:SetCapProgress(math.Approach(cap:GetCapProgress(), cap:GetMaxProgress(), 1 * mult))
			end
			return
		end

		if team == TEAM_BLUE then
			cap:SetCapProgress(math.Approach(cap:GetCapProgress(), cap:GetMaxProgress(), 1 * mult))
		elseif team == TEAM_RED then
			cap:SetCapProgress(math.Approach(cap:GetCapProgress(), -cap:GetMaxProgress(), 1 * mult))
		end
	end

	function ENT:Touch(entity)
		if not entity:IsPlayer() then return end
		local cap = self.cap_point
		local plys, num = ents.FindPlayersInBox(self.mins, self.maxs)
		if num > 1 then
			local sameteam = false
			for i = 2, num do
				if plys[i]:Team() == plys[i-1]:Team() then
					sameteam = true
				end
			end

			if not sameteam then
				return
			else
				self:AddProgress(entity:Team(), math.Clamp(num, 1, 4))
			end
		elseif num == 1 then
			self:AddProgress(entity:Team())
		end
		// positive means blue capture, negative is red
		//print(cap:GetCapProgress())
		//print("marker")
	end

	function ENT:KeyValue(k, v)	
		if ( string.Left( k, 2 ) == "On" ) then
			self:StoreOutput( k, v )
			print(k, v)
		end
	end
end