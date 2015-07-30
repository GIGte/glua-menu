
local PANEL = {}

function PANEL:Init()
	hook.Add("GameContentChanged", self, self.OnGameContentChanged)
end

function PANEL:PerformLayout()
	
end

function PANEL:SetLastCategory(cat_name)
	self.last_cat = cat_name
end

function PANEL:SetHeaderPanel(panel)
	self.header = panel
end
function PANEL:SetMapListPanel(panel)
	self.maplist = panel
	self:OnGameContentChanged()
end

function PANEL:SelectCategoryButton(catbutton) -- internal
	catbutton:SetSelected(true)
	self.cat_selected = catbutton
	
	local cat_name = catbutton:GetText()
	
	self.last_cat = cat_name
	
	self.header:SetTitle(cat_name)
	self.header:SetCount(catbutton:GetCount())
	
	local maps = g_MapListCategorised[cat_name]
	
	table.sort(maps)
	
	self.maplist:ReflectData(maps, self.search_text,
		cat_name == "Left 4 Dead 2" or cat_name == "Portal 2" or cat_name == "CS: Global Offensive")
end

function PANEL:FilterByText(str)
	self.search_text = str
	
	self.cat_selected = nil
	
	self:OnGameContentChanged()
	
	if not self.cat_selected then -- nothing found
		self.header:SetCount(0)
		self.maplist:Clear()
	end
end

function PANEL:SearchTest(str) -- internal
	if self.search_text == "" or not self.search_text then
		return true
	end
	
	local s, e = string.find(str, self.search_text, 1, true)
	
	return s ~= nil
end

function PANEL:MapsCount(maps) -- internal
	if not self.search_text or self.search_text == "" then
		return #maps
	end
	
	local count = 0
	
	for i = 1, #maps do
		local map_name = maps[i]
		
		if self:SearchTest(map_name) then
			count = count + 1
		end
	end
	
	return count
end

function PANEL:OnGameContentChanged()
	self:Clear()
	
	local last_cat = self.last_cat
	local first = last_cat == nil
	
	-- TODO: sandbox should be first
	
	for k, v in SortedPairs(g_MapListCategorised) do
		local count = self:MapsCount(v)
		
		if count == 0 then
			continue
		end
		
		local catbutton = self:Add("MapCategoryButton")
		catbutton:SetText(k)
		catbutton:SetCount(count)
		
		if first then
			first = false
			
			self:SelectCategoryButton(catbutton)
		elseif last_cat and k == last_cat then
			last_cat = nil
			
			self:SelectCategoryButton(catbutton)
		end
		
		catbutton:DockMargin(0, 0, 0, 5)
		catbutton:Dock(TOP)
	end
end

function PANEL:OnCategorySelected(catbutton)
	if catbutton == self.cat_selected then return end
	
	if self.cat_selected then -- check if it's hidden after search
		self.cat_selected:SetSelected(false)
	end
	
	self:SelectCategoryButton(catbutton)
end

vgui.Register("MapCategoryList", PANEL, "Panel")
