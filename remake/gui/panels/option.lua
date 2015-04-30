
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


local col_default = color_white
local col_hovered = Color(255,255,170)

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetCursor("hand")
	
	--self:SetHeight(draw.GetFontHeight("Menu_ButtonLabel"))
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	
	self:SetFontInternal("Menu_ButtonLabel")
	
	self:SetFGColor(col_default)
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
	surface.SetFont("Menu_ButtonLabel_Shadow")
	surface.SetTextPos(2, 2)
	surface.DrawText(self:GetText()) -- possible opz
end

vgui.Register("MenuButton", PANEL, "Label")
