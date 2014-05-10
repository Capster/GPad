function GPad.CreateToolbar(panelParent)
	local Toolbar = Metro.Create("DPanelList", panelParent)
	Toolbar:Dock(TOP)
	Toolbar:SetSpacing(5)
	Toolbar:EnableHorizontal(true)
	Toolbar:EnableVerticalScrollbar(false)
	Toolbar.PerformLayout = function(self) 
		local Wide = self:GetWide()
		local YPos = 3
		
		if(!self.Rebuild) then debug.Trace() end 
		
		self:Rebuild()
		
		if(self.VBar && !m_bSizeToContents) then 
			self.VBar:SetPos(self:GetWide() - 16, 0)
			self.VBar:SetSize(16, self:GetTall())
			self.VBar:SetUp(self:GetTall(), self.pnlCanvas:GetTall())
			YPos = self.VBar:GetOffset() + 3
			if(self.VBar.Enabled) then Wide = Wide - 16 end 
		end 
	   
		self.pnlCanvas:SetPos(3, YPos)
		self.pnlCanvas:SetWide(Wide)
		
		self:Rebuild()
		
		if(self:GetAutoSize()) then 
			self:SetTall(self.pnlCanvas:GetTall())
			self.pnlCanvas:SetPos(3, 3)
		end
	end
	return Toolbar
end

function GPad.AddToolbarItem(strTolltip, strMaterial, funcCallback, activeCallback)
	local button = Metro.Create("MetroImageButton")
	button:SetImage(strMaterial)
	button:SetTooltip(strTolltip)
	button:SetSize(16, 16)
	button.activeCallback = activeCallback
	button.DoClick = funcCallback

	GPad.Toolbar:AddItem(button)
end

function GPad.AddToolbarDropItem(strTolltip, strMaterial, funcCallback, activeCallback, functionRightCallback)
	local button = Metro.Create("MetroImageButtonDrop")
	button:SetImage(strMaterial)
	button:SetTooltip(strTolltip)
	button:SetSize(16, 16)
	button.activeCallback = activeCallback
	button.functionRightCallback = functionRightCallback
	button.DoClick = funcCallback

	GPad.Toolbar:AddItem(button)
end

function GPad.AddToolbarSpacer()
	local lab = Metro.Create("MetroLabel")
	lab:SetText(" | ")
	lab:SizeToContents()

	GPad.Toolbar:AddItem(lab)
end