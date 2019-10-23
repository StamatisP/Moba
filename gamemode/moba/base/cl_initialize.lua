CreateClientConVar("mb_prefchar", "alyx_vance", true, "What your preferred character is.")

function GM:Initialize()
	moba = {};
		moba.character = "";
		moba.spells = {};
		moba.equipment = {};
end

local function normalize(min, max, val) 
    local delta = max - min
    return (val - min) / delta
end

local filledcircle = draw.NewCircle(CIRCLE_FILLED)
filledcircle:SetRotation(270)
local circletab = {
	[1] = filledcircle,
	[2] = filledcircle:Copy(),
	[3] = filledcircle:Copy(),
	[4] = filledcircle:Copy(),
}
function GM:HUDPaint()
	local x, y = ScrW() / 2, ScrH() / 2;
	if not moba.character then return end
	local spells = moba.spells;
	
	for i = 1, table.Count(spells) do
		local dist = i * 100;
		dist = dist + (x * 0.65);

		circletab[i]:SetPos(dist + 50, (y * 1.79) + 50)
		circletab[i]:SetRadius(x * 0.05)
		if MOBA.Spells[spells[i].spell] and moba.spells and spells[i].cooldown then
			local spellcd = spells[i].cooldown - RealTime()
			if spellcd <= 0 then spellcd = 0 end
			circletab[i]:SetAngles(0, normalize(0, MOBA.Spells[spells[i].spell].Cooldown, spellcd) * 360)
			circletab[i](Color(0, 255, 0))
		end

		draw.RoundedBox( 0, dist, y * 1.79, x * 0.10, y * 0.20, Color( 60, 60, 60, 120 ) );
		
		local txt = MOBA.Characters[ moba.character ].Spells[i] or i;
		txt = string.gsub(txt, "^%l", string.upper)
		local col = Color( 255, 255, 255, 255 );
		
		if ( moba.spells[ i ].cooldown > RealTime() ) then
			col = Color( 60, 60, 60, 255 );
		end
		
		draw.DrawText( txt, "Default", dist + (x * 0.05), y * 1.88, col, TEXT_ALIGN_CENTER );
	end
end

local function _castSpell(slot)
	local spells = moba.spells;
	if ( !spells[slot] || spells[slot].spell == "" || RealTime() < spells[slot].cooldown ) then return; end
	
	//PrintTable( spells[slot] );
	local time = MOBA.Spells[ spells[slot].spell ].Cooldown;
	if ( !time ) then return; end
	
	RunConsoleCommand( "mb_cast", slot );
	spells[slot].cooldown = RealTime() + time;
end

//Mouse Movements
function GM:Think()	
	if ( input.IsKeyDown( KEY_1 ) ) then
		_castSpell(1)
	elseif ( input.IsKeyDown( KEY_2 ) ) then
		_castSpell(2)
	elseif ( input.IsKeyDown( KEY_3 ) ) then
		_castSpell(3)
	elseif ( input.IsKeyDown( KEY_4 ) ) then
		_castSpell(4)
	end
end

function GM:PlayerBindPress( ply, bind )
end

local function HideHUD( name )
	local Tbl = { 
	[ "CHudHealth" ] = true, 
	[ "CHudAmmo" ]   = true, 
	[ "CHudAmmoSecondary" ] = true, 
	[ "CHudBattery" ] = true,
	[ "CHudWeaponSelection" ] = true
	}; 
	
	if ( Tbl[ name ] ) then
		return false;
	end
end
hook.Add( "HUDShouldDraw", "HeistHidHUD", HideHUD );