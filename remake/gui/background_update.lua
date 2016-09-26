
local function scanScreenshots(dir)
	local files = file.Find(dir .. "*.*", "GAME")
	
	for k, v in pairs(files) do
		AddBackgroundImage(dir .. v)
	end
	
	return #files ~= 0
end

function UpdateBackgroundImages(gamemode_name)
	ClearBackgroundImages()
	
	if not scanScreenshots("gamemodes/" .. gamemode_name .. "/backgrounds/") then
		scanScreenshots("backgrounds/")
	end
	
	ChangeBackground(gamemode_name)
end
