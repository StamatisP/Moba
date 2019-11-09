AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/roller.mdl" )
	
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:Activate()
	
	local phys = self:GetPhysicsObject()
	if ( IsValid(phys) ) then
		phys:EnableGravity( true )
		phys:Wake()
	end
end

function ENT:Think()
	if ( !IsValid( self:GetOwner() )) then
		self:Remove()
		return
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if ( !owner ) then return end
	
	if not owner.moba then return end
	owner.moba.pet[self:EntIndex()] = nil
end

function ENT:PhysicsCollide(data, phys)
	if data.HitEntity:IsPlayer() then
		print("collide")
		if data.HitEntity == self:GetOwner() or data.HitEntity:Team() == self:GetOwner():Team() then return end
		local dmg = data.OurOldVelocity:Length()
		dmg = dmg * 0.8
		if dmg <= 40 then dmg = 0 return end
		dmg = math.Clamp(dmg, 0, 30)
		//data.HitEntity:TakeDamage(dmg, self:GetOwner(), self)
		self:GetPhysicsObject():SetVelocityInstantaneous(data.HitNormal * data.OurOldVelocity:Length() * -1)
		self:EmitSound("npc/roller/mine/rmine_explode_shock1.wav")
	end
end

function ENT:ReturnToOwner()
	local owner = self:GetOwner()
	if not owner then return end
	timer.Create("ReturnBall", 0.05, 0, function()
		self:SetModel("models/roller_spikes.mdl")
		local phys = self:GetPhysicsObject()
		local pos = self:GetPos()
		local offset = owner:GetPos()
		local dist = pos:Distance( offset )
		if ( pos:Distance( offset ) <= 80 ) then
			self:SetModel("models/roller.mdl")
			self:EmitSound("npc/roller/mine/rmine_taunt1.wav")
			phys:SetVelocityInstantaneous(Vector(0, 0, 0))
			timer.Destroy("ReturnBall")
			print("ball returned")
			return
		end

		local dir = (pos - offset) * -1
		if ( dist < 200 ) then
			dir = dir * 2
		elseif ( dist > 400 ) then
			dir = dir * 1.4
		end
		dir.z = dir.z * 2

		phys:ApplyForceCenter(dir * 5)
	end)
end