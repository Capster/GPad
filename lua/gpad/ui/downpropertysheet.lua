local PANEL = {}

fastlua.Bind(PANEL, "PropertySheet")
fastlua.Bind(PANEL, "Panel")

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetContentAlignment(7)
	self:SetTextInset(0, 4)	
	self:SetFont("MetroSmall")
end

function PANEL:Setup( label, pPropertySheet, pPanel, strMaterial )
	self:SetText(label)
	self:SetPropertySheet(pPropertySheet)
	self:SetPanel(pPanel)
end

function PANEL:IsActive()
	return self:GetPropertySheet():GetActiveTab() == self
end

function PANEL:DoClick()
	self:GetPropertySheet():SetActiveTab(self)
end

function PANEL:PerformLayout()
	self:ApplySchemeSettings()
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240))
end

function PANEL:ApplySchemeSettings()
	local ExtraInset = 20
	
	
	local Active = self:GetPropertySheet():GetActiveTab() == self
	
	self:SetTextInset(ExtraInset, 4)
	local w, h = self:GetContentSize()
	h = 28

	if not Active then h = 24 end
	
	self:SetSize( w + 12, h )
		
	DLabel.ApplySchemeSettings(self)	
end

function PANEL:DragHoverClick(HoverTime)

	self:DoClick()

end

Metro.Register("GPadTabDown", PANEL, "MetroButton")


local PANEL = {}

fastlua.Bind(PANEL, "ActiveTab")
fastlua.Bind(PANEL, "Padding")

function PANEL:Init()
	self.tabScroller = Metro.Create( "DHorizontalScroller", self )
	self.tabScroller:SetOverlap( 5 )
	self.tabScroller:Dock( BOTTOM )

	self.Bar = Metro.Create( "DPanel", self )
	self.Bar:Dock( TOP )
	self.Bar.Paint = function(panel, w, h)
		surface.SetFont("MetroSmall")
		local text = "Debug"
		local text_w = surface.GetTextSize(text) + 15
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 120, 205))
		draw.SimpleText(text, "MetroSmall", 5, h * 0.5, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black )
		surface.DrawVSDotHorizontal(text_w, h * 0.5, w - text_w - 20, Color(89, 168, 222))
		return true
	end
	
	self:SetPadding( 8 )
	
	self.Items = {}
end

function PANEL:Paint(w, h)
	local ActiveTab = self:GetActiveTab()
	local Offset = 0
	if ActiveTab then Offset = ActiveTab:GetTall()-8 end
	--draw.RoundedBox(0, 0, Offset, w, h-Offset, Metro.Colors.TabsBorder)
	draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240))
	--draw.RoundedBox(0, 0, Offset+4, w, h-Offset-2, Color(7, 104, 175))
	
end

function PANEL:AddSheet( label, panel, material, NoStretchX, NoStretchY, Tooltip )

	if not IsValid( panel ) then return end
	
	if ValidPanel(self.AdderButton) then
		self.AdderButton:Remove()
	end
	
	local Sheet = {}
	
	Sheet.Name = label

	Sheet.Tab = Metro.Create( "GPadTabDown", self )
	Sheet.Tab:SetTooltip( Tooltip )
	Sheet.Tab:Setup( label, self, panel, material )
	
	Sheet.Panel = panel
	Sheet.Panel.NoStretchX = NoStretchX
	Sheet.Panel.NoStretchY = NoStretchY
	Sheet.Panel:SetPos( self:GetPadding(), 20 + self:GetPadding() )
	Sheet.Panel:SetVisible( false )
	
	panel:SetParent( self )
	
	table.insert( self.Items, Sheet )
	
	self:SetActiveTab( Sheet.Tab )
	Sheet.Panel:SetVisible( true )
	
	self.tabScroller:AddPanel( Sheet.Tab )
	
	return Sheet

end

function PANEL:SetActiveTab( active )

	if self.m_pActiveTab == active then return end
	
	if self.m_pActiveTab then
			self.m_pActiveTab:GetPanel():SetVisible( false )
	end
	GPad.ActivePanel = active:GetPanel()
	hook.Run("GPad.DownTabChanged")
	self.m_pActiveTab = active
	self:InvalidateLayout()

end

function PANEL:CrossFade( anim, delta, data )
	
	local old = data.OldTab:GetPanel()
	local new = data.NewTab:GetPanel()
	
	if anim.Finished then
	
		old:SetVisible( false )
		new:SetAlpha( 255 )
		
		old:SetZPos( 0 )
		new:SetZPos( 0 )
		
	return end
	
	if anim.Started then
	
		old:SetZPos( 0 )
		new:SetZPos( 1 )
		
		old:SetAlpha( 255 )
		new:SetAlpha( 0 )
		
	end
	
	old:SetVisible( true )
	new:SetVisible( true )
		
	new:SetAlpha( 255 * delta )

end

function PANEL:PerformLayout()

	local ActiveTab = self:GetActiveTab()
	local Padding = self:GetPadding()
	
	if not ActiveTab then return end
	
	ActiveTab:InvalidateLayout( true )
	
	self.tabScroller:SetTall( ActiveTab:GetTall() )
	
	
	
	local ActivePanel = ActiveTab:GetPanel()
		
	for k, v in pairs( self.Items ) do
	
		if v.Tab:GetPanel() == ActivePanel then
		
			v.Tab:GetPanel():SetVisible( true )
			v.Tab:SetZPos( 100 )
		
		else
		
			v.Tab:GetPanel():SetVisible( false )	
			v.Tab:SetZPos( 1 )
		
		end
	
		v.Tab:ApplySchemeSettings()
			
	
	end
	
	if not ActivePanel.NoStretchX then 
		ActivePanel:SetWide( self:GetWide() - Padding * 2 ) 
	else
		ActivePanel:CenterHorizontal()
	end
	
	if not ActivePanel.NoStretchY then 
		ActivePanel:SetTall( (self:GetTall() - ActiveTab:GetTall() ) - Padding ) 
	else
		ActivePanel:CenterVertical()
	end
	
	
	ActivePanel:InvalidateLayout()
	
end

function PANEL:SizeToContentWidth()
	local wide = 0
	for k, v in pairs( self.Items ) do
		if v.Panel then
			v.Panel:InvalidateLayout( true )
			wide = math.max( wide, v.Panel:GetWide()  + self.m_iPadding * 2 )
		end
	end
	self:SetWide( wide )
end

function PANEL:SwitchToName( name )
	for k, v in pairs( self.Items ) do
		if v.Name == name then
			v.Tab:DoClick()
			return true
		end	
	end
	
	return false
end

Metro.Register( "GPadPropertySheetDown", PANEL, "Panel" )