
surface.CreateFont("Menu_ServersSubtitle", {
	font	= "Arial",
	size	= 15,
	weight	= 500,
	shadow	= true
})


local PANEL = {}

PANEL.Title = "#server_list"

PANEL.Controls = {
	{ name = "#servers_refresh", cmd = "servers_refresh" },
	{ name = "#servers_stoprefresh", cmd = "servers_stoprefresh", groupend = true },
	{ name = "#legacy_browser", cmd = "legacy_browser" },
}

function PANEL:InitEx()
	self.ServerGamemodesList = self:Add("ServerGamemodesList")
	
	self.ServerGamemodesList.OnChoose = function(pnl, gm_data)
		self:GoToServerList(gm_data)
	end
	
	self.ServerList = self:Add("ServerList")
	self.ServerList:Hide()
	
	self.ServerGamemodesList:DockMargin(0, 0, 120, 20)
	self.ServerGamemodesList:Dock(FILL)
	
	self.ServerList:DockMargin(0, 0, 0, 20)
	self.ServerList:Dock(FILL)
	
	self:StartRefreshing()
end

function PANEL:Open()
	if not self.loaded then
		self.loaded = true
		
		self:InitEx()
	end
end

function PANEL:Close()
	self:StopRefreshing()
end

function PANEL:GoToServerList(gm_data)
	self.ServerGamemodesList:Hide()
	self.ServerList:Show()
	
	self.ServerList:ClearServers()
	self.ServerList:SetGamemodeData(gm_data)
	
	local servers = gm_data
	
	for i = 1, #servers do
		local server_data = servers[i]
		
		self.ServerList:AddServer(server_data)
	end
end
function PANEL:GoToGamemodeList()
	self.ServerGamemodesList:Show()
	self.ServerList:Hide()
end

local query_data

function PANEL:StartRefreshing()
	self.ServerList:ClearServers()
	self.ServerGamemodesList:ClearData()
	
	if self.ServersTable then
		self:StopRefreshing()
	end
	
	self.ServersTable = {}
	
	serverlist.StartQuerying(self.ServersTable, self, query_data)
end
function PANEL:StopRefreshing()
	serverlist.StopQuerying(self.ServersTable)
end

function PANEL:OnServerFound(query_id, data)
	--[[
	data:
		ping,
		name,
		desc,
		map,
		players,
		maxplayers,
		botplayers,
		pass,
		lastplayed,
		address,
		gamemode,
		wsid
	]]
	
	local gm_data = self.ServersTable[data.gamemode]
	
	if not gm_data then
		gm_data = {
			Name = data.gamemode,
			Title = data.desc,
			TitleVariatons = {},
			WorkshopID = data.wsid,
			WorkshopIDVariatons = {},
			IsSubscribed = true,
		}
		
		self.ServersTable[data.gamemode] = gm_data
		
		self.ServerGamemodesList:AddElement(gm_data)
	else
		-- weird
		
		local vars = gm_data.TitleVariatons
		vars[data.desc] = (vars[data.desc] or 0) + 1
		
		gm_data.Title = table.GetWinningKey(vars)
		
		local vars = gm_data.WorkshopIDVariatons
		vars[data.wsid] = (vars[data.wsid] or 0) + 1
		
		gm_data.WorkshopID = table.GetWinningKey(vars)
	end
	
	local wsid = gm_data.WorkshopID
	
	if wsid and wsid ~= "" then
		if gm_data.Name == "sandbox" then print(wsid) end
		local is_subscr = steamworks.IsSubscribed(wsid)
		
		gm_data.IsSubscribed = is_subscr
	else
		gm_data.IsSubscribed = true
	end
	
	self.ServerGamemodesList:UpdateInfo(gm_data, data)
	
	if self.ServerList:IsVisible() then
		local gm_data = self.ServerList:GetGamemodeData()
		
		if gm_data.Name == data.gamemode then
			self.ServerList:AddServer(data)
		end
		
		self.ServerList:UpdateGamemodeData(gm_data)
	end
	
	-- remove useless fields
	data.desc = nil
	data.gamemode = nil
	data.wsid = nil
	
	table.insert(gm_data, data)
end

function PANEL:OnSearchFinished()
	print("Search finished!")
end

query_data = {
	Type = "internet",
	GameDir = "garrysmod",
	AppID = 4000,
	
	Callback = PANEL.OnServerFound,
	Finished = PANEL.OnSearchFinished,
}

function PANEL:OnReturnToGamemodesRequested()
	self:GoToGamemodeList()
end

function PANEL:Paint(w, h)
	
end

MainMenuView.Pages.Servers = vgui.RegisterTable(PANEL, "Panel")
