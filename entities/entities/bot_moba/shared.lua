ENT.Base			= "base_nextbot";

ENT.PrintName		= "Bot-Moba";
ENT.Author 			= "Brian Wynne";

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		if self:GetOwner() != LocalPlayer() then return end

		local vector = gui.ScreenToVector( gui.MouseX(), gui.MouseY() ) * 99;
		local tr = util.QuickTrace( moba.campos, moba.campos + (vector * 10000), LocalPlayer() );
		if tr.HitPos:DistToSqr(self:GetPos()) > 500 * 500 then
			render.DrawLine(self:GetPos(), tr.HitPos, Color(255, 0, 0))
		else
			render.DrawLine(self:GetPos(), tr.HitPos, Color(0, 255, 0))
		end
	end
end