
local PANEL = {}

function PANEL:Init()
	self.Version = self:Add("Version")
	self.Help = self:Add("HelpButton")
	
	self.Version:DockMargin(0, 3, 3, 3)
	self.Version:Dock(RIGHT)
	
	self.Help:DockMargin(3, 3, 3, 3)
	self.Help:Dock(RIGHT)
end

--[[function PANEL:PerformLayout(w, h)
	local cw = self.Version:GetWide()
	self.Version:SetPos(w - cw - 3, 3)
end]]

vgui.Register("UpperBar", PANEL, "Panel")
