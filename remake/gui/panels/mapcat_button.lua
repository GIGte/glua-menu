
local col_default = Color(220, 220, 220)
local col_selected = Color(155, 205, 255)

local PANEL = {}

local function countPaint(pnl, w, h)
	return draw.RoundedBox(6, 0, 0, w, h, color_white)
end

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetWide(190)
	self:SetTall(26)
	
	self:SetCursor("hand")
	
	self:SetContentAlignment(4)
	self:SetFont("DermaDefaultBold") -- TODO
	
	self:SetDark(true)
	
	self.CountLabel = self:Add("DLabel")
	self.CountLabel:SetTall(16)
	self.CountLabel:SetContentAlignment(5) -- TODO
	--self.CountLabel:SetText("0")
	self.CountLabel:SetDark(true)
	
	self.CountLabel.Paint = countPaint
end

function PANEL:PerformLayout(w, h)
	self:SetTextInset(8, 0)
	
	if not self.CountLabel then return end
	
	local cw = self.CountLabel:GetWide()
	self.CountLabel:SetPos(w - cw - 5, 5)
	
	--return DLabel.PerformLayout(self)
end

function PANEL:IsSelected()
	return self.is_selected
end

function PANEL:SetSelected(state)
	self.is_selected = state
end

function PANEL:SetCount(count)
	self.CountLabel:SetText(tostring(count))
	self.CountLabel:SizeToContentsX(10)
	
	self:InvalidateLayout(true)
end

function PANEL:DoClick()
	self:GetParent():OnCategorySelected(self)
end

function PANEL:Paint(w, h)
	local col = self:IsSelected() and col_selected or col_default
	
	draw.RoundedBox(6, 0, 0, w, h, col)
end

vgui.Register("MapCategoryButton", PANEL, "DLabel")
