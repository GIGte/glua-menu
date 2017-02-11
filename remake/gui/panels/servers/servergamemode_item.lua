
surface.CreateFont("Menu_ServerGamemode", {
	font = "Arial",
	size = 24,
	weight = 700,
	extended = true
})

surface.CreateFont("Menu_ServerGamemodeInfo", {
	font = "Arial",
	size = 14,
	extended = true
})


local col_default = Color(235, 235, 235)
local col_hovered = Color(250, 240, 150)

local col_info	  = Color(100, 100, 100)

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetCursor("hand")
	
	self:SetTall(44)
	
	self.Icon = self:Add("DImage")
	self.Icon:SetSize(24, 24)
	
	self.InstallButton = self:Add("DButton")
	self.InstallButton:SetWide(42)
	self.InstallButton:SetText("+")
	
	self.InstallButton.DoClick = function(pnl)
		steamworks.Subscribe(pnl.wsid)
		
		pnl:Remove()
	end
	
	self.Title = self:Add("DLabel")
	self.Title:SetDark(true)
	self.Title:SetFont("Menu_ServerGamemode")
	
	self.Info = self:Add("DLabel")
	self.Info:SetTall(12)
	self.Info:SetColor(col_info)
	self.Info:SetFont("Menu_ServerGamemodeInfo")
	
	self.Title:DockMargin(0, 3, 0, 0)
	self.Title:Dock(FILL)
	
	self.Icon:DockMargin(6, 10, 12, 10)
	self.Icon:Dock(LEFT)
	
	self.InstallButton:Dock(RIGHT)
	
	self.Info:DockMargin(4, 0, 0, 5)
	self.Info:Dock(BOTTOM)
end

function PANEL:GetGamemodeData()
	return self.data
end

function PANEL:SetGamemodeData(gm_data)
	self.data = gm_data
	
	do
		local img_src = string.format("gamemodes/%s/icon24.png", gm_data.Name)
		
		local mat = Material(img_src, "smooth")
		
		if mat:IsError() then
			img_src = "gamemodes/base/icon24.png"
			mat = Material(img_src, "smooth")
		end
		
		self.Icon.ImageName = img_src
		self.Icon:SetMaterial(mat)
		self.Icon:FixVertexLitMaterial()
	end
	
	self:UpdateGamemodeData(gm_data)
end

function PANEL:UpdateGamemodeData(gm_data)
	self:SetAlpha(gm_data.PlayerCount == 0 and 130 or 255)
	
	self.Title:SetText(gm_data.Title)
	
	local info = string.format("%d %s %d %s",
		gm_data.PlayerCount, language.GetPhrase("servers_players_on"),
		gm_data.ServerCount, language.GetPhrase("servers_servers"))
	
	self.Info:SetText(info)
	
	local is_subscr = gm_data.IsSubscribed
	
	if is_subscr then
		--if self.InstallButton then
			self.InstallButton:Hide()
		--end
	else
		--[[if not self.InstallButton then
			self.InstallButton = self:Add("DButton")
			self.InstallButton:SetWide(42)
			self.InstallButton:SetText("+")
			
			self.InstallButton.DoClick = function(pnl)
				steamworks.Subscribe(self.wsid)
				
				pnl:Remove()
			end
			
			self.InstallButton:Dock(RIGHT)
		end]]
		
		self.InstallButton.wsid = gm_data.WorkshopID
		
		self.InstallButton:Show()
	end
end

function PANEL:OnMouseReleased(mousecode)
	if mousecode == MOUSE_LEFT then
		self:DoClick()--self:GetParent():OnGamemodeChosen(self)
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, self:IsHovered() and col_hovered or col_default)
end

vgui.Register("ServerGamemodeItem", PANEL, "Panel")
