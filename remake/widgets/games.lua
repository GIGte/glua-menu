
WIDGET.Name = "Game Content Selector"

WIDGET.Icon = "../html/img/games.png"

function WIDGET:Initialize()
	hook.Add("GameContentChanged", self, self.OnGameContentChanged)
end

function WIDGET:Destroy()
	
end

function WIDGET:BuildPanel(panel)
	local spanel = panel:Add("DScrollPanel")
	spanel:Dock(FILL)
	
	-- FIXME
	
	local col_default = color_white
	local col_disabled = Color(190, 190, 190)
	
	local function backPaint(pnl, w, h)
		draw.RoundedBox(4, 0, 0, w, h, pnl.color)
	end
	
	local function cboxLabelPerformLayout(pnl)
		local x = pnl.m_iIndent or 0
		
		pnl.Button:SetSize(15, 15)
		pnl.Button:SetPos(0, 0)
		
		pnl.Label:SizeToContents()
		pnl.Label:SetPos(x + 14 + 10, 0)
	end
	
	local function cboxLabelOnChange(pnl, state)
		engine.SetMounted(pnl.AppID, state)
		print(string.format("App %d was %s!", pnl.AppID, state and "mounted" or "unmounted"))
	end
	
	local games = engine.GetGames()
	
	table.SortByMember(games, "title", true) 
	
	for i = 1, #games do
		local game = games[i]
		
		local enabled = game.owned and game.installed
		
		local back = spanel:Add("Panel")
		--back:SetBackgroundColor(color_white)
		back:SetTall(20)
		
		back.color = enabled and col_default or col_disabled
		back.Paint = backPaint
		
		back:DockMargin(0, i == 1 and 0 or 2, 1, 0)
		back:Dock(TOP)
		
		if enabled then
			local cboxLabel = back:Add("DCheckBoxLabel")
			cboxLabel:SetPos(4, 3)
			cboxLabel:SetText(game.title)
			cboxLabel:SetDark(true)
			cboxLabel.Label:SetFont("DermaDefaultBold")
			cboxLabel:SetIndent(2)
			
			cboxLabel.PerformLayout = cboxLabelPerformLayout
			cboxLabel.OnChange = cboxLabelOnChange
			
			cboxLabel:SizeToContents()
			
			cboxLabel.AppID = game.depot
			cboxLabel:SetChecked(game.mounted)
		else
			local icon = back:Add("DImage")
			icon:SetPos(4, 2)
			icon:SetSize(16, 16)
			icon:SetImage(game.owned and "icon16/folder_delete.png" or "icon16/cross.png")
			
			local label = back:Add("DLabel")
			label:SetPos(30, 3)
			label:SetText(game.title)
			label:SetDark(true)
			label:SetFont("DermaDefaultBold")
			label:SizeToContents()
		end
	end
	
	return 230, 300
end

function WIDGET:OnGameContentChanged()
	--if self:IsPanelOpened() then
		self:ReloadView() -- FIXME
	--end
end
