
-- In original menu letters are shifted by a pixel.
surface.CreateFont("Menu_ButtonLabel", {
	font	= "Arial Narrow",--"Helvetica", -- find a better font?
	size	= 22,--20,
	weight	= 900
})
surface.CreateFont("Menu_ButtonLabel_Shadow", {
	font	= "Arial Narrow",
	size	= 22,
	weight	= 900,
	blursize = 0
})

surface.CreateFont("Menu_ButtonLabel_B", {
	font	= "Arial",
	size	= 27,
	weight	= 900
})
surface.CreateFont("Menu_ButtonLabel_B_Shadow", {
	font	= "Arial",
	size	= 27,
	weight	= 900,
	blursize = 0
})


local col_default = color_white
local col_hovered = Color(255, 255, 170)

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetCursor("hand")
	
	--self:SetHeight(draw.GetFontHeight("Menu_ButtonLabel"))
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	
	self:SetEnlarged(false)
	
	self:SetFGColor(col_default)
end

function PANEL:SetEnlarged(state)
	local font, font_shadow
	
	if state then
		font = "Menu_ButtonLabel_B"
		font_shadow = "Menu_ButtonLabel_B_Shadow"
	else
		font = "Menu_ButtonLabel"
		font_shadow = "Menu_ButtonLabel_Shadow"
	end
	
	self:SetFontInternal(font)
	self.font_shadow = font_shadow
end

function PANEL:SetCommand(command)
	self.cmd = command
end

function PANEL:OnMouseReleased(mousecode)
	if mousecode == MOUSE_LEFT then
		return RunCommand(self.cmd)--self:DoClick()
	end
end

function PANEL:OnCursorEntered()
	self:SetFGColor(col_hovered)
end

function PANEL:OnCursorExited()
	self:SetFGColor(col_default)
end

function PANEL:Paint()
	surface.SetTextColor(0, 0, 0, 255)
	surface.SetFont(self.font_shadow)
	surface.SetTextPos(2, 2)
	surface.DrawText(self:GetText()) -- possible opz
end

vgui.Register("MenuButton", PANEL, "Label")
