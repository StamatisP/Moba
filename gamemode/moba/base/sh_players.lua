/*function GM:CalcMainActivity(ply, vel)
	local plychar = ply:GetCharacterDetails()
	if plychar and plychar.CalcMainActivity then
		local ideal, override = plychar.CalcMainActivity(ply, vel)
		if ideal then
			return ideal, override
		end
	end

	pt = ply:GetTable()

	-- Handle landing
	onground = ply:OnGround()
	if onground and not pt.m_bWasOnGround then
		ply:AnimRestartGesture(GESTURE_SLOT_JUMP, ACT_LAND, true)
		pt.m_bWasOnGround = true
	end
	--

	-- Handle jumping
	-- airwalk more like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation
	-- underwater we're alright we airwalking
	waterlevel = ply:WaterLevel()
	if pt.m_bJumping then
		if pt.m_bFirstJumpFrame then
			pt.m_bFirstJumpFrame = false
			ply:AnimRestartMainSequence()
		end

		if waterlevel >= 2 or CurTime() - pt.m_flJumpStartTime > 0.2 and onground then
			pt.m_bJumping = false
			pt.m_fGroundTime = nil
			ply:AnimRestartMainSequence()
		else
			return ACT_MP_JUMP, -1
		end
	elseif not onground and waterlevel <= 0 then
		if not pt.m_fGroundTime then
			pt.m_fGroundTime = CurTime()
		elseif CurTime() > pt.m_fGroundTime and vel:Length2DSqr() < 0.5 then
			pt.m_bJumping = true
			pt.m_bFirstJumpFrame = false
			pt.m_flJumpStartTime = 0
		end
	end
	--

	-- Handle ducking
	if ply:Crouching() then
		if vel:Length2DSqr() >= 1 then
			return ACT_MP_CROUCHWALK, -1
		end

		return ACT_MP_CROUCH_IDLE, -1
	end
	--

	-- Handle swimming
	if not onground and waterlevel >= 2 then
		return ACT_MP_SWIM, -1
	end
	--

	len2d = vel:Length2DSqr()
	if len2d >= 22500 then -- 150^2
		return ACT_MP_RUN, -1
	end

	if len2d >= 1 then
		return ACT_MP_WALK, -1
	end

	return ACT_MP_STAND_IDLE, -1
end*/

hook.Add("CalcMainActivity", "DogAnims", function(ply, vel)
	local plychar = ply:GetCharacterDetails()
	if plychar and plychar.CalcMainActivity then
		local ideal, override = plychar.CalcMainActivity(ply, vel)
		if ideal then
			return ideal, override
		end
	end
end)

hook.Add("DoAnimationEvent", "SpellAnims", function(ply, event, data)
	ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, data, true)
end)

hook.Add("Move", "PlayerSpeed", function(ply, mv)
	local char = ply:GetCharacterDetails()
	if char then
		local speed = mv:GetMaxSpeed()
		mv:SetMaxSpeed(speed * (char.Speed * ply.moba.mults[2]))
		mv:SetMaxClientSpeed(speed * (char.Speed * ply.moba.mults[2]))
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
			if pl:Team() == ply:Team() then continue end
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