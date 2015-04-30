
local PANEL = {}

function PANEL:Init()
	self:SetDropPos("82")
	
	self:SetSpaceX(16)
	self:SetSpaceY(16)
end

function PANEL:ReflectData(addons)
	self:Clear()
	
	for i = #addons, 1, -1 do
		local info = addons[i]
		
		local item = self:Add("AddonItem")
		item:SetInfo(info)
	end
end

vgui.Register("AddonList", PANEL, "DIconLayout")
