local function UpgradeMenu()
	local spendabletokens = GetGlobalInt("UpgradeTokens", 0) - moba.usedtokens
	local frame = vgui.Create("DFrame")
	frame:SetSize(300, 500)
	frame:Center()
	frame:SetTitle("Upgrade Menu")
	frame:MakePopup()

	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:Dock(FILL)

	local upgradelist = vgui.Create("DIconLayout", scroll)
	upgradelist:Dock(FILL)
	upgradelist:SetSpaceY(10)
	upgradelist:SetSpaceX(5)

	local token_label = upgradelist:Add("DLabel")
	token_label.OwnLine = true
	token_label:SetSize(300, 50)
	token_label:SetText("Spendable tokens: " .. spendabletokens)

	local healthitem = upgradelist:Add("DButton")
	healthitem:SetText("Health Multiplier: " .. moba.healthmult * 100 .. "%")
	healthitem:SetSize(300, 50)
	function healthitem:DoClick()
		if spendabletokens <= 0 then return end
		moba.healthmult = moba.healthmult + 0.2
		moba.usedtokens = moba.usedtokens + 1
		net.Start("mb_ClientRequestUpgrade")
			net.WriteUInt(1, 4)
		net.SendToServer()
		frame:Close()
	end

	local speeditem = upgradelist:Add("DButton")
	speeditem:SetText("Speed Multiplier: " .. moba.speedmult * 100 .. "%")
	speeditem:SetSize(300, 50)
	function speeditem:DoClick()
		if spendabletokens <= 0 then return end
		moba.speedmult = moba.speedmult + 0.2
		moba.usedtokens = moba.usedtokens + 1
		net.Start("mb_ClientRequestUpgrade")
			net.WriteUInt(2, 4)
		net.SendToServer()
		frame:Close()
	end

	local damageitem = upgradelist:Add("DButton")
	damageitem:SetText("Damage Multiplier: " .. moba.damagemult * 100 .. "%")
	damageitem:SetSize(300, 50)
	function damageitem:DoClick()
		if spendabletokens <= 0 then return end
		moba.damagemult = moba.damagemult + 0.2
		moba.usedtokens = moba.usedtokens + 1
		net.Start("mb_ClientRequestUpgrade")
			net.WriteUInt(3, 4)
		net.SendToServer()
		frame:Close()
	end
end

concommand.Add("mb_upgrademenu", UpgradeMenu)