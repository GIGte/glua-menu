
Cache_PreviewID = Cache_PreviewID or {}
Cache_PreviewImage = Cache_PreviewImage or {}

local col_default = Color(210, 210, 210)
local col_inactive = Color(245, 245, 245)
local col_disabled = Color(160, 160, 160)

local PANEL = {}

function PANEL:Init()
	self:SetWide(160)
	self:SetTall(160)
	
	self.Thumbnail = self:Add("DImage")
	self.Thumbnail:SetPos(30, 24)
	self.Thumbnail:SetSize(100, 100)
	self.Thumbnail:SetImage("../html/img/addonpreview.png")
	
	self.Title = self:Add("DLabel")
	self.Title:SetPos(6, 4)
	self.Title:SetFont("DermaDefaultBold")
	self.Title:SetDark(true)
	
	self.Title:SetMouseInputEnabled(true)
	self.Title:SetCursor("hand")
	
	self.Title.DoClick = function()
		steamworks.ViewFile(self.addon_info.wsid)
	end
	
	self.ButtonEnable = self:Add("DButton")
	self.ButtonEnable:SetPos(6, 132)
	self.ButtonEnable:SetSize(65, 20)
	
	self.ButtonEnable.DoClick = function()
		local info = self.addon_info
		steamworks.SetShouldMountAddon(info.wsid, not info.mounted)
		steamworks.ApplyAddons()
	end
	
	self.ButtonDelete = self:Add("DButton")
	self.ButtonDelete:SetPos(89, 132)
	self.ButtonDelete:SetSize(65, 20)
	
	self.ButtonDelete.DoClick = function(pnl)
		if self.unsubscribed then
			self.unsubscribed = nil
			pnl:SetText("#addon.unsubscribe")
			
			steamworks.Subscribe(self.addon_info.wsid)
			steamworks.ApplyAddons()
		else
			self.unsubscribed = true
			pnl:SetText("#addon.subscribe")
			
			steamworks.Unsubscribe(self.addon_info.wsid)
		end
	end
end

function PANEL:GetInfo()
	return self.addon_info
end

function PANEL:SetInfo(info)
	--[[
	info:
		downloaded	=	bool
		models		=	number
		title		=	string
		file		=	string
		mounted		=	bool
		wsid		=	string
	]]
	
	self.addon_info = info
	
	if not info.mounted then
		self.Thumbnail:SetImageColor(Color(255, 255, 255, 200))
	end
	
	self.Title:SetText(info.title)
	self.Title:SizeToContents()
	
	self.ButtonEnable:SetText(info.mounted and "#addon.disable" or "#addon.enable")
	self.ButtonDelete:SetText("#addon.unsubscribe")
	
	self:FetchPreviewImage()
end

function PANEL:SetThumbnailImage(img_src) -- internal
	local mat = AddonMaterial(img_src)
	
	if not mat then return end
	
	self.Thumbnail:SetMaterial(mat)
	self.Thumbnail:FixVertexLitMaterial()
end

local next_time = 0
local delay
local isfirst = true

-- this is much better than freezing game
function PANEL:QueueThumbnailImage(img_src) -- internal
	if isfirst then
		isfirst = false
		
		local time = SysTime()
		self:SetThumbnailImage(img_src)
		
		delay = SysTime() - time + 0.005
		
		return
	end
	
	timer.Simple(next_time, function()
		if self:IsValid() then
			self:SetThumbnailImage(img_src)
		end
	end)
	
	next_time = next_time + delay
end

function PANEL:FetchPreviewID(callback) -- internal
	local info = self.addon_info
	
	local cached = Cache_PreviewID[info.wsid]
	
	if cached then
		if isfunction(cached) then -- in progress
			Cache_PreviewID[info.wsid] = callback
			return
		end
		
		return callback(self, cached)
	end
	
	Cache_PreviewID[info.wsid] = callback
	
	steamworks.FileInfo(info.wsid, function(result)
		if not result then return end
		
		Cache_PreviewID[info.wsid] = result.previewid
		
		callback(self, result.previewid)
	end)
end

function PANEL:DownloadPreviewImage(previewid) -- internal
	if not self:IsValid() then return end
	
	local cached = Cache_PreviewImage[previewid]
	
	if cached then
		if ispanel(cached) then -- in progress
			Cache_PreviewImage[previewid] = self
			return
		end
		
		self:SetThumbnailImage(cached)
		return
	end
	
	Cache_PreviewImage[previewid] = self
	
	steamworks.Download(previewid, false, function(img_src)
		if not self:IsValid() then return end
		if not img_src then return end
		
		Cache_PreviewImage[previewid] = img_src
		
		self:QueueThumbnailImage(img_src)
	end)
end

function PANEL:FetchPreviewImage() -- internal
	return self:FetchPreviewID(self.DownloadPreviewImage)
end

function PANEL:Paint(w, h)
	local info = self.addon_info
	
	draw.RoundedBox(4, 0, 0, w, h, self.unsubscribed and col_inactive or
		(info.mounted and col_default or col_disabled))
end

vgui.Register("AddonItem", PANEL, "Panel")
