
local col_selected = Color(150, 200, 255)

local PANEL = {}

function PANEL:Init()
	self.last_click = 0
	
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self:SetCursor("hand")
	
	self:SetWide(140)
	self:SetTall(154)
	
	self.Thumbnail = self:Add("DImage")
	self.Thumbnail:SetPos(6, 6)
	self.Thumbnail:SetSize(128, 128)
	
	self.Label = self:Add("DLabel")
	self.Label:SetPos(6, 135)
	self.Label:SetSize(128, 14)
	self.Label:SetContentAlignment(5)
	self.Label:SetDark(true) -- TODO: font
end

function PANEL:GetMapName()
	return self.map
end

local thumb_src_cache = {}

function PANEL:SetMapName(map_name, incompatible)
	self.map = map_name
	
	local img_src
	
	if incompatible then
		img_src = "../html/img/incompatible.png"
	else
		img_src = thumb_src_cache[map_name]
		
		if not img_src then
			img_src = string.format("maps/thumb/%s.png", map_name)
			
			if not file.Exists(img_src, "GAME") then
				img_src = string.format("maps/%s.png", map_name)
			end
			
			if not file.Exists(img_src, "GAME") then
				img_src = "maps/thumb/noicon.png"
			end
			
			thumb_src_cache[map_name] = img_src
		end
	end
	
	local mat = Material(img_src, "mips smooth")
	
	--[[if mat:IsError() then
		img_src = string.format("maps/%s.png", map_name)
		mat = Material(img_src)
	end
	
	if mat:IsError() then
		img_src = "maps/thumb/noicon.png"
		mat = Material(img_src)
	end]]
	
	self.Thumbnail.ImageName = img_src
	self.Thumbnail:SetMaterial(mat)
	self.Thumbnail:FixVertexLitMaterial()
	
	--self.Thumbnail:SetImage(img_src)
	self.Label:SetText(map_name)
end

function PANEL:IsSelected()
	return self.is_selected
end

function PANEL:SetSelected(state)
	self.is_selected = state
end

function PANEL:OnMouseReleased(mousecode)
	if mousecode == MOUSE_LEFT then
		self:GetParent():OnMapSelected(self)
		
		local time = SysTime()
		
		if self.last_click + 0.2 > time then
			self:GetParent():DoDoubleClick()
		end
		
		self.last_click = time
	end
end

function PANEL:Paint(w, h)
	if self:IsSelected() then
		draw.RoundedBox(4, 0, 0, w, h, col_selected)
	end
end

vgui.Register("MapButton", PANEL, "Panel")
