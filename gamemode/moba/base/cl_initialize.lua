CreateClientConVar("mb_prefchar", "alyx_vance", true, "What your preferred character is.")
local isChatOpen = false
local m_failedCast = false
local m_LastCastSpell = nil

function GM:Initialize()
	moba = {}
		moba.character = ""
		moba.spells = {}
		moba.equipment = {}
		moba.usedtokens = 0
		moba.mults = {
			[1] = 1, // Health
			[2] = 1, // Speed
			[3] = 1, // Damage
			[4] = 1 // CDR
		}
	mb_RoundStatus = ROUND_PREGAME
end

function GM:InitPostEntity()
	moba.cpmaster = ents.FindByClass("ent_mb_cap_master")[1]
	/*for i = 1, moba.cpmaster:GetNumOfCaps() do
		//moba.cap
	end*/
	if mb_RoundStatus == ROUND_PREGAME then
		hook.Run("mb_Intermission", intermission_music)
	end
end

local function _castSpell(slot)
	local spells = moba.spells
	if ( !spells[slot] || spells[slot].spell == "" || RealTime() < spells[slot].cooldown ) then return end
	if not LocalPlayer():Alive() then return end
	if isChatOpen then return end
	
	//PrintTable( spells[slot] )
	local time = MOBA.Spells[ spells[slot].spell ].Cooldown
	if ( !time ) then return end
	m_LastCastSpell = MOBA.Spells[ spells[slot].spell ]
	
	if m_LastCastSpell.CanCast(LocalPlayer()) and not m_LastCastSpell.Passive then
		RunConsoleCommand( "mb_cast", slot )
		spells[slot].cooldown = RealTime() + (time / moba.mults[4])
	else
		if m_LastCastSpell.Passive then return end
		surface.PlaySound("npc/roller/mine/rmine_blip3.wav")
		m_failedCast = true
		timer.Simple(0.2, function()
			m_failedCast = false
		end)
	end
end

local function SpellRangeWireframe()
	if not m_failedCast then return end
	render.SetColorMaterial()
	local pos = LocalPlayer():GetPos()
	local radius = m_LastCastSpell.Range
	local wideSteps = 10
	local tallSteps = 10

	render.DrawWireframeSphere( pos, radius, wideSteps, tallSteps, Color( 255, 255, 255, 255 ), true)
end

hook.Add("PostDrawTranslucentRenderables", "SpellRangeWireframe", SpellRangeWireframe)

function GM:Think()
	//if gui.IsGameUIVisible() then return end
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