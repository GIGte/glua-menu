
local PANEL = {}

function PANEL:Init()
	self:SetDropPos("82")
	
	self:SetSpaceX(4)
	self:SetSpaceY(6)
end

function PANEL:SetLastMap(map_name)
	self.last_map = map_name
end

function PANEL:ReflectData(maps, incompatible)
	self:Clear()
	
	self.item_selected = nil
	
	local last_map = self.last_map
	
	local last_item
	
	for i = 1, #maps do
		local map_name = maps[i]
		
		local mapbutton = self:Add("MapButton")
		mapbutton:SetMapName(map_name, incompatible)
		
		if last_map and map_name == last_map then
			last_map = nil
			
			mapbutton:SetSelected(true)
			self.item_selected = mapbutton
		end
		
		last_item = mapbutton
	end
	
	-- We still have old children after self:Clear(),
	-- so have to resize our canvas manually.
	
	if last_item then -- HACK
		self:LayoutIcons_TOP()
		self:GetParent():SetTall(last_item:GetPos() + last_item:GetTall())
	end
end

function PANEL:OnMapSelected(item)
	if item == self.item_selected then return end
	
	if self.item_selected then
		self.item_selected:SetSelected(false)
	end
	
	item:SetSelected(true)
	self.item_selected = item
	
	self.last_map = item:GetMapName()
	
	self:OnSelect(self.last_map)
end

function PANEL:OnSelect(map_name)
	
end

vgui.Register("MapList", PANEL, "DIconLayout")
