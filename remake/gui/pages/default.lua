
local PANEL = {}

function PANEL:SetupMenuControls(panel, in_game)
	if in_game then
		panel:AddOption("#resume_game", "resume_game")
		
		panel:InsertSpace()
	end
	
	panel:AddOption("#new_game", "new_game")
	panel:AddOption("#find_mp_game", "find_mp_game")
	
	panel:InsertSpace()
	
	panel:AddOption("#addons", "addons")
	
	panel:InsertSpace()
	
	--panel:AddOption("#demos", "demos")
	--panel:AddOption("#saves", "saves")
	
	--panel:InsertSpace()
	
	panel:AddOption("#options", "options")
	
	panel:InsertSpace()
	
	if in_game then
		panel:AddOption("#disconnect", "disconnect")
	end
	
	panel:AddOption("#quit", "quit")
end

function PANEL:Init()
	hook.Add("InGameStateChanged", self, self.InGameChanged)
end

function PANEL:Open()
	
end

function PANEL:Close()
	
end

function PANEL:InGameChanged(state)
	local menu_panel = self.MenuOptionsPanel
	
	if not menu_panel then return end
	
	menu_panel:Clear()
	
	self:SetupMenuControls(menu_panel, state)
	
	menu_panel:InvalidateLayout(true)
end

--[[function PANEL:Paint(w, h)
	surface.SetDrawColor(color_white)
	surface.DrawRect(0, 0, w, h)
end]]

MainMenuView.Pages.Default = vgui.RegisterTable(PANEL, "Panel")
