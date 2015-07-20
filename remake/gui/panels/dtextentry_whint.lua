
local PANEL = {}

function PANEL:GetPlaceholder()
	return self.hint
end

function PANEL:SetPlaceholder(str)
	self.hint = str
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "TextEntry", self, w, h)
	
	if self:GetText() == "" then
		surface.SetTextColor(130, 130, 130)
		surface.SetTextPos(6, math.floor(h / 2) - 7)
		surface.DrawText(self.hint)
	end
	
	return false
end

vgui.Register("DTextEntryWHint", PANEL, "DTextEntry")
