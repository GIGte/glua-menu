
local PANEL = {}

local function panelPaint(pnl, w, h)
	return draw.RoundedBox(8, 0, 0, w, h, color_white)
end

local function maxplayersOpenMenu(self)
	if IsValid(self.Menu) then
		self.Menu:Remove()
		self.Menu = nil
	end
	
	self.Menu = DermaMenu()
	
	for i = 1, #self.Choices do
		local data = self.Choices[i]
		self.Menu:AddOption( data, function() self:ChooseOption( data, i ) end )
	end
	
	local x, y = self:LocalToScreen( 0, self:GetTall() )
	
	self.Menu:SetMinimumWidth( self:GetWide() )
	self.Menu:Open( x, y, false, self )
end

function PANEL:InitEx()
	local mapname, category = LoadLastMap()
	
	self.GameSettings = {
		["map"] = mapname
	}
	
	local mapbox = self:Add("Panel")
	mapbox.Paint = panelPaint
	
	mapbox:DockMargin(16, 4, 7, 16)
	mapbox:Dock(FILL)
	
	mapbox:DockPadding(10, 10, 10, 10)
	
	do
		local mapcats_container = mapbox:Add("Panel")
		mapcats_container:SetWide(190)
		
		local mapcats
		
		do
			mapcats = mapcats_container:Add("MapCategoryList")
			mapcats:SetLastCategory(category)
			
			self.SearchBox = mapcats_container:Add("DTextEntryWHint")
			self.SearchBox:SetTall(24)
			self.SearchBox:SetPlaceholder("#searchbar_placeholer")
			
			self.SearchBox.OnChange = function(pnl)
				mapcats:FilterByText(string.lower(pnl:GetText()))
			end
			
			mapcats:Dock(FILL)
			self.SearchBox:Dock(BOTTOM)
		end
		
		local catheader = mapbox:Add("MapList_Header")
		catheader:SetTall(55)
		
		local maplist_spanel = mapbox:Add("DScrollPanel")
		
		local maplist
		
		do
			maplist = maplist_spanel:Add("MapList")
			maplist:SetLastMap(mapname)
			
			maplist:Dock(FILL)
		end
		
		mapcats:SetHeaderPanel(catheader)
		mapcats:SetMapListPanel(maplist)
		
		mapcats_container:DockMargin(0, 0, 15, 0)
		mapcats_container:Dock(LEFT)
		
		catheader:Dock(TOP)
		
		maplist_spanel:Dock(FILL)
		
		
		maplist.OnSelect = function(pnl, mapname)
			self.GameSettings["map"] = mapname
		end
		maplist.DoDoubleClick = function(pnl)
			return StartGame(self.GameSettings)
		end
	end
	
	
	local settings = self:Add("Panel")
	settings.Paint = panelPaint
	
	settings:SetWide(226)
	
	settings:DockMargin(7, 4, 16, 16)
	settings:Dock(RIGHT)
	
	settings:DockPadding(10, 10, 10, 10)
	
	do
		local maxplayers = settings:Add("DComboBox")
		
		local n = 1
		
		for i = 0, 7 do -- to 2^7 = 128
			maxplayers:AddChoice("#maxplayers_" .. n, n, i == 0)
			n = n * 2
		end
		
		maxplayers.OpenMenu = maxplayersOpenMenu
		
		local options_spanel = settings:Add("DScrollPanel")
		options_spanel:Hide()
		
		maxplayers.OnSelect = function(pnl, index, value, data)
			self.GameSettings["maxplayers"] = data
			
			options_spanel:SetVisible(data ~= 1)
		end
		
		self.Options = options_spanel:Add("GameOptions")
		
		self.Options.OnChange = function(pnl, key, value)
			self.GameSettings[key] = value
		end
		
		self.Options:DockPadding(0, -8, 0, 0)
		self.Options:Dock(TOP)
		
		local startbut = settings:Add("DButton")
		startbut:SetTall(44)
		startbut:SetText("#start_game")
		
		startbut.DoClick = function(pnl)
			return StartGame(self.GameSettings)
		end
		
		maxplayers:Dock(TOP)
		
		options_spanel:DockMargin(0, 8, 0, 0)
		options_spanel:Dock(FILL)
		
		startbut:DockMargin(16, 8, 16, 8)
		startbut:Dock(BOTTOM)
	end
	
	hook.Add("CurrentGamemodeChanged", self, self.OnGamemodeChanged)
	
	self:OnGamemodeChanged(engine.ActiveGamemode())
end

function PANEL:Open()
	if not self.loaded then
		self.loaded = true
		
		self:InitEx()
	end
	
	timer.Simple(0, function()
		self.SearchBox:RequestFocus()
	end)
end

function PANEL:Close()
	
end

function PANEL:PrepareSettings()
	local gm_settings = self.GamemodeSettings
	local settings = self.GameSettings
	
	self.GameSettings = {}
	
	for k, v in pairs(gm_settings) do
		self.GameSettings[v.name] = v.default
	end
	
	self.GameSettings["map"] = settings["map"]
	self.GameSettings["maxplayers"] = settings["maxplayers"]
	self.GameSettings["hostname"] = settings["hostname"]
	self.GameSettings["sv_lan"] = settings["sv_lan"]
	self.GameSettings["p2p_enabled"] = settings["p2p_enabled"]
	self.GameSettings["p2p_friendsonly"] = settings["p2p_friendsonly"]
	
	if self.Options then
		self.Options:UpdateOptions(gm_settings, settings)
	end
end

function PANEL:OnGamemodeChanged(gamemode_name)
	local config = file.Read("gamemodes/" .. gamemode_name .. "/" .. gamemode_name .. ".txt", true)
	local settings
	
	if config then
		local config_tbl = util.KeyValuesToTable(config)
		
		if config_tbl then
			settings = config_tbl["settings"]
		end
	end
	
	self.GamemodeSettings = settings or {}
	
	self:PrepareSettings()
end

--[[function PANEL:Paint(w, h)
	surface.SetDrawColor(color_white)
	surface.DrawRect(0, 0, w, h)
end]]

MainMenuView.Pages.NewGame = vgui.RegisterTable(PANEL, "Panel")
