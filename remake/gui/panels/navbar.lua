
local PANEL = {}

function PANEL:Init()
	self:DockPadding(5, 5, 5, 5)
	
	local widgets = widgets.GetTable()
	
	-- keep the right order
	local std_widgets = { -- FIXME
		"gamemode",
		"language",
		"games",
		"options",
		"dev_refresh",
	}
	
	for i = 1, #std_widgets do
		local k = std_widgets[i]
		local widget = widgets[k]
		
		if widget then
			self:AddWidget(widget)
		end
	end
	
	for k, v in pairs(widgets) do
		if not table.HasValue(std_widgets, k) then
			self:AddWidget(v)
		end
	end
	
	--[[self.Gamemodes = self:Add("ControlButton")
	self.Gamemodes:SetText(ActiveGamemodeInfo().title)
	self.Gamemodes:SetIcon(string.format("../gamemodes/%s/icon24.png", engine.ActiveGamemode()))
	self.Gamemodes:SizeToContentsX(50)
	
	self.Language = self:Add("ControlButton")
	self.Language:SetSize(40, 40)
	self.Language:SetIcon(string.format("../resource/localization/%s.png", Language()))
	
	self.Games = self:Add("ControlButton")
	self.Games:SetSize(40, 40)
	self.Games:SetIcon("../html/img/games.png")]]
	
	self.Back = self:Add("ControlButton")
	self.Back:SetText("#back_to_main_menu")
	self.Back:SetIcon("../html/img/back_to_main_menu.png")
	self.Back:SizeToContentsX(50)
	self.Back:Hide()
	
	self.Back.DoClick = function(self)
		self:Hide()
		return RunCommand("back")
	end
	
	self.Back:Dock(LEFT)
	
	hook.Add("PageChanged", self, self.OnPageChanged)
end

--[[local function posButton(panel, x)
	x = x - 5 - panel:GetWide()
	panel:SetPos(x, 5)
	
	return x
end

function PANEL:PerformLayout(w, h)
	self.Back:SetPos(5, 5)
	
	local x = w
	
	x = posButton(self.Gamemodes, x)
	x = posButton(self.Language, x)
	x = posButton(self.Games, x)
end]]

function PANEL:AddWidget(widget_base) -- internal
	local button = self:Add("WidgetButton")
	button:SetupWidget(widget_base)
	
	button:DockMargin(3, 0, 0, 0)
	button:Dock(RIGHT)
end

function PANEL:OnWidgetButtonClick(panel)
	if self.CurrentWidgetButton then
		self.CurrentWidgetButton:ClosePopup()
	end
	
	if self.CurrentWidgetButton == panel then
		self.CurrentWidgetButton = nil
		
		return
	end
	
	self.CurrentWidgetButton = panel
	
	if panel then
		panel:OpenPopup()
	end
end

function PANEL:OnPageChanged(page, is_root)
	if is_root then
		self.Back:Hide()
	else
		self.Back:Show()
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 127)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("NavigationBar", PANEL, "Panel")
