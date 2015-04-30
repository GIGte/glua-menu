
local col_bg = Color(235, 235, 235)

local PANEL = {}

function PANEL:Init()
	self:SetPaintBackground(false)
	self:SetBackgroundColor(col_bg)
end

function PANEL:GetPaintBackground()
	return self.Paint == self._Paint
end

function PANEL:SetPaintBackground(state)
	self.Paint = state and self._Paint or nil
end

function PANEL:GetBackgroundColor()
	return self.col_bg
end

function PANEL:SetBackgroundColor(color)
	self.col_bg = color
end

function PANEL:_Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, self:GetBackgroundColor())
end

vgui.Register("WidgetCanvas", PANEL, "Panel")
