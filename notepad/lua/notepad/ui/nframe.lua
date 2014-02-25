local PANEL = {}

function PANEL:Init ()
	-- Size Control
	self.btnMaxim:SetDisabled (false)
	self.btnMaxim.DoClick = function ()
		if self:IsMaximized () then
			self:Restore ()
		else
			self:Maximize ()
		end
	end
	
	self.Maximizable = true
	self.Maximized = false
	
	self.Sizable = true
	
	self.RestoredX = 0
	self.RestoredY = 0
	self.RestoredWidth = 0
	self.RestoredHeight = 0
	
	//self.ResizeGrip = vgui.Create ("DResizeGrip", self)
	//self.ResizeGrip:SetSize (16, 16)
	-- Double Clicks
	self.LastLeftMouseButtonReleaseTime = 0
end

-- Based off SKIN:PaintFrame () in skins/default.lua
function PANEL:Paint (w, h)
	if self.m_bPaintShadow then
		surface.DisableClipping (true)
		self:GetSkin ().tex.Shadow (-4, -4, w + 10, h + 10)
		surface.DisableClipping (false)
	end
	
	if self:IsActive () then
		self:GetSkin ().tex.Window.Normal (0, 0, w, h)
	else
		self:GetSkin ().tex.Window.Inactive (0, 0, w, h)
	end
end

function PANEL:IsActive ()
	return true
end

-- Size Control
function PANEL:IsMaximized ()
	return self.Maximized
end

function PANEL:IsSizable ()
	return self.Sizable
end

function PANEL:Think()
	DFrame.Think (self)
	local _,h = self:GetPos()
	if not( h <= 3 ) then
		self:Restore()
	end
end

function PANEL:OnMouseReleased()

	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture( false )
	local _,h = self:GetPos()
	if h <= 3 then
		self:Maximize()
	end
end

function PANEL:Maximize ()
	if self:IsMaximized () then return end
	
	self.Maximized = true
	
	-- Based off SKIN:PaintWindowMaximizeButton
	self.btnMaxim.Paint = function (panel, w, h)
		if not panel.m_bBackground then return end
		
		if panel:GetDisabled () then
			return panel:GetSkin ().tex.Window.Restore (0, 0, w, h, Color (255, 255, 255, 50))
		end	
		
		if panel.Depressed or panel:IsSelected () then
			return panel:GetSkin ().tex.Window.Restore_Down (0, 0, w, h)
		end	
		
		if panel.Hovered then
			return panel:GetSkin ().tex.Window.Restore_Hover (0, 0, w, h)
		end
		
		panel:GetSkin ().tex.Window.Restore (0, 0, w, h)
	end
	
	//self.ResizeGrip:SetVisible (false)
	
	self.RestoredX, self.RestoredY = self:GetPos ()
	self.RestoredWidth = self:GetWide ()
	self.RestoredHeight = self:GetTall ()
	
	self:SetPos (0, 0)
	self:SetSize (self:GetParent ():GetSize ())

end

function PANEL:Restore ()
	if not self:IsMaximized () then return end
	
	self.Maximized = false
	self.btnMaxim.Paint = function (panel, w, h)
		derma.SkinHook ("Paint", "WindowMaximizeButton", panel, w, h)
	end
	
	//self.ResizeGrip:SetVisible (self:IsSizable ())
	
	self:SetPos (self.RestoredX, self.RestoredY)
	self:SetSize (self.RestoredWidth, self.RestoredHeight)
	
end

function PANEL:SetMaximizable (maximizable)
	if self.Maximizable == maximizable then return end
	
	self.Maximizable = maximizable
	self.btnMaxim:SetDisabled (not self.Maximizable)
	
end

function PANEL:SetSizable (sizable)
	self.Sizable = sizable
	
	DFrame.SetSizable (self, sizable)
	//self.ResizeGrip:SetVisible (sizable)
end

-- Event handlers
//Gooey.CreateMouseEvents (PANEL)

function PANEL:OnKeyCodePressed (keyCode)
//	return self:DispatchKeyboardAction (keyCode)
end
PANEL.OnKeyCodeTyped = PANEL.OnKeyCodePressed

vgui.Register ("NFrame", PANEL, "DFrame")