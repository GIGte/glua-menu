
local PANEL = {}

function PANEL:Init()
	self:SetDropPos("82")
	
	self:SetSpaceX(16)
	self:SetSpaceY(16)
end

function PANEL:LayoutIcons_TOP() -- added centering
	local x			= 0
	local y			= 0
	local RowHeight = 0
	local MaxWidth	= self:GetWide()
	
	local children = self:GetChildren()
	
	local ch_w = children[1]:GetWide() + self.m_iSpaceX
	local column_n = math.floor((MaxWidth + self.m_iSpaceX) / ch_w)
	
	local left_padding
	
	if #children > column_n then
		left_padding = math.floor((MaxWidth - ch_w * column_n) / 2)
		MaxWidth = MaxWidth - x * 2 + 1
		
		x = left_padding
	end
	
	for k, v in pairs(children) do
		local w, h = v:GetSize()
		
		if x + w > MaxWidth || ( v.OwnLine && x > self.m_iBorder ) then
			x = left_padding
			y = y + RowHeight + self.m_iSpaceY
			RowHeight = 0
		end
		
		v:SetPos( x, y )
		
		x = x + v:GetWide() + self.m_iSpaceX
		RowHeight = math.max( RowHeight, v:GetTall() )
		
		-- Start a new line if this panel is meant to be on its own line
		if v.OwnLine then
			x = MaxWidth + 1
		end
	end
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
