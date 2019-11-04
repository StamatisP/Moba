AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_gameplay/cap_point_base.mdl" )
	
	self:SetMoveType( MOVETYPE_NONE )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:Activate()
	
	local phys = self:GetPhysicsObject()
	if ( IsValid(phys) ) then
		phys:EnableGravity( false )
		phys:Wake()
	end

	self.cap_area = ents.FindByName(self:GetName() .. "_area")[1]
	if not self.cap_area then print(" -------- NO CAP AREA FOR " .. self:GetName() .. "!") end
	self.master = ents.FindByClass("ent_mb_cap_master")[1]
	if not self.master then print("------------ NO MASTER!!!!") end
	self.master:SetCap1(self)
end

function ENT:Think()
	if self:GetCapStatus() == 1 then
		team.AddScore(TEAM_BLUE, 1)
	elseif self:GetCapStatus() == 2 then
		team.AddScore(TEAM_RED, 1)
	end
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:OnCap(team)
	self:SetSkin(team)
	self.cap_area:TriggerOutput("OnCapTeam"..team, self, "prop_"..self:GetName()..",Skin,"..team..",0,-1")
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end