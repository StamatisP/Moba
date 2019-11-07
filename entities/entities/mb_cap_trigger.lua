ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self:SetTrigger(true)
	//self:SetCollisionBounds(Vector mins, Vector maxs)
	self.cap_point = ents.FindByName(string.Left(self:GetName(), 4))[1]
	self.cap_prop = ents.FindByName("prop_"..string.Left(self:GetName(), 4))[1]
	print(string.Left(self:GetName(), 4))
	if not self.cap_point then print("------- NO CAP POINT FOR " .. self:GetName()) end
	self.mins, self.maxs = self:GetCollisionBounds()

	self.InterruptSound = "npc/roller/mine/rmine_taunt1.wav"
	//self.ChargeSound = CreateSound(self.cap_prop, "npc/combine_gunship/dropship_engine_distant_loop1.wav")
	self.CaptureSound = "npc/roller/remote_yes.wav"
	self.StartCap = "misc/hologram_start.wav"
	self.EndCap = "npc/roller/mine/rmine_predetonate.wav"
	self.LoopingSound = nil
end

function ENT:StartTouch(entity)
	if not entity:IsPlayer() then return end
	local plys, num = ents.FindPlayersInBox(self.mins, self.maxs)
end

function ENT:EndTouch(entity)
	if not entity:IsPlayer() then return end
	local plys, num = ents.FindPlayersInBox(self.mins, self.maxs)
end

function ENT:AddProgress(team, mult)
	local cap = self.cap_point
	mult = 1
	
	if cap:GetCapProgress() >= (1 / engine.TickInterval()) * cap:GetCapTime() then
		// blue maxed it out
		if cap:GetCapStatus() ~= 1 then
			// blue just capped it
			cap:SetCapStatus(1)
			self:EmitSound("npc/roller/remote_yes.wav")
			print("BLUE TEAM HAS CAPTURED THE POINT " .. cap:GetName())
			self:TriggerOutput("OnCapTeam1", entity)
			// i want a clientside hook on when a cap is triggered
			
			net.Start("hlhs_cpcaptured")
				net.WriteUInt(cap:EntIndex(), 16)
				net.WriteUInt(cap:GetCapStatus(), 3)
			net.Broadcast()

			local plys, num = ents.FindPlayersInBox(self.mins, self.maxs)
			for i = 1, num do
				local ply = plys[i]
				ply:PlayerVO("happy")
				ply:AddAccolade("pointcaptures", 1)
			end
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
			self:EmitSound("npc/roller/remote_yes.wav")
			print("RED TEAM HAS CAPTURED THE POINT " .. cap:GetName())
			self:TriggerOutput("OnCapTeam2", entity)

			net.Start("hlhs_cpcaptured")
				net.WriteUInt(cap:EntIndex(), 16)
				net.WriteUInt(cap:GetCapStatus(), 3)
			net.Broadcast()

			local plys, num = ents.FindPlayersInBox(self.mins, self.maxs)
			for i = 1, num do
				local ply = plys[i]
				ply:PlayerVO("happy")
			end
		end

		if team == TEAM_BLUE then
			// blue is attempting to cap maxed out red cap
			cap:SetCapProgress(math.Approach(cap:GetCapProgress(), cap:GetMaxProgress(), 1 * mult))
		end
		return
	elseif cap:GetCapProgress() == 0 then
		if cap:GetCapStatus() ~= 0 then
			cap:SetCapStatus(0)
			self.cap_prop:SetSkin(0)
			self:EmitSound("npc/roller/remote_yes.wav")
		end
	end

	if team == TEAM_BLUE then
		cap:SetCapProgress(math.Approach(cap:GetCapProgress(), cap:GetMaxProgress(), 1 * mult))
	elseif team == TEAM_RED then
		cap:SetCapProgress(math.Approach(cap:GetCapProgress(), -cap:GetMaxProgress(), 1 * mult))
	end
end

function ENT:CapSound(snd)
	print("here")
	if self.CurrentSound == snd then return end
	print("then here")
	if self.CurrentSound then self.CurrentSound:Stop() end
	self.CurrentSound = snd
	self.CurrentSound:Play()
end

function ENT:Touch(entity)
	if not entity:IsPlayer() or mb_RoundStatus ~= ROUND_ACTIVE then return end
	local cap = self.cap_point
	local plys, num = ents.FindPlayersInBox(self.mins, self.maxs)
	if num > 1 then
		local sameteam = true
		local sample = plys[1]:Team()
		for i = 2, num do
			if plys[i]:Team() ~= sample then
				sameteam = false
			end
		end

		if not sameteam then
			return
		else
			self:AddProgress(entity:Team())
		end
	elseif num == 1 then
		self:AddProgress(entity:Team())
	end
	// positive means blue capture, negative is red
	//print(cap:GetCapProgress())
	//print("marker")
end

function ENT:KeyValue(k, v)	
	//print(k, v)
	if ( string.Left( k, 2 ) == "On" ) then
		self:StoreOutput( k, v )
		print(k, v)
	end
end