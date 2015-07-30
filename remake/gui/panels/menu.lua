
local PANEL = {}

function PANEL:Init()
	self.Title = self:Add("MenuTitle")
	self.Title:Hide()
	
	--self.MenuOptions = self:Add("MenuOptions")
	
	self.Title:DockMargin(0, 20, 0, 23)
	self.Title:Dock(TOP)
	
	--self.MenuOptions:Dock(FILL)
end

function PANEL:SetEnlarged(state)
	self.enlarged = state
	
	self.Title:SetEnlarged(state)
	
	self.Title:DockMargin(0, 20, 0, state and 23 or 9)
	
	if self.MenuOptions then
		self.MenuOptions:SetEnlarged(state)
	end
end

function PANEL:PlaceMenuOptions(menu_panel)
	if self.MenuOptions then
		self.MenuOptions:Hide()
		--self.MenuOptions:SetParent(nil)
	end
	
	if menu_panel then
		menu_panel:SetParent(self)
		menu_panel:Show()
		
		menu_panel:Dock(FILL)
		menu_panel:SetEnlarged(self.enlarged)
	end
	
	self:InvalidateLayout(true)
	
	self.MenuOptions = menu_panel
end

function PANEL:SetTitle(title)
	if title then
		self.Title:SetText(title)
		self.Title:SizeToContents()
	end
	
	local vis_changed = self.Title:IsVisible() ~= (title ~= nil)
	
	if vis_changed then
		self.Title:SetVisible(title ~= nil)
		
		self:InvalidateLayout(true)
	end
end

vgui.Register("MenuContainer", PANEL, "Panel")
