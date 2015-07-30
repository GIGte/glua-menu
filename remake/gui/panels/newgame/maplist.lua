
local PANEL = {}

function PANEL:Init()
	self:SetDropPos("82")
	
	self:SetSpaceX(4)
	self:SetSpaceY(6)
end

function PANEL:SetLastMap(map_name)
	self.last_map = map_name
end

function PANEL:TestString(str, filter) -- internal
	if filter == "" or not filter then
		return true
	end
	
	local s, e = string.find(str, filter, 1, true)
	
	return s ~= nil
end

function PANEL:ReflectData(maps, filter, incompatible)
	self:Clear()
	
	for k, v in pairs(self:GetChildren()) do
		v:Hide() -- to skip them
	end
	
	self.item_selected = nil
	
	local last_map = self.last_map
	
	local last_item
	
	for i = 1, #maps do
		local map_name = maps[i]
		
		if not self:TestString(map_name, filter) then
			continue
		end
		
		local mapbutton = self:Add("MapButton")
		mapbutton:SetMapName(map_name, incompatible)
		
		if last_map and map_name == last_map then
			last_map = nil
			
			mapbutton:SetSelected(true)
			self.item_selected = mapbutton
		end
		
		last_item = mapbutton
	end
	
	-- The old children are still present after self:Clear(),
	-- so we have to resize our canvas manually.
	
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

function PANEL:DoDoubleClick()
	
end

vgui.Register("MapList", PANEL, "DIconLayout")
