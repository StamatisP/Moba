if SERVER then AddCSLuaFile() end
ENT.Type = "brush"
ENT.Base = "base_brush"

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self:SetTrigger(true)
end

function ENT:KeyValue(k, v)
	if k == "team" then self.team = v end
end

function ENT:StartTouch(ply)
	if ply:IsPlayer() and ply:Team() != tonumber(self.team) then
		ply:PrintMessage(HUD_PRINTTALK, "Don't go in the enemies spawn!")
		ply:Kill()
	else
		return
	end
end