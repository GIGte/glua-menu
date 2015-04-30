
local col_hovered = color_white

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetCursor("hand")
	
	self:SetSize(28, 21)
end

function PANEL:GetCountryCode(code)
	return self.country
end

function PANEL:SetCountryCode(code)
	self.country = code
end

function PANEL:SetImage(image_src)
	self.material = Material(image_src)
end

function PANEL:OnMouseReleased(mousecode)
	if mousecode == MOUSE_LEFT then
		self:DoClick()
	end
end

function PANEL:Paint(w, h)
	if self:IsHovered() then
		draw.RoundedBox(2, 0, 0, w, h, col_hovered)
	end
	
	surface.SetDrawColor(120, 120, 120)
	surface.DrawRect(5, 4, 18, 13)
	
	surface.SetMaterial(self.material)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawTexturedRect(6, 5, 16, 11)
end

--[[function PANEL:DoClick()
	
end]]

vgui.Register("FlagButton", PANEL)
