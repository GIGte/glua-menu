
WIDGET.Name = "Gamemode Selector"

function WIDGET:Initialize()
	hook.Add("CurrentGamemodeChanged", self, self.OnGamemodeChanged)
	
	self:OnGamemodeChanged(engine.ActiveGamemode())
end

function WIDGET:Destroy()
	
end

function WIDGET:BuildPanel(panel)
	local spanel = panel:Add("DScrollPanel")
	spanel:Dock(FILL)
	
	local function gmButtonDoClick(gmb)
		local gamemode_name = gmb.GamemodeName
		
		self:ClosePanel()
		ChangeGamemode(gamemode_name)
	end
	
	local gamemodes = engine.GetGamemodes()
	
	for i = 1, #gamemodes do
		local info = gamemodes[i]
		
		--if info.name == "base" then continue end
		
		local button = spanel:Add("ControlButton")
		button:SetText(info.title)
		
		local icon = string.format("gamemodes/%s/icon24.png", info.name)
		
		button:SetIcon(icon)
		
		button.GamemodeName = info.name
		button.DoClick = gmButtonDoClick
		
		button:DockMargin(0, i == 1 and 0 or 4, 0, 0)
		button:Dock(TOP)
	end
	
	return 200, 128
end

function WIDGET:OnGamemodeChanged(gamemode_name)
	self.Title = GamemodeInfo(gamemode_name).title
	self.Icon = string.format("../gamemodes/%s/icon24.png", gamemode_name)
	
	self:ReloadView()
end
