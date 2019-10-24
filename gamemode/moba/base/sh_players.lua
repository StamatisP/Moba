hook.Add("Move", "PlayerSpeed", function(ply, mv)
	local char = ply:GetCharacterDetails()
	if char then
		local name = char.Name
		local speed = mv:GetMaxSpeed()
		mv:SetMaxSpeed(speed * char.Speed)
		mv:SetMaxClientSpeed(speed * char.Speed)
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