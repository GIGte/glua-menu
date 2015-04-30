
-- That wasn't actually the best idea
-- but it is easier now to leave everything as is

OptionsFactory = {}

OptionsFactory.Pool = {}

function OptionsFactory.UpdateParent(panel)
	OptionsFactory.Panel = panel
	
	local pool = OptionsFactory.Pool
	
	for j = 1, #pool do
		pool[j]:SetParent(panel)
	end
end

local i = 1

function OptionsFactory.GetNext()
	local pool = OptionsFactory.Pool
	local button = pool[i]
	
	i = i + 1
	
	if button then
		if not button:IsVisible() then
			button:Show()
		end
	else
		button = vgui.Create("MenuButton", OptionsFactory.Panel)
		table.insert(pool, button)
	end
	
	return button
end

function OptionsFactory.Finish()
	local pool = OptionsFactory.Pool
	
	for j = i, #pool do
		pool[j]:Hide()
	end
end

function OptionsFactory.Reset()
	i = 1
end
