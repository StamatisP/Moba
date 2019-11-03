include( "shared.lua" )

function ENT:Draw()
	//self:DrawModel()
end

function ENT:Initialize()
	self.m_bInitialized = true

	print("test please work for the lvoe of god	")
end

function ENT:Think()
	if ( not self.m_bInitialized ) then
		self:Initialize()
	end

	
end