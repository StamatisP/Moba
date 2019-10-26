CreateClientConVar("mb_prefchar", "alyx_vance", true, "What your preferred character is.")

function GM:Initialize()
	moba = {};
		moba.character = "";
		moba.spells = {};
		moba.equipment = {};
end

local function _castSpell(slot)
	local spells = moba.spells;
	if ( !spells[slot] || spells[slot].spell == "" || RealTime() < spells[slot].cooldown ) then return; end
	if not LocalPlayer():Alive() then return end
	
	//PrintTable( spells[slot] );
	local time = MOBA.Spells[ spells[slot].spell ].Cooldown;
	if ( !time ) then return; end
	
	RunConsoleCommand( "mb_cast", slot );
	spells[slot].cooldown = RealTime() + time;
end

function GM:Think()
	if gui.IsGameUIVisible() then return end
	if ( input.IsKeyDown( KEY_Q ) ) then
		_castSpell(1)
	elseif ( input.IsKeyDown( KEY_E ) ) then
		_castSpell(2)
	elseif ( input.IsKeyDown( KEY_F ) ) then
		_castSpell(3)
	elseif ( input.IsKeyDown( KEY_R ) ) then
		_castSpell(4)
	end
end

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