
local col_border = Color(50, 50, 50)
local col_bg = color_white

local PANEL = {}

function PANEL:Init()
	self:MakePopup()
	
	self.Canvas = self:Add("WidgetCanvas")
	self.Canvas:DockMargin(3, 3, 3, 3)
	self.Canvas:Dock(FILL)
	
	--hook.Add("VGUIMousePressed", self, self.OnVGUIMousePressed)
end

function PANEL:GetCanvas()
	return self.Canvas
end

--[[function PANEL:OnVGUIMousePressed(panel, mousecode)
	if not self:IsHovered() then
		self:Hide()--self:Remove()
		hook.Remove("VGUIMousePressed", self)
	end
end]]

function PANEL:Paint(w, h)
	draw.RoundedBox(6, 0, 0, w, h, col_border)
	
	--[[if w > 6 and h > 6 then
		draw.RoundedBox(2, 3, 3, w - 6, h - 6, col_bg)
	end]]
end

vgui.Register("WidgetPopup", PANEL, "EditablePanel")
