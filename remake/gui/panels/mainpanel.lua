
local PANEL = {}

function PANEL:Init()
	self:MakePopup()
	self:SetPopupStayAtBack(true)
	self:MoveToBack()
	
	self.UpperBar = self:Add("UpperBar")
	self.UpperBar:SetHeight(30)
	
	self.GMLogo = self:Add("GMLogo")
	
	self.NavBar = self:Add("NavigationBar")
	self.NavBar:SetHeight(50)
	
	self.Menu = self:Add("MenuOptions")
	self.Menu:SetWidth(300)
	
	self:Dock(FILL)
	
	self.UpperBar:Dock(TOP)
	self.GMLogo:Dock(TOP)
	self.NavBar:Dock(BOTTOM)
	self.Menu:Dock(LEFT)
	
	hook.Add("CurrentGamemodeChanged", self, self.OnGamemodeChanged)
	
	self:OnGamemodeChanged(engine.ActiveGamemode())
end

function PANEL:PerformLayout(w, h)
	do -- keeping the same behaviour
		local left = w > 1280 and 85 or 70
		local top = h > 480 and 40 or -10
		
		if self.GMLogo:IsVisible() then
			self.GMLogo:DockMargin(left, top, 0, 0)
			self.Menu:DockMargin(left, 20, 0, 0)
		else
			self.Menu:DockMargin(left, top, 0, 0)
		end
	end
end

function PANEL:PlacePage(page)
	page:SetParent(self)
	page:Dock(FILL)
	
	self.GMLogo:SetVisible(page.Title == nil and page.Controls ~= nil)
	self.Menu:SetTitle(page.Title)
	
	self:InvalidateLayout(true)
end

function PANEL:SetOptions(options_table)
	if options_table then
		self.Menu:ReflectData(options_table)
	end
	
	self.Menu:SetVisible(options_table ~= nil)
end

function PANEL:OnGamemodeChanged(gamemode_name)
	local path = "gamemodes/" .. gamemode_name .. "/logo.png"
	local mat = Material(path, "smooth")
	
	self.GMLogo:SetMaterial(mat)
	
	UpdateBackgroundImages(gamemode_name)
end

PANEL.Paint = DrawBackground -- possible opz

MainMenuView.MainPanelTable = vgui.RegisterTable(PANEL, "EditablePanel")

function MainMenuView.CreateMainPanel()
	return vgui.CreateFromTable(MainMenuView.MainPanelTable)
end
