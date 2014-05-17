local PANEL = {}

function PANEL:Init ()
	
	self.Driver = Metro.Create( "DVerticalDivider", self )
	self.Driver:Dock(FILL)

	self[GPad.Orientation.Top] = Metro.Create("GPadPropertySheet")
	self[GPad.Orientation.Bottom] = Metro.Create("GPadPropertySheet")
	
	self.Driver:SetTop( self[GPad.Orientation.Top] )
	self.Driver:SetBottom( self[GPad.Orientation.Bottom] )
	self.Driver:SetCookieName("container_driver")
	local TopHeight = self.Driver:GetCookie("TopHeight")
	self.Driver:SetTopHeight(tonumber(TopHeight) or 750)
	local old_hook = self.Driver.OnCursorMoved
	self.Driver.OnCursorMoved = function(...)
		old_hook(...)
		--self:SetCookie("TopHeight", self:GetTopHeight())
	end
	self.Docks = {}
	GPad.Debug = self:AddTab("Debug", "Debug", content, GPad.Orientation.Bottom)
	GPad.Output = self:AddTab("Output", "Output", content, GPad.Orientation.Bottom)
	self:AddTab("Code", "New", content, GPad.Orientation.Top)
	self:AddTab("Image", "error.png", content, GPad.Orientation.Top)
	self:AddTab("Image", "error.png", content, GPad.Orientation.Top)
	self:AddTab("HTMLPage", "Google", content, GPad.Orientation.Top)
	self:AddTab("PolyEditor", "New Poly", content, GPad.Orientation.Top)
	
	self:AddTab("Code", "New", content, GPad.Orientation.Top)
	--self.Debug:SetupAdder()
	self:AddTab("Code", "New", content, GPad.Orientation.Top)
end

function PANEL:AddTab(strType, strnName, content, enumOrientation)
	local file = GPad.FileTypes:GetType(strType)
	local dock = file:Init()
	dock.TypeX = strType
	dock.Orientation = enumOrientation
	if dock.SetContent then
		dock:SetContent(content)
	end
	
	self.Docks[#self.Docks+1] = dock
	self[enumOrientation]:AddSheet( strnName, dock, file.Icon, false, false )
	
	return dock
end

Metro.Register("GPadDockContainer", PANEL, "DPanel")