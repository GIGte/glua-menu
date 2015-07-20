
local PANEL = {}

function PANEL:Init()
	self.HeaderContainer = self:Add("DSizeToContents")
	
	do
		self.Header = self.HeaderContainer:Add("DSizeToContents")
		
		do
			self.Title = self.Header:Add("MenuTitle")
			
			self.Info = self.Header:Add("DLabel") -- TODO: font
			self.Info:SetColor(color_white)
			self.Info:SetText("#join_a_server")
			self.Info:SizeToContents()
			
			self.Title:Dock(LEFT) -- BUG: shadow becomes wrong
			
			self.Info:DockMargin(10, 0, 0, 0)
			self.Info:Dock(BOTTOM)
		end
		
		self.ControlBar = self.HeaderContainer:Add("DSizeToContents")
		
		do
			local but_back = self.ControlBar:Add("DButton")
			but_back:SetPos(20, 0)
			but_back:SetTall(30)
			but_back:SetText("#return_to_gamemodes")
			but_back:SizeToContentsX(22)
			
			but_back.DoClick = function()
				return self:GetParent():OnReturnToGamemodesRequested()
			end
			
			self.SearchBox = self.ControlBar:Add("DTextEntryWHint")
			self.SearchBox:SetWide(180)
			self.SearchBox:SetPlaceholder("#searchbar_placeholer") -- typo :\
			
			self.SearchBox.OnChange = function(pnl)
				self.search_filter = pnl:GetText()
				
				self:FilterList()
				self.ServerList:DataLayout(true)
			end
			
			self.SearchBox:DockMargin(0, 2, 0, 2)--0, 5, 0, 5)
			self.SearchBox:Dock(RIGHT)
		end
		
		self.Header:DockMargin(0, 0, 0, 10)
		self.Header:Dock(TOP)
		
		self.ControlBar:Dock(TOP)
	end
	
	self.ListPanel = self:Add("Panel")
		
	self.ListPanel.Paint = function(pnl, w, h)
		return draw.RoundedBox(6, 0, 0, w, h, color_white)
	end
	
	do
		self.ServerList = self.ListPanel:Add("DListView")
		self.ServerList:SetMultiSelect(false)
		
		self.ServerList:AddColumn("#server_name_header")
		self.ServerList:AddColumn("#server_mapname"):SetMaxWidth(140)
		self.ServerList:AddColumn("#server_players"):SetMaxWidth(70)
		self.ServerList:AddColumn("#server_ping"):SetMaxWidth(50)
		self.ServerList:AddColumn("#server_ranking"):SetMaxWidth(80)
		
		self.ServerList.OnRowSelected = function(pnl, id, line)
			self:OnServerSelected(line.data)
		end
		self.ServerList.DoDoubleClick = function(pnl, id, line)
			JoinServer(line.data.address)
		end
		
		self.ServerList:DockMargin(8, 8, 8, 8)
		self.ServerList:Dock(FILL)
	end
	
	self.ServerList.DataLayout = function(self)
		local y = 0
		local h = self.m_iDataHeight
		
		local b = true
		
		for k, v in ipairs( self.Sorted ) do
			if v:IsVisible() then
				v:SetPos( 1, y )
				v:SetSize( self:GetWide()-2, h )
				v:DataLayout( self ) 
				
				v:SetAltLine( b )
				
				b = not b
				
				y = y + v:GetTall()
			end
		end
		
		return y
	end
	
	self.ServerInfo = self:Add("ServerInfo")
	self.ServerInfo:SetWide(310)
	
	self.HeaderContainer:DockMargin(0, 0, 336, 5)
	self.HeaderContainer:Dock(TOP)
	
	self.ListPanel:DockMargin(0, 0, 5, 0)
	self.ListPanel:Dock(FILL)
	
	self.ServerInfo:DockMargin(5, 0, 16, 0)
	self.ServerInfo:Dock(RIGHT)
end

function PANEL:GetGamemodeData()
	return self.data
end

function PANEL:SetGamemodeData(gm_data)
	self.data = gm_data
	
	self.ServerList.VBar:SetScroll(0)
	self.ServerInfo:SetContentsVisible(false)
	
	self:UpdateGamemodeData(gm_data)
end

function PANEL:UpdateGamemodeData(gm_data)
	self.Title:SetText(gm_data.Title)
	self.Title:SizeToContents()
end

function PANEL:SearchTest(str)
	if self.search_filter == "" or not self.search_filter then
		return true
	end
	
	local s, e = string.find(str, self.search_filter, 1, true)
	
	return s ~= nil
end

function PANEL:FilterList()
	local lines = self.ServerList:GetLines()
	
	if self.search_filter == "" then
		for i = 1, #lines do
			local line = lines[i]
			
			line:Show()
		end
		
		return
	end
	
	for i = 1, #lines do
		local line = lines[i]
		
		line:SetVisible(self:SearchTest(line.data.name))
	end
end

local function determineRanking(data)
	local val = data.ping
	
	if not data.hasmap then
		val = val + 20
	end
	
	if data.players == 0 then
		val = val + 100
	end
	
	if data.players == data.maxplayers then
		val = val + 75
	end
	
	if data.pass then
		val = val + 300
	end
	
	return val
end

local function getRank(value)
	value = math.floor(value / 100)
	return value > 5 and 5 or value
end

function PANEL:AddServer(data)
	local pl_count = string.format("%d / %d", data.players, data.maxplayers)
	local rank = determineRanking(data)
	rank = getRank(rank)
	rank = string.rep("* "--[[☆]], rank)--string.format("%d / 5", rank)
	
	local line = self.ServerList:AddLine(
		data.name,
		data.map,
		pl_count,
		tostring(data.ping),
		rank
	)
	
	line.data = data
	
	line:SetSortValue(3, data.players)
	line:SetSortValue(4, data.ping)
	
	if not self:SearchTest(data.name) then
		line:Hide()
	end
end

function PANEL:ClearServers()
	self.ServerList:Clear()
end

function PANEL:OnServerSelected(data)
	self.ServerInfo:SetContentsVisible(true)
	self.ServerInfo:SetServerData(data)
end

vgui.Register("ServerList", PANEL, "Panel")
