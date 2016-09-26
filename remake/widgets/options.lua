
WIDGET.Name = "GLuaMenu Options"

WIDGET.Icon = "icon16/cog.png"

function WIDGET:Initialize()
	
end

function WIDGET:Destroy()
	
end

local function addCheckBox(panel, text, tooltip, cvar_name)
	local cboxLabel = panel:Add("DCheckBoxLabel")
	cboxLabel:SetText(text)
	cboxLabel:SetTooltip(tooltip)
	cboxLabel:SetDark(true)
	cboxLabel.Label:SetFont("DermaDefaultBold")
	cboxLabel:SizeToContents()
	
	--cboxLabel:SetConVar(cvar_name)
	cboxLabel:SetChecked(options.Get(cvar_name) == "1")
	cboxLabel.OnChange = function(pnl, value)
		value = value == true and "1" or "0"
		options.Set(cvar_name, value)
	end
	
	cboxLabel:DockMargin(0, 10, 0, 0)
	cboxLabel:Dock(TOP)
	
	return cboxLabel
end

function WIDGET:BuildPanel(panel)
	panel:SetPaintBackground(true)
	
	panel:DockPadding(12, 4, 0, 0)
	
	addCheckBox(panel, "Disable sounds", nil, "menu_r_nosounds")
	addCheckBox(panel, "Hide background", [[Loading a background is somewhat slow,
		and checking that is the last thing you
		can do to make main menu even faster!]], "menu_r_hidebg")
	--addCheckBox(panel, "Check for updates",
	--	"Check for newer version of GLuaMenu when the game starts", "menu_r_checkupdates")
	
	local info = panel:Add("DLabel")
	info:SetText([[GLuaMenu is made by GIG. To find out
		more press [?] at the top!]])
	info:SetColor(Color(160, 160, 160))
	info:SizeToContents()
	
	info:DockMargin(0, 16, 0, 0)
	info:Dock(TOP)
	
	--[[local version = panel:Add("DLabel")
	version:SetText("Version: ")
	version:SetColor(Color(160, 160, 160))
	version:SizeToContents()
	
	version:DockMargin(0, 8, 0, 0)
	version:Dock(TOP)]]
	
	return 210, 106--153
end

function WIDGET:PanelOpened()
	
end
