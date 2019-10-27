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

local function mb_ResetSpellCD(len)
	local spells = moba.spells;
	local slot = net.ReadUInt(4)
	if ( !spells[slot] || spells[slot].spell == "" ) then return end
	print("resetting spell cd")

	spells[slot].cooldown = RealTime()
end
net.Receive("mb_ResetSpellCD", mb_ResetSpellCD)

local function mb_RoundStart(len)
	local time = net.ReadUInt(16)
	hook.Run("mb_RoundStart")
	local panel = vgui.Create("DPanel")
	panel:SetSize(600, 100)
	panel:SetPos(ScrW() / 2, 100)
	print(string.ToMinutesSeconds(time))
	function panel:Paint(w, h)
		draw.SimpleTextOutlined(string.ToMinutesSeconds(time), "DermaLarge", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0))
	end
	timer.Create("SetRoundTime", 1, 0, function()
		if time <= 0 then
			panel:Remove()
			return
		end
		time = time - 1
	end)
end
net.Receive("mb_RoundStart", mb_RoundStart)

local function mb_RoundEnd(len)
	hook.Run("mb_RoundEnd")
end
net.Receive("mb_RoundEnd", mb_RoundEnd)