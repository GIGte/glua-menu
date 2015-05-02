
local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetTall(24)
	--self:SetWide(24)
	
	self:SetCursor("hand")
	
	--[[self.Image = self:Add("DImage")
	self.Image:SetPos(4, 4)
	self.Image:SetSize(16, 16)
	self.Image:SetImage("icon16/help.png")]]
	
	self:SetContentAlignment(4)
	self:SetFont("DermaDefaultBold")
	
	self:SetText("?")
	self:SetTextInset(9, 0)
	
	self:SizeToContentsX(8)
end

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
	gui.OpenURL("https://github.com/gigte/glua-menu")
end

vgui.Register("HelpButton", PANEL, "DLabel")
