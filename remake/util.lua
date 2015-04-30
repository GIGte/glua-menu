
function Language()
	return GetConVarString("gmod_language")
end

function ChangeLanguage(lang)
	RunConsoleCommand("gmod_language", lang)
end


function GamemodeInfo(gamemode_name)
	local gamemodes = engine.GetGamemodes()
	
	for i = 1, #gamemodes do
		local info = gamemodes[i]
		
		if info.name == gamemode_name then
			return info
		end
	end
end

function ActiveGamemodeInfo()
	return GamemodeInfo(engine.ActiveGamemode())
end

function ChangeGamemode(gamemode_name)
	RunConsoleCommand("gamemode", gamemode_name)
end


function LoadLastMap() -- override
	local t = string.Explode( ";", cookie.GetString( "lastmap", "" ) )
	
	local map = t[ 1 ] or ""
	--local cat = t[ 2 ] or ""
	
	local mapinfo = g_MapList[ map .. ".bsp" ]
	
	if ( !mapinfo ) then map = "gm_flatgrass" end
	--if ( !g_MapListCategorised[ cat ] ) then cat = mapinfo and mapinfo.Category or "Sandbox" end
	
	--cat = string.gsub( cat, "'", "\\'" )
	
	return map
end

function StartGame(cvar_table)
	SaveLastMap(cvar_table["map"], nil)
	
	--hook.Run("StartGame")
	RunConsoleCommand("progress_enable")
	RunConsoleCommand("disconnect")
	
	hook.Add("Think", "GameStartup", function()--timer.Simple(0, function()
		if IsInGame() then return end
		
		for k, v in pairs(cvar_table) do
			if k ~= "map" then
				RunConsoleCommand(k, v)
			end
		end
		
		if GetConVarString("maxplayers") ~= "1" then
			RunConsoleCommand("sv_cheats", "0")
			RunConsoleCommand("commentary", "0")
		end
	
		RunConsoleCommand("map", cvar_table["map"])
		
		hook.Remove("Think", "GameStartup")
	end)
	
	MainMenu.NavigateTo("Default")
end
