
MainMenu.CommandHandlers = {
	["back"] = function()
		return MainMenu.NavigateBack()
	end,
	
	["resume_game"] = function()
		return gui.HideGameUI()
	end,
	
	["new_game"] = function()
		return MainMenu.NavigateTo("NewGame")
	end,
	["find_mp_game"] = function()
		return MainMenu.NavigateTo("Servers")
	end,
	
	["addons"] = function()
		return MainMenu.NavigateTo("Addons")
	end,
	["demos"] = function()
		return gui.OpenURL(
			"http://steamcommunity.com/workshop/browse/?appid=4000&requiredtags[]=demo")
	end,
	["saves"] = function()
		return gui.OpenURL(
			"http://steamcommunity.com/workshop/browse/?appid=4000&requiredtags[]=Save")
	end,
	
	["options"] = function()
		return RunGameUICommand("OpenOptionsDialog")
	end,
	
	["disconnect"] = function()
		return RunGameUICommand("engine disconnect")
	end,
	["quit"] = function()
		return RunGameUICommand("Quit")
	end,
	
	["servers_refresh"] = function()
		NavCurrent():StartRefreshing()
	end,
	["servers_stoprefresh"] = function()
		NavCurrent():StopRefreshing()
	end,
	
	["legacy_browser"] = function()
		return RunGameUICommand("OpenServerBrowser")
	end,
	
	["open_workshop"] = function()
		return steamworks.OpenWorkshop()
	end,
}

function RunCommand(name, ...)
	return MainMenu.CommandHandlers[name](...)
end
