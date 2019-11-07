local ratio = 1920 / ScrW()

surface.CreateFont( "WinFont", {
	font = "Trebuchet MS", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 32,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

local AccoladeItem = {}
function AccoladeItem:Init()
	self.bg = vgui.Create("DPanel", self)
	self.bg:SetSize(1500 / ratio, 96 / ratio)
	function self.bg:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(65, 65, 65))
	end

	self.avatar = vgui.Create("AvatarImage", self.bg)
	local avi = self.avatar
	avi:SetPos(16, 16)
	avi:SetSize(64, 64)
	//avi:SetSteamID("76561198129058934", 64)

	self.text = vgui.Create("DLabel", self.bg)
	self.text:SetFont("DermaDefaultBold")
	self.text:SetText("unfilled")
	self.text:SetPos(96, 40)
end
function AccoladeItem:SetPlayer(str)
	if not self.avatar then ErrorNoHalt("NO AVATAR!") return end
	self.avatar:SetPlayer(str, 64)
end
function AccoladeItem:SetText(str)
	if not self.text then ErrorNoHalt("NO TEXT") return end
	self.text:SetText(str)
	self.text:SizeToContents()
end

vgui.Register("DAccoladeItem", AccoladeItem, "DPanel")

local AccoladePrettifier = {
	["damage"] = "%s dealt %u damage!",
	["kills"] = "%s killed %u players!",
	["pointcaptures"] = "%s captured %u points!",
	["alyx_successfulhacks"] = "%s hacked %u things as Alyx!",
	["dog_successfulballkills"] = "%s crushed %u people with their Ball as Dog!",
	["metro_successfulstuns"] = "%s delivered punishment to %u people as Metro Cop!",
}

function CreateAccoladeList(acctab)
	local dframe = vgui.Create("DFrame")
	dframe:SetTitle("End of Round")
	dframe:SetPos(90, 60)
	dframe:SetSize(1700 / ratio, 1000 / ratio)
	dframe:Center()

	local winlabel = vgui.Create("DLabel", dframe)
	winlabel:SetFont("WinFont")
	if acctab["whowon"] == TEAM_BLUE then
		winlabel:SetText("Blue Team Victory!")
		winlabel:SetColor(Color(90, 90, 255))
	elseif acctab["whowon"] == TEAM_RED then
		winlabel:SetText("Red Team Victory!")
		winlabel:SetColor(Color(255, 90, 90))
	else
		winlabel:SetText("Stalemate!")
		winlabel:SetColor(Color(90, 90, 90))
 	end
 	winlabel:SizeToContents()
	winlabel:Dock(TOP)
	winlabel:CenterVertical()

	local scroll = vgui.Create("DScrollPanel", dframe)
	scroll:Dock(FILL)

	local accoladelist = vgui.Create("DIconLayout", scroll)
	accoladelist:Dock(FILL)
	accoladelist:SetSpaceX(5)
	accoladelist:SetSpaceY(10)

	for i = 1, #acctab.plyaccs do
		local item = accoladelist:Add("DAccoladeItem")
		item:SetSize(1500 / ratio, 96 / ratio)
		item:SetPlayer(Player(acctab.plyaccs[i].userid), 64)
		//item:SetText(acctab.plyaccs[i].acc .. " " .. acctab.plyaccs[i].val)
		item:SetText(string.format(AccoladePrettifier[acctab.plyaccs[i].acc], Player(acctab.plyaccs[i].userid):Nick(), acctab.plyaccs[i].val))
	end
end