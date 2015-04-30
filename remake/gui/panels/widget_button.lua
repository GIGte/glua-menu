
local PANEL = {}

function PANEL:GetWidget()
	return self.widget
end

function PANEL:SetupWidget(widget_base)
	if self.widget then
		error("tried to setup widget twice")
	end
		
	self.widget = setmetatable({}, widget_base)
	
	self.widget:SetViewController(self)
	self.widget:Initialize()
	
	self:RequestReload()
end

function PANEL:RequestReload()
	local title = self.widget.Title
	local icon = self.widget.Icon
	
	self:SetText(title)
	self:SetIcon(icon)
	
	if title ~= "" then
		self:SizeToContentsX(36)
	else
		self:SetSize(40, 40)
	end
	
	self:InvalidateParent()
	
	if self.Popup then
		local canvas = self.Popup:GetCanvas()
		
		canvas:Clear()
		
		local cw, ch = self.widget:BuildPanel(canvas)
		
		--self.Popup:InvalidateLayout(true)
		self:ResizePopup(cw, ch)
	end
end

function PANEL:ResizePopup(cw, ch)
	cw = cw + 6
	ch = ch + 6
	
	local x, y = self:GetPos()
	local w, h = self:GetSize()
	
	local w_d2 = math.Round(w / 2)
	local center_x = x + w_d2
	
	local cw_d2 = math.Round(cw / 2)
	
	if center_x + cw_d2 > surface.ScreenWidth() - 10 then
		center_x = surface.ScreenWidth() - 10 - cw_d2
	end
	
	self.Popup:SetSize(cw, ch)
	self.Popup:SetPos(center_x - cw_d2, surface.ScreenHeight() - 53 - ch)
end

function PANEL:OpenPopup()
	if self.Popup then
		self.Popup:Show()
		self.Popup:MoveToFront()
		self.widget:PanelOpened()
		
		return
	end
	
	self.Popup = vgui.Create("WidgetPopup")
	
	local canvas = self.Popup:GetCanvas()
	
	local cw, ch = self.widget:BuildPanel(canvas)
	
	--self.Popup:InvalidateLayout(true)
	self:ResizePopup(cw, ch)
	
	self.widget:PanelOpened()
end

function PANEL:ClosePopup()
	self.Popup:Hide()
	self.widget:PanelClosed()
end

function PANEL:IsOpened()
	return self.Popup:IsVisible()
end

function PANEL:Open()
	if not self.Popup:IsVisible() then
		return self:DoClick()
	end
end

function PANEL:Close()
	if self.Popup:IsVisible() then
		return self:DoClick()
	end
end

function PANEL:OnRemove()
	self.widget:DestroyEx()
end

function PANEL:DoClick()
	self:GetParent():OnWidgetButtonClick(self)
end

vgui.Register("WidgetButton", PANEL, "ControlButton")
