local function mb_Char( len )
	local char = net.ReadString();
	moba.character = char;
end
net.Receive( "mb_Char", mb_Char );

local function mb_Equip( len )
	local equip = net.ReadTable();
	moba.equipment = equip;
end
net.Receive( "mb_Equip", mb_Equip );

local function mb_Spell( len )
	local spells = net.ReadTable();
	
	for i = 1, #spells do
		spells[i] = { spell = spells[i], cooldown = 0 };
	end

	moba.spells = spells;
end
net.Receive( "mb_Spell", mb_Spell );

local function mb_StartCharacterPick(len)
	RunConsoleCommand("mb_charmenu")
end
net.Receive("mb_StartCharacterPick", mb_StartCharacterPick)