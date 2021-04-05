
local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetTall(24)
	
	self:SetCursor("hand")
	
	self:SetContentAlignment(5)
	self:SetFont("DermaDefault") -- TODO
	
	if BRANCH ~= "unknown" then
		local text = "You are on %s branch. Click here to find out more. (%s)"
		text = string.format(text, BRANCH, VERSIONSTR)
		
		self:SetText(text)
	else
		self:SetText(VERSIONSTR)
	end
	
	self:SizeToContentsX(14)
end

--[[function PANEL:PerformLayout()
	DLabel.PerformLayout(self)
end]]

--[[function PANEL:OnMouseReleased(mousecode)
	if mousecode == MOUSE_LEFT or mousecode == MOUSE_MIDDLE then
		self:DoClick()
	end
end]]

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, color_black)
	
	return false
end

function PANEL:DoClick()
	if BRANCH ~= "unknown" then
		gui.OpenURL("http://wiki.garrysmod.com/changelist/")
	else
		print("Opening News!")
		gui.OpenURL("http://www.garrysmod.com/updates/")
	end
end

vgui.Register("Version", PANEL, "DLabel")
