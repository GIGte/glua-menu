
MainMenu = {}

function MainMenu.Initialize()
	widgets.Load()
end

function MainMenu.Destroy()

end


function MainMenu.InitializeView()
	MainMenu.MainPanel = MainMenuView.CreateMainPanel()
	
	MainMenu.PageDefault = InitPage("Default")
	
	InitPage("Addons")
	InitPage("NewGame")
	InitPage("Servers")
	
	MainMenu.NavigateTo("Default")
	
	hook.Add("LanguageChanged", "MainMenu_UpdatePhrases", MainMenu.OnLanguageChanged)
end

function MainMenu.NavigateTo(page_name)
	local page = NavOpen(page_name)
	
	MainMenu.MainPanel:PlacePage(page)
	--MainMenu.MainPanel:SetOptions(page.Controls)
	
	hook.Run("PageChanged", page, page == MainMenu.PageDefault)
end

function MainMenu.NavigateBack()
	local page = NavBack()
	
	MainMenu.MainPanel:PlacePage(page)
	--MainMenu.MainPanel:SetOptions(page.Controls)
	
	hook.Run("PageChanged", page, page == MainMenu.PageDefault)
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
