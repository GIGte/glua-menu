
local PANEL = {}

function PANEL:Init()
	self.items = {}
	self.items_last_y = 5
	
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

function PANEL:PerformLayout(w, h)
	local canvas = self.ScrollPanel:GetCanvas()
	local cw, ch = canvas:GetSize()
	
	w = cw - (ch + 10 > h and 15 or 10)
	
	local items = self.items
	
	for i = 1, #items do
		local item = items[i]
		
		item:SetWide(w)
	end
end

function PANEL:SortChildren() -- internal
	local items = self.items
	
	table.sort(items, function(a, b)
			a, b = a:GetGamemodeData(), b:GetGamemodeData()
			return a.PlayerCount > b.PlayerCount
		end)
	
	local y = 5
	
	for i = 1, #items do
		local item = items[i]
		
		item:SetPos(5, y)--item:Dock(TOP)
		y = y + item:GetTall() + 5
	end
end

function PANEL:AddElement(gm_data)
	local panel = self.ScrollPanel:Add("ServerGamemodeItem")
	panel:SetGamemodeData(gm_data)
	
	--panel:DockMargin(0, 5, 0, 0)
	--panel:Dock(TOP)
	
	local y = self.items_last_y
	
	panel:SetPos(5, y)
	
	self.items_last_y = y + panel:GetTall() + 5
	
	panel.DoClick = function(pnl)
		self:OnChoose(pnl:GetGamemodeData())
	end
	
	table.insert(self.items, panel)
	
	gm_data.Panel = panel
	
	gm_data.ServerCount = 0
	gm_data.PlayerCount = 0
end

function PANEL:UpdateInfo(gm_data, server_data)
	local panel = gm_data.Panel
	
	gm_data.ServerCount = gm_data.ServerCount + 1
	gm_data.PlayerCount = gm_data.PlayerCount + server_data.players
	
	panel:UpdateGamemodeData(gm_data)
	
	if self.is_sort_pending then return end
	
	local items = self.items
	
	for i = 1, #items do
		local item = items[i]
		
		local item_data = item:GetGamemodeData()
		
		if gm_data.PlayerCount > item_data.PlayerCount and panel ~= item then
			self.is_sort_pending = true
			
			timer.Simple(1.5, function()
				if self:IsValid() then
					self.is_sort_pending = nil
					self:SortChildren()
				end
			end)
			
			break
		end
	end
end

function PANEL:ClearData()
	self.ScrollPanel:Clear()
	
	self.items = {}
	self.items_last_y = 5
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
