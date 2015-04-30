
MainMenu = {}

function MainMenu.Initialize()
	widgets.Load()
end

function MainMenu.Destroy()

end


function MainMenu.InitializeView()
	MainMenu.MainPanel = MainMenuView.CreateMainPanel()
	
	MainMenu.PageDefault = InitPage("Default")
	MainMenu.PageDefault:SetInGame(IsInGame())
	
	InitPage("NewGame")
	InitPage("Addons")
	
	MainMenu.NavigateTo("Default")
	
	hook.Add("InGameStateChanged", "MainMenu_InGameCheck", MainMenu.InGameChanged)
	hook.Add("LanguageChanged", "MainMenu_UpdatePhrases", MainMenu.OnLanguageChanged)
end

function MainMenu.NavigateTo(page_name)
	local page = NavOpen(page_name)
	
	MainMenu.MainPanel:PlacePage(page)
	MainMenu.MainPanel:SetOptions(page.Controls)
	
	hook.Run("PageChanged", page, page == MainMenu.PageDefault)
end

function MainMenu.NavigateBack()
	local page = NavBack()
	
	MainMenu.MainPanel:PlacePage(page)
	MainMenu.MainPanel:SetOptions(page.Controls)
	
	hook.Run("PageChanged", page, page == MainMenu.PageDefault)
end

function MainMenu.InGameChanged(state)
	local page = MainMenu.PageDefault
	
	page:SetInGame(state)
	
	if page == NavCurrent() then
		MainMenu.MainPanel:SetOptions(page.Controls)
	end
end

function MainMenu.OnLanguageChanged()
	timer.Simple(0, function()
		MainMenu.DestroyView() -- FIXME
		MainMenu.InitializeView()
	end)
end

function MainMenu.DestroyView()
	MainMenu.MainPanel:Remove()
	
	-- TODO??
	
	hook.Remove("InGameStateChanged", "MainMenu_InGameCheck")
	hook.Remove("LanguageChanged", "MainMenu_UpdatePhrases")
end
