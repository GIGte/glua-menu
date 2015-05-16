
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


local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	
	self:SetFontInternal("Menu_CommonTitle")
	
	self:SetFGColor(color_white)
end

function PANEL:Paint()
	surface.SetTextColor(0, 0, 0, 255)
	surface.SetFont("Menu_CommonTitle_Shadow")
	surface.SetTextPos(2, 2)
	surface.DrawText(self:GetText()) -- possible opz
end

vgui.Register("MenuTitle", PANEL, "Label")
