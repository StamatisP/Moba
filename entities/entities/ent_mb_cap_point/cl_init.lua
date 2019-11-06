include( "shared.lua" )

function ENT:Draw()
	//self:DrawModel()
	local ang = LocalPlayer():EyeAngles()
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	local prog = self:GetCapProgress()
	local remapped = math.Round(math.Remap(prog, -self:GetMaxProgress(), self:GetMaxProgress(), -100, 100))
	cam.Start3D2D(self:GetPos(), Angle(0, ang.y, 90), 1)
		cam.IgnoreZ(true)
		local col = InterpolateColor(Color(90, 90, 255), Color(255, 90, 90), self:GetMaxProgress(), prog, -self:GetMaxProgress())
		draw.DrawText(remapped, "DermaLarge", 0, 0, col, TEXT_ALIGN_CENTER)
		cam.IgnoreZ(false)
	cam.End3D2D()
end