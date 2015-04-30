
include("gui_panels/flag_button.lua")


WIDGET.Name = "Language Selector"

function WIDGET:Initialize()
	hook.Add("LanguageChanged", self, self.OnLanguageChanged)
	
	self:OnLanguageChanged(Language())
end

function WIDGET:Destroy()
	
end

local MAX_COLUMNS = 7

function WIDGET:BuildPanel(panel)
	panel:SetPaintBackground(true)
	
	local files = file.Find("resource/localization/*.png", "MOD")
	
	local rows = math.ceil(#files / MAX_COLUMNS)
	
	--local row_i = 1
	--local row_cur = 1
	
	local layout = panel:Add("DIconLayout")
	layout:SetSize(220, 0)
	layout:SetPos(22, 20)
	layout:SetSpaceX(4)
	layout:SetSpaceY(4)
	
	local function flagDoClick(flagb)
		local country = flagb:GetCountryCode()
		
		self:ClosePanel()
		ChangeLanguage(country)
	end
	
	for i = 1, #files do
		local filename = files[i]
		
		filename = filename:sub(1, #filename - 4)
		
		local flag = layout:Add("FlagButton")
		flag:SetCountryCode(filename)
		flag:SetImage(string.format("resource/localization/%s.png", filename))
		flag.DoClick = flagDoClick
		
		--[[flag:SetPos(16 + (row_i - 1) * 27, (row_cur - 1) * 20)
		
		row_i = row_i + 1
		
		if row_i > MAX_COLUMNS then
			row_i = 1
			y = y + 20
		end]]
	end
	
	local w, h = layout:GetSize()
	
	return w + 44, (25 * rows - 4) + 40
end

function WIDGET:OnLanguageChanged(lang)
	self.Icon = string.format("../resource/localization/%s.png", lang)
	
	self:ReloadView()
end
