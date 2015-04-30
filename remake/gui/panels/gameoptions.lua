
local PANEL = {}

function PANEL:PerformLayout()
	self:SizeToChildren(false, true)
end

local function controlOnChange(pnl, value)
	return pnl:GetParent():OnChange(pnl.cvar_name, value)
end

function PANEL:AddTextBox(label, help, cv_name, value) -- internal
	local clabel = self:Add("DLabel")
	-- TODO: font
	clabel:SetText(label)
	clabel:SetDark(true)
	clabel:SizeToContents()
	
	clabel:DockMargin(0, 10, 0, 4)
	clabel:Dock(TOP)
	
	local textentry = self:Add("DTextEntry")
	
	if value then
		textentry:SetText(value)
	end
	
	textentry.cvar_name = cv_name
	textentry.OnValueChange = controlOnChange
	
	textentry:DockMargin(0, 0, 0, 2)
	textentry:Dock(TOP)
end

function PANEL:AddNumEntry(label, help, cv_name, value) -- internal
	local holder = self:Add("DSizeToContents")
	
	holder:DockMargin(0, 4, 8, 0)
	holder:Dock(TOP)
	
	local clabel = holder:Add("DLabel")
	-- TODO: font
	clabel:SetText(label)
	clabel:SetDark(true)
	clabel:SizeToContents()
	
	--clabel:DockMargin(0, 4, 0, 0)
	clabel:Dock(FILL)
	
	local textentry = holder:Add("DTextEntry")
	textentry:SetWide(50)
	textentry:SetNumeric(true)
	
	if value then
		textentry:SetText(value)
	end
	
	textentry.cvar_name = cv_name
	textentry.OnValueChange = controlOnChange
	
	textentry:Dock(RIGHT)
	
	holder:SetTall(textentry:GetTall())
end

function PANEL:AddCheckBox(label, help, cv_name, value) -- internal
	local holder = self:Add("DSizeToContents")
	
	holder:DockMargin(4, 12, 0, 2)
	holder:Dock(TOP)
	
	local checkbox = holder:Add("DCheckBox")
	checkbox:SetChecked(value == 1)
	
	checkbox.cvar_name = cv_name
	checkbox.OnChange = controlOnChange
	
	checkbox:DockMargin(0, 0, 12, 0)
	checkbox:Dock(LEFT)
	
	local clabel = holder:Add("DLabel")
	-- TODO: font
	clabel:SetText(label)
	clabel:SetDark(true)
	--clabel:SizeToContents()
	
	clabel:Dock(FILL)
	
	holder:SetTall(checkbox:GetTall())
end

function PANEL:AddOptions(options, typename, func) -- internal
	for k, v in pairs(options) do
		if v.type == typename and v.name and v.text then
			func(self, "#" .. v.text, v.help, v.name, v.default)
		end
	end
end

function PANEL:UpdateOptions(options)
	self:Clear()
	
	self:AddTextBox("#server_name", nil, "hostname",
		options["hostname"] or "Garry's Mod")
	self:AddCheckBox("#lan_server", nil, "sv_lan",
		options["sv_lan"] or 0)
	
	self:AddOptions(options, "Text", self.AddTextBox)
	self:AddOptions(options, "Numeric", self.AddNumEntry)
	self:AddOptions(options, "CheckBox", self.AddCheckBox)
end

function PANEL:OnChange(key, value)
	
end

vgui.Register("GameOptions", PANEL, "Panel")
