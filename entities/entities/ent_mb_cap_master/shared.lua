ENT.Type 			= "point"

ENT.PrintName		= "Control Point Controller";
ENT.Author 			= "Whoever"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "NumOfCaps")
	for i = 1, 5 do
		self:NetworkVar("Entity", i - 1, "Cap"..i)
	end
end