if SERVER then AddCSLuaFile() end
ENT.Type = "anim"

function ENT:Initialize()
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	self:SetModel( "models/props_phx/misc/gibs/egg_piece4.mdl" )
    self:SetMoveType( MOVETYPE_NONE )
    self:SetSolid( SOLID_VPHYSICS )

    self:SetCustomCollisionCheck( true )
	
	self.mins, self.maxs = self:GetCollisionBounds()
	print(self:GetCollisionBounds())
	self:PhysicsInitBox(self.mins, self.maxs)
	local physobj = self:GetPhysicsObject()
	if IsValid(physobj) then
		physobj:EnableMotion( false )
	end
	
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_NONE)

	self:SetSolidFlags( FSOLID_CUSTOMBOXTEST + FSOLID_CUSTOMRAYTEST ) // without this it never checks collision
	self:SetPos(Vector(	3056, 2304 + math.random(-50, 50), 48))

	self:CollisionRulesChanged()
	print("yeed")
end

function ENT:ShouldCollide(ent)
	print("own team is " .. self:GetTeam() .. ", player team is " .. ent:Team())
	if ent:IsPlayer() and ent:Team() == self:GetTeam() then return true end
	return false
end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end

if SERVER then
	function ENT:KeyValue(k, v)
		if k == "team" then print("its a yeet") self:SetTeam(v) end
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Team")
end

function ENT:Draw()
	cam.IgnoreZ(true)
	self:DrawModel()
	cam.IgnoreZ(false)
end