
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
local col_selected = Color(255, 255, 85)

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

function PANEL:PerformLayout()
	self:SetFGColor(self.col or col_default)
	self.PerformLayout = nil
end

function PANEL:AddOption(...)
	return self:GetParent():AddSubOption(self, ...)
end

function PANEL:AddSelector(...)
	return self:GetParent():AddSubSelector(self, ...)
end

function PANEL:SetEnlarged(state)
	if self.subsidary and state then
		self.enlarged_ = state
		return
	end
	
	self.enlarged = state
	
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
	
	self:SetTextInset(0, state and -4 or -6)
end

function PANEL:GetDependant()
	return self.dependant
end
function PANEL:SetDependant(panel)
	self.dependant = panel
end

function PANEL:IsSelectable()
	return self.selectable
end
function PANEL:SetSelectable(state)
	self.selectable = state
end

function PANEL:IsSelected()
	return self.selected
end
function PANEL:SetSelected(state)
	assert(self.selectable)
	
	self.selected = state
	
	self.col = state and col_selected or
		self:IsHovered() and col_hovered or col_default
	self:SetFGColor(self.col)
end

function PANEL:IsSubsidary()
	return self.subsidary
end

function PANEL:SetSubsidary(state)
	self.subsidary = state
	
	if state then
		self.enlarged_ = self.enlarged
		self:SetEnlarged(state)
	elseif self.enlarged_ ~= nil then
		self:SetEnlarged(self.enlarged_)
	end
end

function PANEL:SetCommand(command)
	self.cmd = command
end

function PANEL:SetFunction(func)
	self.cmd = func
end

function PANEL:Select()
	assert(self.selectable)
	
	self:GetParent():OnOptionSelected(self)
end

function PANEL:OnMouseReleased(mousecode)
	if mousecode == MOUSE_LEFT then
		if self.selectable then
			self:GetParent():OnOptionSelected(self, self.cmd)
			return
		end
		
		if not self.cmd then return end
		
		PlayUISound("click")
		
		if isstring(self.cmd) then
			return RunCommand(self.cmd)--self:DoClick()
		else
			self.cmd(self)
		end
	end
end

function PANEL:OnCursorEntered()
	if not self.selected then
		self:SetFGColor(col_hovered)
	end
	
	PlayUISound("hover")
end

function PANEL:OnCursorExited()
	if not self.selected then
		self:SetFGColor(col_default)
	end
end

function PANEL:Paint()
	surface.SetTextColor(0, 0, 0, 255)
	surface.SetFont(self.font_shadow)
	surface.SetTextPos(2, 2-5)
	surface.DrawText(self:GetText()) -- possible opz
end

vgui.Register("MenuButton", PANEL, "Label")
