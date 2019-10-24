local function CreateCharMenu()
	local frame = vgui.Create("DFrame")
	frame:SetTitle("Character Pick")
	frame:SetSize(720, 520)
	frame:Center()
	frame:MakePopup()

	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:Dock(FILL)

	local list = vgui.Create("DIconLayout", scroll)
	list:Dock(FILL)
	list:SetSpaceX(5)
	list:SetSpaceY(5)

	local modelpreview
	for k, v in pairs(MOBA.Characters) do
		print(k)
		print(v)
		local item = list:Add("DModelPanel")
		item:SetModel(v.Model)
		item:SetSize(100, 100)
		item:SetText(v.Name)
		item:SetTextColor(Color(255, 255, 255))
		item:SetPos(0, 0)
		item.DoClick = function()
			RunConsoleCommand("mb_prefchar", k)
			modelpreview:SetModel(v.Model)
		end
	end

	local confirmpanel = vgui.Create("DPanel", frame)
	confirmpanel:SetSize(300, 500)
	confirmpanel:Dock(RIGHT)

	local charpreview = vgui.Create("DPanel", confirmpanel)
	charpreview:Dock(FILL)

	modelpreview = vgui.Create("DModelPanel", charpreview)
	modelpreview:Dock(TOP)
	modelpreview:SetSize(300, 300)
	modelpreview:SetModel(MOBA.Characters[GetConVar("mb_prefchar"):GetString()].Model or "models/player/alyx.mdl")

	local confirmbutton = vgui.Create("DButton", confirmpanel)
	confirmbutton:Dock(BOTTOM)
	confirmbutton:SetSize(300, 50)
	confirmbutton:SetText("Confirm Choice")
	confirmbutton.DoClick = function()
		net.Start("mb_SendCharacterPick")
			net.WriteString(GetConVar("mb_prefchar"):GetString())
		net.SendToServer()
		frame:Close()
	end
end
concommand.Add("mb_charmenu", CreateCharMenu)