
MainMenuView.Pages = {}

function InitPage(name)
	local tbl = MainMenuView.Pages[name]
	
	name = "Page" .. name
	
	local page = vgui.CreateFromTable(tbl)
	page:SetVisible(false)
	
	MainMenuView[name] = page
	
	return page
end


local page_cur
local page_last

local function navigateTo(page)
	if page_cur then
		page_cur:SetVisible(false)
		page_cur:Close()
	end
	
	page:SetVisible(true)
	page:Open()
	
	page_last = page_cur
	page_cur = page
	
	return page
end

function NavOpen(name)
	name = "Page" .. name
	
	local page = MainMenuView[name]
	
	return navigateTo(page)
end

function NavBack()
	return navigateTo(page_last)
end

function NavCurrent()
	return page_cur
end
