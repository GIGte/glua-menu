
local PANEL = {}

function PANEL:Init()
	self:DockPadding(12, 8, 12, 12)
end

function PANEL:InitEx()
	self.Container = self:Add("Panel")
	
	self.Title = self.Container:Add("DLabel")
	self.Title:SetFont("DermaDefaultBold")
	self.Title:SetDark(true)
	
	self.ServerInfoRow = self.Container:Add("Panel")
	
	do
		self.IPLabel = self.ServerInfoRow:Add("DLabel")
		self.IPLabel:SetDark(true)
		
		local but_copy = self.ServerInfoRow:Add("DImageButton")
		but_copy:SetSize(16, 16)
		but_copy:SetImage("icon16/page_copy.png")
		
		but_copy.DoClick = function()
			SetClipboardText(self.IPLabel:GetText())
		end
		
		local but_refresh = self.ServerInfoRow:Add("DImageButton")
		but_refresh:SetSize(16, 16)
		but_refresh:SetImage("icon16/arrow_refresh.png")
		
		but_refresh.DoClick = function()
			self:QueryPlayerList() -- TODO: update title
		end
		
		self.IPLabel:Dock(LEFT)
		
		but_copy:DockMargin(10, 4, 0, 4)
		but_copy:Dock(LEFT)
		
		but_refresh:DockMargin(7, 4, 0, 4)
		but_refresh:Dock(LEFT)
	end
	
	self.PlayerList = self.Container:Add("DListView")
	--self.PlayerList:SetSortable(false)
	self.PlayerList.SortByColumn = function() end
	self.PlayerList:SetMultiSelect(false)
	
	self.PlayerList:AddColumn("#playerlist_name")
	self.PlayerList:AddColumn("#playerlist_score"):SetFixedWidth(60)
	self.PlayerList:AddColumn("#playerlist_time"):SetFixedWidth(60)
	
	local but_join = self.Container:Add("DButton")
	but_join:SetTall(40)
	but_join:SetText("#servers_join_server")
	
	but_join.DoClick = function()
		if self.data.pass then
			local pass = self.PasswordBox:GetText()
			RunConsoleCommand("password", pass)
		end
		
		JoinServer(self.data.address)
	end
	
	self.PasswordBox = self.Container:Add("DTextEntryWHint")
	self.PasswordBox:SetPlaceholder("••••••••••")--"Password")
	
	self.Title:Dock(TOP)
	
	--self.ServerInfoRow:DockMargin(0, 8, 0, 8)
	self.ServerInfoRow:DockMargin(0, 3, 0, 3)
	self.ServerInfoRow:Dock(TOP)
	
	self.PlayerList:Dock(FILL)
	
	but_join:DockMargin(0, 7, 0, 0)
	but_join:Dock(BOTTOM)
	
	self.PasswordBox:DockMargin(0, 7, 0, 0)
	self.PasswordBox:Dock(BOTTOM)
	
	self.Container:Dock(FILL)
end

function PANEL:SetContentsVisible(state)
	if self.Container then
		self.Container:SetVisible(state)
	end
end

function PANEL:GetServerData()
	return self.data
end

function PANEL:SetServerData(data)
	if not self.data then
		self:InitEx()
	end
	
	self.data = data
	
	self.Title:SetText(data.name)
	self.Title:SizeToContents()
	
	self.IPLabel:SetText(data.address)
	self.IPLabel:SizeToContents()
	
	self.PlayerList:Clear()
	
	self.PasswordBox:SetVisible(data.pass)
	
	self:QueryPlayerList()
end

function PANEL:QueryPlayerList()
	local ipaddr = self.data.address
	
	serverlist.PlayerList(ipaddr, function(players)
		if ipaddr == self.data.address then
			self:OnPlayersReceived(players)
		end
	end)
end

local function formatTime(time)
	time = math.Round(time)
	
	local num1
	local num2
	
	num2 = time % 60
	
	if time < 60 then
		return string.format("%ds", num2)
	elseif time == 60 then
		return "1m"
	end
	
	time = (time - num2) / 60
	
	num1 = time % 60
	
	if time < 60 then
		return string.format("%dm %ds", num1, num2)
	elseif time == 60 then
		return "1h"
	end
	
	time = (time - num1) / 60
	
	return string.format("%dh %dm", time, num1)
end

function PANEL:OnPlayersReceived(players)
	self.PlayerList:Clear()
	
	table.sort(players, function(a, b)
			return a.score > b.score
		end) 
	
	for i = 1, #players do
		local ply_data = players[i]
		
		self.PlayerList:AddLine(ply_data.name,
			tostring(ply_data.score),
			tostring(formatTime(ply_data.time))
		)
	end
end

function PANEL:Paint(w, h)
	return draw.RoundedBox(6, 0, 0, w, h, color_white)
end

vgui.Register("ServerInfo", PANEL, "Panel")
