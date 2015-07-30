
do
	local first = true

	timer.Simple(0, function()
		first = false
	end)

	-- called from the engine
	function LanguageChanged(lang)
		if first then
			return
		end
		
		hook.Run("LanguageChanged", lang)
	end
end

do
	local cur_gm = engine.ActiveGamemode()
	
	hook.Add("GameContentChanged", "GMChangedCheck", function()
		if cur_gm ~= engine.ActiveGamemode() then
			cur_gm = engine.ActiveGamemode()
			
			hook.Run("CurrentGamemodeChanged", cur_gm)
		end
	end)
end

do
	local in_game = IsInGame()
	
	--timer.Create("InGameStateCheck", 1, 0, function()
	hook.Add("Think", "InGameStateCheck", function()
		if in_game ~= IsInGame() then
			in_game = not in_game
			
			hook.Run("InGameStateChanged", in_game)
		end
	end)
end

do -- костыль
	local custom_fonts = {}
	
	local createFont = surface.CreateFont
	function surface.CreateFont(name, data)
		custom_fonts[name] = data
		return createFont(name, data)
	end
	
	local panel = vgui.Create("Panel")
	panel:SetEnabled(false)
	
	local first = true
	
	function panel:PerformLayout()
		if first then
			first = false
			return
		end
		
		timer.Simple(0.01, function()
			--hook.Run("ReloadFonts")
			
			for k, v in pairs(custom_fonts) do
				print("Font \"", k, "\" reloaded")
				createFont(k, v)
			end
		end)
	end
end
