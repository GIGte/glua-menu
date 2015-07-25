
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
include("serverlist_query.lua")
--include("utf8.lua")
include("util.lua")
include("widgets.lua")

MainMenu.Initialize()


MainMenuView = {}

include("gui/background_update.lua")
include("gui/pages.lua")

include("gui/pages/addons.lua")
include("gui/pages/default.lua")
include("gui/pages/newgame.lua")
include("gui/pages/servers.lua")

include("gui/panels/dtextentry_whint.lua")
include("gui/panels/help_button.lua")
include("gui/panels/logo.lua")
include("gui/panels/mainpanel.lua")
include("gui/panels/menu.lua")
include("gui/panels/menu_canvas.lua")
include("gui/panels/menu_option.lua")
include("gui/panels/menu_selector.lua")
include("gui/panels/menu_title.lua")
include("gui/panels/navbar.lua")
include("gui/panels/navbutton.lua")
include("gui/panels/upperbar.lua")
include("gui/panels/version.lua")
include("gui/panels/widget_button.lua")
include("gui/panels/widget_canvas.lua")
include("gui/panels/widget_popup.lua")

include("gui/panels/addons/addonlist.lua")
include("gui/panels/addons/addonlist_item.lua")
include("gui/panels/newgame/gameoptions.lua")
include("gui/panels/newgame/mapcat_button.lua")
include("gui/panels/newgame/mapcats.lua")
include("gui/panels/newgame/maplist.lua")
include("gui/panels/newgame/maplist_header.lua")
include("gui/panels/newgame/maplist_item.lua")
include("gui/panels/servers/server_list.lua")
include("gui/panels/servers/servergamemode_item.lua")
include("gui/panels/servers/servergamemodes_list.lua")
include("gui/panels/servers/serverinfo.lua")

--timer.Simple(0, function()
	MainMenu.InitializeView()
--end)
