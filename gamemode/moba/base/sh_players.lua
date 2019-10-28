hook.Add("Move", "PlayerSpeed", function(ply, mv)
	local char = ply:GetCharacterDetails()
	if char then
		local name = char.Name
		local speed = mv:GetMaxSpeed()
		mv:SetMaxSpeed(speed * (char.Speed * ply.moba.speedmult))
		mv:SetMaxClientSpeed(speed * (char.Speed * ply.moba.speedmult))
	end
end)

hook.Add("StartCommand", "BotBehavior", function(ply, cmd)
	if ( !ply:IsBot() or !ply:Alive() ) then return end
	if not GetGlobalBool("botmove", false) then return end

	cmd:ClearMovement()
	cmd:ClearButtons()

	if ( !IsValid( ply.CustomEnemy ) ) then
		for id, pl in pairs( player.GetAll() ) do
			if ( !pl:Alive() or pl == ply ) then continue end
			ply.CustomEnemy = pl
		end
	end

	if ( !IsValid( ply.CustomEnemy ) ) then return end

	cmd:SetForwardMove( ply:GetWalkSpeed() )

	if ( ply.CustomEnemy:IsPlayer() ) then
		cmd:SetViewAngles( ( ply.CustomEnemy:GetShootPos() - ply:GetShootPos() ):GetNormalized():Angle() )
	else
		cmd:SetViewAngles( ( ply.CustomEnemy:GetPos() - ply:GetShootPos() ):GetNormalized():Angle() )
	end

	cmd:SetButtons( IN_ATTACK )

	if ( !ply.CustomEnemy:Alive() ) then
		ply.CustomEnemy = nil
	end
end)

local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end

function meta:GetCharacterDetails()
	local char = self:GetCharacter();
	if ( !MOBA.Characters[ char ] ) then return nil; end
	
	return MOBA.Characters[ char ];
end

function meta:GetCharacter()
	if not self.moba then return end
	return self.moba.character;
end