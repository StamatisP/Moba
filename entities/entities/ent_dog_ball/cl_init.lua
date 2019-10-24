include( "shared.lua" )

function ENT:Draw()
	self:DrawModel()
	//render.DrawLine(self:GetPos(), LocalPlayer():GetEyeTrace().HitPos)
end