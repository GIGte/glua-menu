
surface.CreateFont("Menu_MapsCategoryTitle", {
	font	= "Arial",
	size	= 39,
})

surface.CreateFont("Menu_MapsCount", {
	font	= "Arial",
	size	= 17,
	weight	= 500,
})


local col_title = Color(60, 60, 60)
local col_count = Color(125, 125, 125)

local PANEL = {}

function PANEL:Init()
	self.Title = self:Add("DLabel")
	self.Title:SetColor(col_title)
	self.Title:SetFont("Menu_MapsCategoryTitle")
	
	self.Info = self:Add("DLabel")
	self.Info:SetColor(col_count)
	self.Info:SetFont("Menu_MapsCount")
	
	self.Title:DockMargin(4, 0, 0, 0)
	self.Title:Dock(LEFT)
	
	self.Info:DockMargin(8, 15, 0, 0)
	self.Info:Dock(LEFT)
end

function PANEL:SetTitle(str)
	self.Title:SetText(str)
	self.Title:SizeToContents()
end

function PANEL:SetCount(count)
	local str = string.format(
		"%d %s",
		count, count == 1 and
			language.GetPhrase("newgame_map") or
			language.GetPhrase("newgame_maps")
	)
	
	self.Info:SetText(str)
	self.Info:SizeToContents()
end

vgui.Register("MapList_Header", PANEL, "Panel")
