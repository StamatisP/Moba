SPELL.Name		= "Manhack"
SPELL.Icon		= ""
SPELL.Range		= -1
SPELL.Sequence	= "canal5breact2" //What sequence/animation should it play
SPELL.Cooldown	= 10

SPELL.Description = "Spawns a Manhack pet that chases down enemies."

SPELL.OnInitalize = function()
end

SPELL.CanCast = function(ply)
	return true
end

SPELL.OnCast	= function( ply )
	ply:EmitSound("npc/metropolice/vo/visceratordeployed.wav")
	
	local pos = ply:GetPos() + Vector( 0, 12, 64 )
	pos = pos + ( ply:GetForward() * 12 )
	
	local manhack = ents.Create( "npc_manhack" )
	manhack:SetPos( pos )
	manhack:Spawn()
	manhack:Activate()
	manhack:SetOwner( ply )
	manhack:SetHealth(manhack:Health() * 2)
	PetIgnoreOwnTeam(ply, manhack)
	
	ply.moba.pet[manhack:EntIndex()] = manhack
	manhack:SetColor(team.GetColor(ply:Team()))
	manhack:SetRenderMode(RENDERMODE_TRANSCOLOR)
	timer.Simple(16, function()
		if IsValid(manhack) then
			manhack:TakeDamage(999, ply, ply)
		end
		ply.moba.pet[manhack:EntIndex()] = nil
	end)
end