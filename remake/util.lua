
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


local last_maplist
local mapindex

function GetMapIndex()
	if GetMapList() ~= last_maplist then
		mapindex = {}
		
		for k, v in pairs(GetMapList()) do
			for i = 1, #v do
				mapindex[v[i]] = k
			end
		end
	end
	
	return mapindex
end

function LoadLastMap() -- override
	local t = string.Explode( ";", cookie.GetString( "lastmap", "" ) )
	
	local map = t[ 1 ] or "gm_flatgrass"
	local cat = t[ 2 ] or "Sandbox"
	
	cat = string.gsub( cat, "'", "\\'" )
	
	return map, cat
end

function StartGame(cvar_table)
	local mapname = cvar_table["map"]
	local category = GetMapIndex()[mapname] -- FIXME
	
	SaveLastMap(mapname, category)
	
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
		
		if cvar_table["maxplayers"] ~= "1" then
			RunConsoleCommand("sv_cheats", "0")
			RunConsoleCommand("commentary", "0")
		end
		
		RunConsoleCommand("map", mapname)
		
		hook.Remove("Think", "GameStartup")
	end)
	
	MainMenu.NavigateTo("Default")
end
