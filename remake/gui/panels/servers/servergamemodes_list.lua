
local PANEL = {}

function PANEL:Init()
	self.Header = self:Add("DSizeToContents")
	
	do
		self.Title = self.Header:Add("MenuTitle")
		self.Title:SetText("#servers_gamemodes")
		self.Title:SizeToContents()
		
		self.Info = self.Header:Add("DLabel") -- TODO: font
		self.Info:SetColor(color_white)
		self.Info:SetText("#servers_gamemodes.subtitle")
		self.Info:SizeToContents()
		
		self.Title:Dock(LEFT) -- BUG: shadow becomes wrong
		
		self.Info:DockMargin(10, 0, 0, 0)
		self.Info:Dock(BOTTOM)
	end
	
	self.ScrollPanel = self:Add("DScrollPanel")
	
	self.ScrollPanel.Paint = function(self, w, h)
		return draw.RoundedBox(6, 0, 0, w, h, color_white)
	end
	
	self.ScrollPanel:GetVBar():DockMargin(0, 5, 5, 5)
	self.ScrollPanel:GetCanvas():DockPadding(5, 0, 5, 5)
	
	self.Header:DockMargin(0, 0, 0, 18)
	self.Header:Dock(TOP)
	
	self.ScrollPanel:DockMargin(5, 5, 5, 0)
	self.ScrollPanel:Dock(FILL)
end

function PANEL:AddElement(gm_data)
	local row = self.ScrollPanel:Add("ServerGamemodeItem")
	row:SetGamemodeData(gm_data)
	
	row:DockMargin(0, 5, 0, 0)
	row:Dock(TOP)
	
	row.DoClick = function(pnl)
		self:OnChoose(pnl:GetGamemodeData())
	end
	
	gm_data.ServerCount = 0
	gm_data.PlayerCount = 0
end

function PANEL:UpdateInfo(gm_data, server_data)
	gm_data.ServerCount = gm_data.ServerCount + 1
	gm_data.PlayerCount = gm_data.PlayerCount + server_data.players
end

function PANEL:ClearData()
	self.ScrollPanel:Clear()
end

--[[function PANEL:OnGamemodeChosen(element)
	self:OnChoose(element:GetGamemodeData())
end]]

function PANEL:OnChoose(gm_data)
	
end

--[[function PANEL:Paint(w, h)
	draw.RoundedBox(6, 0, 0, w, h, color_white)
end]]

vgui.Register("ServerGamemodesList", PANEL, "Panel")
