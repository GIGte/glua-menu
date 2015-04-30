
local PANEL = {}

function PANEL:Init()
	self.Version = self:Add("Version")
end

function PANEL:PerformLayout(w, h)
	local cw = self.Version:GetWide()
	self.Version:SetPos(w - cw - 3, 3)
end

vgui.Register("UpperBar", PANEL, "Panel")
