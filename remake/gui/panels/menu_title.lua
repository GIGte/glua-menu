
-- In original menu letters are shifted by a pixel.
surface.CreateFont("Menu_CommonTitle", {
	font	= "Arial Narrow",--"Helvetica", -- find a better font?
	size	= 33,
	weight	= 700
})
surface.CreateFont("Menu_CommonTitle_Shadow", {
	font	= "Arial Narrow",
	size	= 33,
	weight	= 700,
	blursize = 0
})

surface.CreateFont("Menu_CommonTitle_B", {
	font	= "Arial",--"Helvetica",
	size	= 40,
	weight	= 900
})
surface.CreateFont("Menu_CommonTitle_B_Shadow", {
	font	= "Arial",
	size	= 40,
	weight	= 900,
	blursize = 0
})


local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	
	self:SetEnlarged(false)
	
	self:SetFGColor(color_white)
end

function PANEL:SetEnlarged(state)
	local font, font_shadow
	
	if state then
		font = "Menu_CommonTitle_B"
		font_shadow = "Menu_CommonTitle_B_Shadow"
	else
		font = "Menu_CommonTitle"
		font_shadow = "Menu_CommonTitle_Shadow"
	end
	
	self:SetFontInternal(font)
	self.font_shadow = font_shadow
end

function PANEL:Paint()
	surface.SetTextColor(0, 0, 0, 255)
	surface.SetFont(self.font_shadow)
	surface.SetTextPos(2, self:GetDock() == TOP and 2 or 2-5)
	surface.DrawText(self:GetText()) -- possible opz
end

vgui.Register("MenuTitle", PANEL, "Label")
