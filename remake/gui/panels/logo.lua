
local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
end

function PANEL:SetMaterial(material)
	self.material = material
	
	if not material then return end
	
	self.w = material:GetInt("$realwidth")
	self.h = material:GetInt("$realheight")
	
	self:SetTall(self.h)
end

function PANEL:Paint()
	if not self.material then return end
	
	surface.SetMaterial(self.material)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(0, 0, self.w, self.h)
end

vgui.Register("GMLogo", PANEL, "Panel")
