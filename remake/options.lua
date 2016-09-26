
--[[CreateConVar("menu_r_nosounds", "0")
CreateConVar("menu_r_hidebg", "0")

cvars.AddChangeCallback("menu_r_nosounds", function(name,oldval,newval)
	
end)

cvars.AddChangeCallback("menu_r_hidebg", function(name,oldval,newval)

end)]]

options = {}

local options_table = {}
local options_cb_table = {}

function options.Get(name)
	return options_table[name]
end

function options.Set(name, value)
	local old_value = options_table[name]
	
	options_table[name] = value
	cookie.Set(name, tostring(value))
	
	if options_cb_table[name] then
		options_cb_table[name](old_value, value)
	end
end

function options.Add(name, default_value, onchange)
	options_table[name] = cookie.GetString(name, default_value)
	options_cb_table[name] = onchange
end

options.Add("menu_r_nosounds", "0")

options.Add("menu_r_hidebg", "0", function(oldval, newval)
	local mainpanel = MainMenu.MainPanel
	
	if newval == "1" then
		--ClearBackgroundImages()
		include("menu/background.lua")
	else
		UpdateBackgroundImages(engine.ActiveGamemode())
	end
	
	mainpanel.Paint = DrawBackground
end)
