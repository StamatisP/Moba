local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end

function meta:Initialize()
	self.moba = {};
		self.moba.character = "";
		self.moba.spells = {}; //This is used for ONLY cooldowns
		self.moba.pet = nil
		
	self:SetCharacter( "alyx_vance" );
	self:SetTeam( TEAM_BLUE );
	self:SetModel( "models/Alyx.mdl" );
	self:DrawViewModel( true );
	self:SetJumpPower( 200 );
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
	if ( (self.moba.spells[ slot ] && CurTime() < self.moba.spells[ slot ]) ) then return; end
	local char = self:GetCharacterDetails();
	local spell = char.Spells;
	spell = MOBA.Spells[ spell[slot] ];
	
	if ( !spell ) then return; end
	spell.OnCast( self, self:EyeAngles());
	
	self.moba.spells[ slot ] = CurTime() + spell.Cooldown;
	
	//local seq = spell.Sequence;
	//self:GetBot():CastSpell( seq );
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