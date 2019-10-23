
local function mb_Bot( len )
	local bot = net.ReadEntity();
	moba.bot = bot;
	
	if ( !IsValid( bot ) ) then return; end
	moba.campos = bot:GetPos();
end
net.Receive( "mb_Bot", mb_Bot );

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

local testmodel = ClientsideModel("models/props_c17/oildrum001_explosive.mdl")
local function mb_UpdateMousePos()
	local vector = gui.ScreenToVector( gui.MouseX(), gui.MouseY() ) * 99;
	local tr = util.QuickTrace( moba.campos, moba.campos + (vector * 10000), LocalPlayer() );
	if not tr then return end

	net.Start("mb_UpdateMousePos")
		net.WriteVector(tr.HitPos)
	net.SendToServer()
	//testmodel:SetPos(tr.HitPos)
	local arct = math.atan(tr.HitPos.y , tr.HitPos.x)
	arct = math.deg(arct) // 1 radian to 57.2958 degrees
	local xpos = (math.sin(arct) * LocalPlayer():GetPos():Distance(tr.HitPos)) + LocalPlayer():GetPos().x
	local ypos = (math.cos(arct) * LocalPlayer():GetPos():Distance(tr.HitPos)) + LocalPlayer():GetPos().y
	local desired_pos = Vector(xpos, ypos, tr.HitPos.z)

	testmodel:SetPos(desired_pos)
	//print("sending ply aim position - cl")
end
//net.Receive("mb_UpdateMousePos", mb_UpdateMousePos)
timer.Create("mb_UpdateMousePos", 0.05, 0, mb_UpdateMousePos)