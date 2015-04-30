
local PANEL = {}

function PANEL:Init()
	self.Title = self:Add("MenuTitle")
	self.Title:Hide()
	
	OptionsFactory.UpdateParent(self)
end

function PANEL:PerformLayout()
	local pool = OptionsFactory.Pool
	
	local y = 0
	
	if self.Title:IsVisible() then
		y = y + 65
	end
	
	for i = 1, #pool do
		local button = pool[i]
		
		if not button:IsVisible() then break end
		
		button:SetPos(0, y)
		button:SizeToContents()--button:SetWidth(w)
		
		y = y + button:GetTall() + (button.groupend and 19 or -1)
	end
end

function PANEL:ReflectData(options_table)
	OptionsFactory.Reset()
	
	for i = 1, #options_table do
		local opt = options_table[i]
		
		local button = OptionsFactory.GetNext()
		button:SetText(opt.name)
		button:SetCommand(opt.cmd)
		button.groupend = opt.groupend
	end
	
	OptionsFactory.Finish()
	
	self:InvalidateLayout(true)
	self:InvalidateChildren()
end

function PANEL:SetTitle(title)
	if title then
		self.Title:SetText(title)
		self.Title:SizeToContents()
	end
	
	local vis_changed = self.Title:IsVisible() ~= (title ~= nil)
	
	if vis_changed then
		self.Title:SetVisible(title ~= nil)
		
		self:InvalidateLayout(true)
	end
end

vgui.Register("MenuOptions", PANEL, "Panel")
