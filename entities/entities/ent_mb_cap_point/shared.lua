ENT.Type 			= "anim"

ENT.PrintName		= "Control Point";
ENT.Author 			= "Whoever"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "CapProgress")
	self:NetworkVar("Int", 1, "CapStatus") // 0 is uncapped, 1 is blue cap, 2 is red cap
	self:NetworkVar("Int", 2, "CapTime") // tickrate * this = time to cap (in seconds)
	self:NetworkVar("Int", 3, "MaxProgress") // 1 / tickrate * captime

	if SERVER then
		self:SetCapProgress(0)
		self:SetCapStatus(0)
		self:SetCapTime(5)
		self:SetMaxProgress( ( (1 / engine.TickInterval()) * self:GetCapTime() ) + 1 )
	end
end