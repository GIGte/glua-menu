
local PANEL = {}

local controls_def = {
	--{ name = "#resume_game", cmd = "resume_game", groupend = true },
	{ name = "#new_game", cmd = "new_game" },
	{ name = "#find_mp_game", cmd = "find_mp_game", groupend = true },
	{ name = "#addons", cmd = "addons", groupend = true },
	--{ name = "#demos", cmd = "demos" },
	--{ name = "#saves", cmd = "saves", groupend = true },
	{ name = "#options", cmd = "options", groupend = true },
	--{ name = "#disconnect", cmd = "disconnect" },
	{ name = "#quit", cmd = "quit" },
}

local controls_ingame = {
	{ name = "#resume_game", cmd = "resume_game", groupend = true },
	{ name = "#new_game", cmd = "new_game" },
	{ name = "#find_mp_game", cmd = "find_mp_game", groupend = true },
	{ name = "#addons", cmd = "addons", groupend = true },
	--{ name = "#demos", cmd = "demos" },
	--{ name = "#saves", cmd = "saves", groupend = true },
	{ name = "#options", cmd = "options", groupend = true },
	{ name = "#disconnect", cmd = "disconnect" },
	{ name = "#quit", cmd = "quit" },
}

PANEL.Controls = controls_def

function PANEL:Open()
	
end

function PANEL:Close()
	
end

function PANEL:SetInGame(state)
	if state then
		self.Controls = controls_ingame
	else
		self.Controls = controls_def
	end
end

--[[function PANEL:Paint(w, h)
	surface.SetDrawColor(color_white)
	surface.DrawRect(0, 0, w, h)
end]]

MainMenuView.Pages.Default = vgui.RegisterTable(PANEL, "Panel")
