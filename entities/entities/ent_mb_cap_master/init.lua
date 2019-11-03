AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetMoveType( MOVETYPE_NONE )
	self:Activate()
	print("master cap load")
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:KeyValue(k, v)
	if k == "number_of_caps" then self:SetNumOfCaps(v) print("Number of caps is: " .. self:GetNumOfCaps()) end
end