CreateClientConVar("mb_prefchar", "alyx_vance", true, "What your preferred character is.")
local isChatOpen = false

function GM:Initialize()
	moba = {};
		moba.character = "";
		moba.spells = {};
		moba.equipment = {};
		moba.usedtokens = 0
		moba.healthmult = 1
		moba.speedmult = 1
		moba.damagemult = 1
end

local function _castSpell(slot)
	local spells = moba.spells;
	if ( !spells[slot] || spells[slot].spell == "" || RealTime() < spells[slot].cooldown ) then return; end
	if not LocalPlayer():Alive() then return end
	if isChatOpen then return end
	
	//PrintTable( spells[slot] );
	local time = MOBA.Spells[ spells[slot].spell ].Cooldown;
	if ( !time ) then return; end
	
	if MOBA.Spells[ spells[slot].spell ].CanCast(LocalPlayer()) then
		RunConsoleCommand( "mb_cast", slot );
		spells[slot].cooldown = RealTime() + time;
	else
		surface.PlaySound("npc/roller/mine/rmine_blip3.wav")
	end
end

function GM:Think()
	if gui.IsGameUIVisible() then return end
	/*if ( input.IsKeyDown( KEY_Q ) ) then
		_castSpell(1)
	elseif ( input.IsKeyDown( KEY_E ) ) then
		_castSpell(2)
	elseif ( input.IsKeyDown( KEY_F ) ) then
		_castSpell(3)
	elseif ( input.IsKeyDown( KEY_R ) ) then
		_castSpell(4)
	end*/
end

local function InputManager()
	if gui.IsGameUIVisible() then return end
	if ( input.WasKeyReleased( KEY_Q ) ) then
		_castSpell(1)
	elseif ( input.WasKeyReleased( KEY_E ) ) then
		_castSpell(2)
	elseif ( input.WasKeyReleased( KEY_F ) ) then
		_castSpell(3)
	elseif ( input.WasKeyReleased( KEY_R ) ) then
		_castSpell(4)
	end
end

hook.Add("FinishMove", "InputManager", InputManager)

function GM:PlayerBindPress( ply, bind )
end

local function HideHUD( name )
	local Tbl = { 
	[ "CHudHealth" ] = true, 
	[ "CHudAmmo" ]   = true, 
	[ "CHudSecondaryAmmo" ] = true, 
	[ "CHudBattery" ] = true,
	[ "CHudWeaponSelection" ] = true
	}; 
	
	if ( Tbl[ name ] ) then
		return false;
	end
end
hook.Add( "HUDShouldDraw", "HeistHidHUD", HideHUD );

local function ThirdPerson(ply, pos, angles, fov)
	if moba and moba.character == "dog" then
		local view = {}

		view.origin = pos - (angles:Forward() * 100)
		view.drawviewer = true

		//return view
	end
end
hook.Add("CalcView", "Dog3rdPerson", ThirdPerson)

local function ChatPreventSpells(teamc)
	isChatOpen = true
end
hook.Add("StartChat", "PreventAccidents", ChatPreventSpells)

local function EndChatPrevent()
	isChatOpen = false
end
hook.Add("FinishChat", "NoAccidents", EndChatPrevent)