
local col_hovered_outline = Color(100, 176, 222)
local col_pressed = Color(135, 192, 228)

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetDrawBorder(false)
	self:SetDrawBackground(false)
	
	self:SetTall(40)
	
	self:SetCursor("hand")
	
	self:SetContentAlignment(6)
	self:SetFont("DermaDefault") -- TODO
	
	self:SetText("")
end

function PANEL:PerformLayout()
	if self.m_Image then
		if self:GetText() == "" then
			self.m_Image:SetPos(
				(self:GetWide() - self.m_Image:GetWide()) * 0.5,
				(self:GetTall() - self.m_Image:GetTall()) * 0.5
			)
			
			return
		end
		
		self.m_Image:SetPos(5, (self:GetTall() - self.m_Image:GetTall()) * 0.5)
		
		self:SetTextInset(self.m_Image:GetWide() - 16, 0)
	end
	
	return DLabel.PerformLayout(self)
end

function PANEL:IsDown()
	return self.Depressed
end

function PANEL:SizeToContentsX(addval)
	self:InvalidateLayout(true)
	
	local w, h = self:GetContentSize()
	
	if self.m_Image then
		w = w + 5 + self.m_Image:GetWide() + 8
	else
		w = w + 16
	end
	
	--w = w + 16
	
	self:SetWide(w)
end

function PANEL:SetImage(img)
	if img == nil then
		if self.m_Image then
			self.m_Image:Remove()
		end
	
		return
	end
	
	if not self.m_Image then
		self.m_Image = self:Add("GMLogo") -- костыль
	end
	
	local mat = Material(img)
	
	self.m_Image:SetMaterial(mat)
	self.m_Image:SetWide(self.m_Image.w)
end

PANEL.SetIcon = PANEL.SetImage

function PANEL:Paint(w, h)
	if self:IsDown() then
		draw.RoundedBox(6, 0, 0, w, h, color_white)
		draw.RoundedBox(4, 1, 1, w - 2, h - 2, col_pressed)
	--[[elseif self:IsHovered() then
		draw.RoundedBox(6, 0, 0, w, h, color_black)--col_hovered_outline)
		draw.RoundedBox(4, 1, 1, w - 2, h - 2, color_white)]]
	else
		draw.RoundedBox(6, 0, 0, w, h, color_white)
	end
end

vgui.Register("ControlButton", PANEL, "DButton")
