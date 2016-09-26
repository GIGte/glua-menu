
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
	
	self.Resume = self:Add("ControlButton")
	self.Resume:SetText("#back_to_game")
	self.Resume:SetIcon("../html/img/back_to_game.png")
	self.Resume:SizeToContentsX(50)
	self.Resume:SetVisible(IsInGame())
	
	self.Resume.DoClick = function(self)
		return RunCommand("resume_game")
	end
	
	self.Resume:DockMargin(0, 0, 160, 0)
	self.Resume:Dock(RIGHT)
	
	self.Back = self:Add("ControlButton")
	self.Back:SetText("#back_to_main_menu")
	self.Back:SetIcon("../html/img/back_to_main_menu.png")
	self.Back:SizeToContentsX(50)
	self.Back:Hide()
	
	self.Back.OnCursorEntered = function(self)
		PlayUISound("hover")
		self:InvalidateLayout(true)
	end
	
	self.Back.DoClick = function(self)
		PlayUISound("return")
		return RunCommand("back")
	end
	
	self.Back:Dock(LEFT)
	
	hook.Add("PageChanged", self, self.OnPageChanged)
	hook.Add("InGameStateChanged", self, self.InGameChanged)
end

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

function PANEL:InGameChanged(state)
	if state then
		self.Resume:Show()
	else
		self.Resume:Hide()
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 127)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("NavigationBar", PANEL, "Panel")
