
local PANEL = {}

function PANEL:Init()
	hook.Add("GameContentChanged", self, self.OnGameContentChanged)
end

function PANEL:PerformLayout()
	
end

function PANEL:SetLastCategory(cat_name)
	self.last_cat = cat_name
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
	
	self.maplist:ReflectData(g_MapListCategorised[cat_name],
		cat_name == "Left 4 Dead 2" or cat_name == "Portal 2" or cat_name == "CS: Global Offensive")
end

function PANEL:OnGameContentChanged()
	self:Clear()
	
	local last_cat = self.last_cat
	local first = last_cat == nil
	
	for k, v in pairs(g_MapListCategorised) do
		local catbutton = self:Add("MapCategoryButton")
		catbutton:SetText(k)
		catbutton:SetCount(#v)
		
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
	
	self.cat_selected:SetSelected(false)
	
	self:SelectCategoryButton(catbutton)
end

vgui.Register("MapCategoryList", PANEL, "Panel")
