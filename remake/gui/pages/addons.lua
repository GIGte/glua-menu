
local PANEL = {}

PANEL.Title = "#addons"

function PANEL:SetupMenuControls(panel)
	panel:AddOption("#open_workshop", "open_workshop")
end

function PANEL:InitEx()
	self:DockMargin(16, 4, 16, 16)
	
	local toolpanel = self:Add("Panel")
	toolpanel:SetTall(50)
	
	local enable_all = toolpanel:Add("DButton")
	enable_all:SetText("#addons.enableall")
	enable_all:SizeToContentsX(30)
	
	enable_all.enable = true
	enable_all.DoClick = function(pnl)
		local addons = engine.GetAddons()
		
		for i = 1, #addons do
			local info = addons[i]
			
			steamworks.SetShouldMountAddon(info.wsid, pnl.enable)
		end
		
		steamworks.ApplyAddons()
	end
	
	local disable_all = toolpanel:Add("DButton")
	disable_all:SetText("#addons.disableall")
	disable_all:SizeToContentsX(30)
	
	disable_all.enable = false
	disable_all.DoClick = enable_all.DoClick
	
	local refresh = toolpanel:Add("DButton")
	refresh:SetText("#refresh")
	refresh:SizeToContentsX(30)
	
	refresh.DoClick = function()
		self:ReloadAddons()
	end
	
	enable_all:DockMargin(10, 10, 16, 10)
	enable_all:Dock(LEFT)
	
	disable_all:DockMargin(0, 10, 16, 10)
	disable_all:Dock(LEFT)
	
	refresh:DockMargin(0, 10, 16, 10)
	refresh:Dock(LEFT)
	
	
	local addonlist_spanel = self:Add("DScrollPanel")
	
	self.AddonList = addonlist_spanel:Add("AddonList")
	
	self.AddonList:Dock(TOP)
	
	toolpanel:Dock(TOP)
	
	addonlist_spanel:DockMargin(16, 10, 10, 10)
	addonlist_spanel:Dock(FILL)
	
	hook.Add("GameContentChanged", self, self.ReloadAddons)
	
	self:ReloadAddons()
end

function PANEL:Open()
	if not self.loaded then
		self.loaded = true
		
		self:InitEx()
	end
end

function PANEL:Close()
	
end

function PANEL:ReloadAddons()
	local addons = engine.GetAddons()
	
	self.AddonList:ReflectData(addons)
	
	--self.AddonList:GetVBar():SetScroll(0)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, color_white)
end

MainMenuView.Pages.Addons = vgui.RegisterTable(PANEL, "Panel")
