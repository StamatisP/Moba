ENT.Base			= "base_nextbot";

ENT.PrintName		= "Bot-Moba";
ENT.Author 			= "Brian Wynne";

local _debugangles = true
if CLIENT then

	function ENT:DrawHealth()
		local offset = Vector(0, 0, 86)
		local ang = LocalPlayer():EyeAngles()
		local mins, maxs = self:GetModelBounds()
		local pos = self:GetPos() + Vector(0, 0, maxs.z + 50) + ang:Up()

		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)

		cam.Start3D2D(pos, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 2)
			draw.DrawText(self:Health(), "HudSelectionText", 2, 2, team.GetColor(self:GetOwner():Team()), TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end

	function ENT:Draw()
		self:DrawModel()
		if self:GetOwner() != LocalPlayer() then return end
		if not _debugangles then return end

		local vector = gui.ScreenToVector( gui.MouseX(), gui.MouseY() ) * 99;
		local tr = util.QuickTrace( moba.campos, moba.campos + (vector * 10000), self );
		if tr.HitPos:DistToSqr(self:GetPos()) > 500 * 500 then
			// hypotenuse
			render.DrawLine(self:GetPos(), tr.HitPos, Color(255, 0, 0))
		else
			render.DrawLine(self:GetPos(), tr.HitPos, Color(0, 255, 0))
		end
		// opposite
		render.DrawLine(self:GetPos(), Vector(tr.HitPos.x, self:GetPos().y, tr.HitPos.z), Color(0, 0, 255))
		render.DrawLine(tr.HitPos, Vector(tr.HitPos.x, self:GetPos().y, tr.HitPos.z), Color(0, 0, 255))
		// adjacent
		render.DrawLine(self:GetPos(), Vector(self:GetPos().x, tr.HitPos.y, tr.HitPos.z), Color(0, 100, 255))
		render.DrawLine(tr.HitPos, Vector(self:GetPos().x, tr.HitPos.y, tr.HitPos.z), Color(0, 100, 255))
		local angle = 0
		angle = ( self:GetPos():Dot(tr.HitPos) / (self:GetPos():Length2D() * tr.HitPos:Length2D()) ) // this SHOULD be the cosine of theta...
		cam.Start2D()
			surface.SetFont("Default")
			surface.SetTextPos(gui.MouseX() + 20, gui.MouseY())
			surface.SetTextColor(255, 0, 0)
			surface.DrawText(math.deg(angle))
		cam.End2D()
		self:DrawHealth()
	end
end