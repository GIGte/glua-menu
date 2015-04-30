
timer.Remove("Cookie_CommitToSQLite")

if MainMenu then
	MainMenu.Destroy()
	MainMenu.DestroyView()
end

--[[local cvar_default = CreateConVar("menu_default", "0", FCVAR_ARCHIVE)

if cvar_default:GetBool() then
	include("../mainmenu.lua")
	return
end]]

local cur_menu = cookie.GetString("MenuType", "1")

concommand.Add("menu_swap", function()
	cur_menu = cur_menu == "1" and "0" or "1"
	--cookie.Set("MenuType", cur_menu)
	sql.Query("INSERT OR REPLACE INTO cookies (key, value) VALUES (\"MenuType\", \"" .. cur_menu .. "\")")
	
	RunConsoleCommand("menu_reload")
end)

if cur_menu == "0" then
	include("../mainmenu.lua")
	return
end


include("../background.lua")

include("mainmenu.lua")
include("commands.lua")
include("events.lua")
include("util.lua")
include("widgets.lua")

MainMenu.Initialize()


MainMenuView = {}

include("gui/background_update.lua")
include("gui/options_factory.lua")
include("gui/pages.lua")

include("gui/pages/addons.lua")
include("gui/pages/default.lua")
include("gui/pages/newgame.lua")

include("gui/panels/addonlist.lua")
include("gui/panels/addonlist_item.lua")
include("gui/panels/gameoptions.lua")
include("gui/panels/logo.lua")
include("gui/panels/mainpanel.lua")
include("gui/panels/mapcat_button.lua")
include("gui/panels/mapcats.lua")
include("gui/panels/maplist.lua")
include("gui/panels/maplist_item.lua")
include("gui/panels/menu.lua")
include("gui/panels/navbar.lua")
include("gui/panels/navbutton.lua")
include("gui/panels/option.lua")
include("gui/panels/title.lua")
include("gui/panels/top.lua")
include("gui/panels/version.lua")
include("gui/panels/widget_button.lua")
include("gui/panels/widget_canvas.lua")
include("gui/panels/widget_popup.lua")

--timer.Simple(0, function()
	MainMenu.InitializeView()
--end)
