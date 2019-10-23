local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end

function meta:Initialize()
	self.moba = {};
		self.moba.bot = nil;
		self.moba.character = "";
		self.moba.spells = {}; //This is used for ONLY cooldowns
		
	self:SetCharacter( "alyx_vance" );
	self:SetTeam( TEAM_BLUE );
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON );
	self:SetMoveType( MOVETYPE_NONE );
	self:SetModel( "models/Player.mdl" );
	self:DrawViewModel( false );
	self:SetJumpPower( 0 );
end

function meta:AssignBot()
	if ( self.moba.bot ) then return; end
	
	local nextbot = ents.Create( "bot_moba" );
	nextbot:SetPos( self:GetPos() );
	nextbot:SetOwner( self );
	nextbot:Spawn();
	nextbot:Activate();
	//nextbot:SetTeam( self:Team() );
	
	net.Start( "mb_Bot" );
		net.WriteEntity( nextbot );
	net.Send( self );
	
	self:SetParent( nextbot );
	self:Spectate( OBS_MODE_FIXED );
	self:SpectateEntity( nextbot );
	
	//GAMEMODE:SetPlayerSpeed( self, 0.01, 0.01 ); deprecated
	
	self.moba.bot	= nextbot;
	
	local char = self:GetCharacterDetails();
	if ( !char ) then return; end
	char.OnInitialize( self, nextbot );
	
	nextbot:SetModel( char.Model );
	nextbot:SetSpeed( char.Speed );
	nextbot:EquipWeapon( char.Weapon );
end

function meta:SetWaypoint( pos )
	if ( !self:GetBot() ) then return; end
	
	self:GetBot():SetWaypoint( pos );
end

function meta:AttackTarget( ent )
	if ( !self:GetBot() ) then return; end
	self:GetBot():AttackTarget( ent );
end

function meta:SetCharacter( char )
	if ( self.moba.character == char ) then return; end
	
	self.moba.character = char;
	
	net.Start( "mb_Char" );
		net.WriteString( char );
	net.Send( self );
	
	local char = self:GetCharacterDetails();
	if ( !char ) then return; end
	
	local spells = char.Spells;
	local equipment = char.Equipment;
	
	net.Start( "mb_Spell" );
		net.WriteTable( spells );
	net.Send( self );
	
	net.Start( "mb_Equip" );
		net.WriteTable( equipment );
	net.Send( self );
end

function meta:CastSpell( slot )
	if ( !self.moba.bot || (self.moba.spells[ slot ] && CurTime() < self.moba.spells[ slot ]) ) then return; end
	local char = self:GetCharacterDetails();
	local spell = char.Spells;
	spell = MOBA.Spells[ spell[slot] ];
	
	if ( !spell ) then return; end
	if spell.Range and self.moba.bot:GetPos():DistToSqr(self.MousePos) > spell.Range * spell.Range then 
		print("out of range! casting at max range... ") 

		local arct = math.atan(self.MousePos.x / self.MousePos.y)
		arct = math.deg(arct) // 1 radian to 57.2958 degrees
		local xpos = (math.sin(arct) * spell.Range) + self:GetPos().x
		local ypos = (math.cos(arct) * spell.Range) + self:GetPos().y
		local desired_pos = Vector(xpos, ypos, self.MousePos.z)

		spell.OnCast( self.moba.bot, desired_pos );
		self.moba.spells[ slot ] = CurTime() + spell.Cooldown;
		
		local seq = spell.Sequence;
		self:GetBot():CastSpell( seq );

		return
	end
	spell.OnCast( self.moba.bot,  self.MousePos);
	
	self.moba.spells[ slot ] = CurTime() + spell.Cooldown;
	
	local seq = spell.Sequence;
	self:GetBot():CastSpell( seq );
end

function meta:GetBot()
	return self.moba.bot;
end

function meta:GetCharacter()
	return self.moba.character;
end

function meta:GetCharacterDetails()
	local char = self:GetCharacter();
	if ( !MOBA.Characters[ char ] ) then return nil; end
	
	return MOBA.Characters[ char ];
end

function meta:HasSpell( slot )
	local char = self:GetCharacterDetails();
	return char.Spells[ slot ];
end

function meta:HasPassive(name)
	// passive key is the string name, and the value is a table
	// use passives later but this is just cause
	local char = self:GetCharacterDetails()
	return char.Passives[name]
end

/*function meta:GetAimDirection()
	local direction = self:GetBot():GetPos() - self.MousePos
	return direction
end

function meta:GetAimPosition()
	net.Start("mb_UpdateMousePos")
	net.Send(self)
	print("getting ply " .. self:Nick() .. " aim position - sv")
end*/