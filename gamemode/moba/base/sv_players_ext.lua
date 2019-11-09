local meta = FindMetaTable( "Player" )
if ( !meta ) then return end

function meta:Initialize()
	self.moba = {}
		self.moba.character = ""
		self.moba.spells = {} //This is used for ONLY cooldowns
		self.moba.pet = {} // you can have multiple pets
		self.moba.usedtokens = 0
		self.moba.mults = {
			[1] = 1, // Health
			[2] = 1, // Speed
			[3] = 1, // Damage
			[4] = 1  // Cooldown
		}
		self.moba.accolades = {}
end

function meta:SetCharacter( char )
	if ( self.moba.character == char ) then return end
	
	self.moba.character = char
	
	net.Start( "mb_Char" )
		net.WriteString( char )
	net.Send( self )
	
	local char = self:GetCharacterDetails()
	if ( !char ) then return end
	
	local spells = char.Spells
	local equipment = char.Equipment
	
	net.Start( "mb_Spell" )
		net.WriteTable( spells )
	net.Send( self )
	
	net.Start( "mb_Equip" )
		net.WriteTable( equipment )
	net.Send( self )
end

function meta:CastSpell( slot )
	if ( (self.moba.spells[ slot ] && CurTime() < self.moba.spells[ slot ]) ) then return end
	if not self:Alive() then return end
	local char = self:GetCharacterDetails()
	local spell = char.Spells
	spell = MOBA.Spells[ spell[slot] ]
	
	if ( !spell ) then return end
	spell.OnCast( self, self:GetPos())
	//print(slot)
	//char.OnCast(spell)
	
	self.moba.spells[ slot ] = CurTime() + (spell.Cooldown / self.moba.mults[4])
end

function meta:HasSpell( slot )
	local char = self:GetCharacterDetails()
	return char.Spells[ slot ]
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

function meta:GetMult(str)
	if not PerkTranslate[str] then return end
	local perk = PerkTranslate[str]
	return self.moba.mults[perk]
end

function meta:PlayerVO(emotion)
	local vo = MOBA.Characters[self:GetCharacter()].VoiceOver[emotion]
	if not vo then return end
	self:EmitSound(vo[GetPseudoRandomNumber(#vo)])
end

function meta:AddAccolade(key, value)
	if not HLHS_AccoladeList[key] then ErrorNoHalt("Error, " .. key .. " is not a valid Accolade.") return end
	if not value then value = 1 end
	if not self.moba.accolades[key] then
		self.moba.accolades[key] = value
	else
		self.moba.accolades[key] = self.moba.accolades[key] + value
	end
end