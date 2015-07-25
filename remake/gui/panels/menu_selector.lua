
local PANEL = {}

function PANEL:Init()
	
end

function PANEL:PerformLayout()
	self:SizeToChildren(true, true)
end

function PANEL:AddOption(...)
	local button = self:GetParent():AddSelectableOption(self, ...)
	
	if self:ChildCount() == 1 then
		self.selected_button = button
		button:SetSelected(true)
	end
end

function PANEL:SetEnlarged(state)
	for k, v in pairs(self:GetChildren()) do
		v:SetEnlarged(state)
		v:DockMargin(0, 0, 0, state and 5 or -3)
	end
end

function PANEL:OnOptionSelected(button, id)
	if button == self.selected_button then return end
	
	self.selected_button:SetSelected(false)
	button:SetSelected(true)
	
	local dep = self.selected_button:GetDependant()
	
	if dep then
		dep:Hide()
	end
	
	dep = button:GetDependant()
	
	if dep then
		dep:Show()
	end
	
	self.selected_button = button
	
	self:OnSelect(button, id)
end

function PANEL:OnSelect(button, id)
	
end

vgui.Register("MenuSelector", PANEL, "Panel")
