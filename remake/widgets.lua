
widgets = {}

widgets.Table = {}

function widgets.GetTable()
	return widgets.Table
end


local widget_meta = {
	Title	= "",
	Icon	= nil,
	
	_isvalid = true,
	
	IsValid = function(self)
		return self._isvalid
	end,
	
	DestroyEx = function(self)
		self._isvalid = false
		return self:Destroy()
	end,
	
	SetViewController = function(self, panel)
		self.view = panel
	end,
	
	ReloadView = function(self)
		return self.view:RequestReload()
	end,
	
	PanelOpened = function() end,
	PanelClosed = function() end,
	
	IsPanelOpened = function(self)
		return self.view:IsOpened()
	end,
	
	OpenPanel = function(self)
		return self.view:Open()
	end,
	ClosePanel = function(self)
		return self.view:Close()
	end,
}

widget_meta.__index = widget_meta

function widgets.Load()
	local files = file.Find("lua/menu/remake/widgets/*.lua", "GAME")
	
	for i = 1, #files do
		local filename = files[i]
		
		WIDGET = setmetatable({}, widget_meta)
		WIDGET.__index = WIDGET
		
		include("widgets/" .. filename)
		
		if WIDGET.DevOnly then continue end
		
		print("Widget Loaded: " .. WIDGET.Name)
		
		filename = string.sub(filename, 1, #filename - 4)
		
		widgets.Table[filename] = WIDGET	
	end
	
	WIDGET = nil
end
