local function UpgradePerk(perk)
	local spendabletokens = GetGlobalInt("UpgradeTokens", 0) - moba.usedtokens
	if spendabletokens <= 0 then return end
	if not moba.mults[perk] then return end
	moba.mults[perk] = moba.mults[perk] + 0.2
	moba.usedtokens = moba.usedtokens + 1
	net.Start("mb_ClientRequestUpgrade")
		net.WriteUInt(perk, 4)
	net.SendToServer()
end

local PerkTranslate = {
	[1] = "Health",
	[2] = "Speed",
	[3] = "Damage",
	[4] = "Spell Cooldown"
}

local message = "%s Multiplier: %i%%"
local MultItem = {}
function MultItem:Init()
	self:SetText("")
	timer.Simple(0, function() self:SetText(string.format(message, PerkTranslate[self.perk], moba.mults[self.perk] * 100)) end)
end
function MultItem:SetPerk(num)
	self.perk = num
end
function MultItem:DoClick()
	UpgradePerk(self.perk)
	self.megaparent:AlphaTo(0, 0.2, 0, function(animdata, panel)
		panel:Close()
	end)
end
vgui.Register("ItemButton", MultItem, "DButton")

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

	for i = 1, #moba.mults do
		local item = upgradelist:Add("ItemButton")
		item:SetPerk(i)
		item:SetSize(300, 50)
		item.megaparent = frame
	end
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.2)
end

concommand.Add("mb_upgrademenu", UpgradeMenu)