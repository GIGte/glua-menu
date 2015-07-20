
local col_default = Color(235, 235, 235)
local col_hovered = Color(250, 240, 150)

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetCursor("hand")
	
	self:SetTall(44)
	
	self.Icon = self:Add("DImage")
	self.Icon:SetSize(24, 24)
	
	self.Title = self:Add("DLabel")
	self.Title:SetFont("DermaLarge") -- TODO: font
	self.Title:SetDark(true)
	
	self.Icon:DockMargin(6, 10, 12, 10)
	self.Icon:Dock(LEFT)
	
	self.Title:Dock(FILL)
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
	self:SetAlpha(gm_data.PlayerCount == 0 and 150 or 255)
	
	self.Title:SetText(gm_data.Title)
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
