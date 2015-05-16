
local PANEL = {}

function PANEL:Init()
	self:DockPadding(12, 8, 12, 12)
end

function PANEL:InitEx()
	self.Container = self:Add("Panel")
	
	self.Title = self.Container:Add("DLabel")
	self.Title:SetFont("DermaDefaultBold")
	self.Title:SetDark(true)
	
	self.IPLabel = self.Container:Add("DLabel")
	self.IPLabel:SetDark(true)
	
	self.PlayerList = self.Container:Add("DListView")
	self.PlayerList:SetSortable(false)
	self.PlayerList:SetMultiSelect(false)
	
	self.PlayerList:AddColumn("#playerlist_name")
	self.PlayerList:AddColumn("#playerlist_score"):SetFixedWidth(60)
	self.PlayerList:AddColumn("#playerlist_time"):SetFixedWidth(70)
	
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
	
	self.PasswordBox = self.Container:Add("DTextEntry")
	
	self.PasswordBox.Paint = function(pnl, w, h)
		derma.SkinHook("Paint", "TextEntry", pnl, w, h)
		
		if pnl:GetText() == "" then
			surface.SetTextColor(150, 150, 150)
			surface.SetTextPos(6, 3)
			surface.DrawText("Password")
		end
		
		return false
	end
	
	self.Title:Dock(TOP)
	
	self.IPLabel:DockMargin(0, 8, 0, 8)
	self.IPLabel:Dock(TOP)
	
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
	
	local ipaddr = data.address
	
	serverlist.PlayerList(ipaddr, function(players)
		if ipaddr == self.data.address then
			self:OnPlayersReceived(players)
		end
	end)
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
			tostring(ply_data.time)
		)
	end
end

function PANEL:Paint(w, h)
	return draw.RoundedBox(6, 0, 0, w, h, color_white)
end

vgui.Register("ServerInfo", PANEL, "Panel")
