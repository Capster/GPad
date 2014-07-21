local PANEL = {}

function PANEL:Init ()
	
	self.Driver = Metro.Create( "DVerticalDivider", self )
	self.Driver:Dock(FILL)

	self[1] = Metro.Create("GPadPropertySheet")
	self.ControlPanel = Metro.Create("GPadPropertySheetDown")
	
	self.Driver:SetTop( self[1] )
	self.Driver:SetBottom( self.ControlPanel )
	self.Driver:SetCookieName("container_driver")
	local TopHeight = self.Driver:GetCookie("TopHeight")
	self.Driver:SetTopHeight(tonumber(TopHeight) or 750)
	self.Docks = {}

	local file = GPad.FileTypes:GetType("Debug")
	local dock = file:Init()
	
	self.ControlPanel:AddSheet( "Debug", dock, file.Icon, false, false )
	
	local file = GPad.FileTypes:GetType("Output")
	local dock = file:Init()
	
	self.ControlPanel:AddSheet( "Output", dock, file.Icon, false, false )
	
	local tbl = GPad:LoadSession()
	if #tbl == 0 then self:AddTab("Code", "New", content, 1) end
	for k,v in pairs(tbl) do
		self:AddTab(v.Type, v.Name, v.Content, 1)
	end
end

function PANEL:New()
	local panelNew = self:AddTab("Code", "New", content, 1)
	return panelNew
end


function PANEL:AddTab(strType, strName, Content, enumOrientation)
	local file = GPad.FileTypes:GetType(strType)
	local dock = file:Init(Content)
	
	dock.TypeX = strType
	dock.Orientation = enumOrientation
	
	GPad.Docks[dock] = {Type = strType, Name = strName, Content = Content}
	
	self.Docks[#self.Docks+1] = dock
	
	self[enumOrientation]:AddSheet( strName, dock, file.Icon, false, false )
	
	return dock
end

Metro.Register("GPadDockContainer", PANEL, "DPanel")