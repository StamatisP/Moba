local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end

function meta:Initialize()
	self.moba = {};
		self.moba.character = "";
		self.moba.spells = {}; //This is used for ONLY cooldowns
		self.moba.pet = {} // you can have multiple pets
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
	if not self:Alive() then return end
	local char = self:GetCharacterDetails();
	local spell = char.Spells;
	spell = MOBA.Spells[ spell[slot] ];
	
	if ( !spell ) then return; end
	spell.OnCast( self, self:GetPos());
	//print(slot)
	//char.OnCast(spell)
	
	self.moba.spells[ slot ] = CurTime() + spell.Cooldown;
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

function meta:ResetSpellCD(slot)
	local char = self:GetCharacterDetails()
	local spell = char.Spells
	spell = MOBA.Spells[ spell[slot] ]
	if not spell then return end
	self.moba.spells[slot] = CurTime()
	timer.Simple(0.2, function()
		net.Start("mb_ResetSpellCD")
			net.WriteUInt(slot, 4)
		net.Send(self)
	end)
end