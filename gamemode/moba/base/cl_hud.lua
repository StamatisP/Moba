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
	if not moba and not moba.character then return end
	local spells = moba.spells;
	
	for i = 1, #spells do
		local dist = i * 100;
		dist = dist + (x * 0.65);

		circletab[i]:SetPos(dist + 50, (y * 1.79) + 50)
		circletab[i]:SetRadius(x * 0.05)
		if MOBA.Spells[spells[i].spell] and moba.spells and spells[i].cooldown then
			local spellcd = spells[i].cooldown - RealTime()
			if spellcd <= 0 then spellcd = 0 end
			circletab[i]:SetAngles(0, normalize(0, MOBA.Spells[spells[i].spell].Cooldown, spellcd) * 360)
			//local circlecol = InterpolateColor(Color(255, 0, 0), Color(0, 255, 0), MOBA.Spells[spells[i].spell].Cooldown, spellcd, 0)
			circletab[i](Color(255, 0, 0))
		end

		draw.RoundedBox( 0, dist, y * 1.79, x * 0.10, y * 0.20, Color( 60, 60, 60, 120 ) );
		
		local spell_internal = MOBA.Characters[ moba.character ].Spells[i]

		local txt
		if MOBA.Spells[spell_internal] then
			txt = MOBA.Spells[spell_internal].Name or i
		else
			txt = i
		end
		//txt = string.gsub(txt, "^%l", string.upper)
		//txt = PrettyPrintSpells(txt)
		local col = Color( 255, 255, 255, 255 );
		
		if ( moba.spells[ i ].cooldown > RealTime() ) then
			col = Color( 160, 60, 60, 255 );
		end
		
		draw.DrawText( txt, "Default", dist + (x * 0.05) + 2, (y * 1.88) + 2, Color(0, 0, 0), TEXT_ALIGN_CENTER )
		draw.DrawText( txt, "Default", dist + (x * 0.05), y * 1.88, col, TEXT_ALIGN_CENTER )
	end
end

local wMat = Material("models/debug/debugwhite")
local function RedDrawTarget()
	cam.Start3D()
		render.SuppressEngineLighting(true)

		for k, v in pairs(player.GetAll()) do
			if v == LocalPlayer() or not v:Alive() then continue end
			if IsLookingAt(LocalPlayer(), v) then
				if v:GetPos():DistToSqr(LocalPlayer():GetPos()) > 200 * 200 then continue end
				render.MaterialOverride(wMat)
				if v:Team() == TEAM_BLUE then
					render.SetColorModulation(0, 0, 1)
				else
					render.SetColorModulation(1, 0, 0)
				end
				v:DrawModel()
				render.MaterialOverride(nil) // to fix renderview breaking
			end
		end

		render.SuppressEngineLighting(false)
	cam.End3D()
end

hook.Add("PostDrawEffects", "DrawTarget", RedDrawTarget)

local function PostPlayerDraw(ply)
	if ( !IsValid( ply ) ) then return end
	if ( ply == LocalPlayer() ) then return end 
	if ( !ply:Alive() ) then return end 

	local dist = LocalPlayer():GetPos():DistToSqr( ply:GetPos() ) 

	if ( dist < 1000 * 1000 ) then 

		local mins, maxs = ply:GetModelBounds()
		local offset = maxs + Vector( 0, -25, 0 )
		local ang = LocalPlayer():EyeAngles()
		local pos = ply:GetPos() + offset + ang:Up()

		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )


		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.5 )
			draw.DrawText( ply:Health(), "HudSelectionText", 2, 2, team.GetColor( ply:Team() ), TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end
end
hook.Add("PostPlayerDraw", "PlayerHealth", PostPlayerDraw)