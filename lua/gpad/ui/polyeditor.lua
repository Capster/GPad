PANEL = {}

function PANEL:Init()
	self.SnapTo = 20
	self.SnapPoints = {1, 2, 5, 10, 20, 50, 100}

	self.PolygonData = {{}}
	self.CurrentPoly = 1
	
	self:SetCursor("blank")
end
function PANEL:PaintOver(w,h)
		
	for k,poly in ipairs(self.PolygonData)do
			surface.SetTextColor(100,100,100,255)
			for k1,point in ipairs(poly)do
				surface.SetTextPos(point.x-35, point.y-50)
				surface.SetFont("MetroSmall")
				surface.DrawText("x: "..point.x.."; y: "..point.y)
				draw.RoundedBox(4, point.x-2, point.y-2, 5, 5, Color(0, 120, 205, 255))
			end
			
			local polygoncopy = {}
			table.CopyFromTo(poly or {}, polygoncopy)
			if k == self.CurrentPoly then
				table.insert(polygoncopy, {x=math.RoundToNearest(self:ScreenToLocal(gui.MouseX()), self.SnapTo), y=math.RoundToNearest(self:ScreenToLocal(gui.MouseY()-15), self.SnapTo)})
			end
			draw.NoTexture()
			surface.SetDrawColor(0, 120, 205,180)
			surface.DrawPoly(polygoncopy)			
	end
	
	draw.RoundedBox(4, math.RoundToNearest(self:ScreenToLocal(gui.MouseX()), self.SnapTo)-2, math.RoundToNearest(self:ScreenToLocal(gui.MouseY()-15), self.SnapTo)-2, 5, 5, Color(105, 32, 122))
	
	surface.SetTextColor(100,100,100,255)
	surface.SetFont("MetroSmall")
	surface.SetTextPos(10, 20)
	surface.DrawText("x: "..math.RoundToNearest(self:ScreenToLocal(gui.MouseX()), self.SnapTo).."; y: "..math.RoundToNearest(self:ScreenToLocal(gui.MouseY()-15), self.SnapTo))
	surface.SetTextPos(10, 35)
	surface.DrawText("Current Poly: "..#self.PolygonData[self.CurrentPoly])
	surface.SetTextPos(10, 50)
	surface.DrawText("All Polygons: "..#self.PolygonData)
end

function PANEL:Paint(w,h)
	draw.NoTexture()
	surface.SetDrawColor(240, 240, 240, 255)
	surface.DrawRect(0,0,w,h)
	
	surface.SetDrawColor(100,100,100,150)
	for i=self.SnapTo, ScrW(), self.SnapTo do
		surface.DrawLine(i, 0, i, ScrH())
		surface.DrawLine(0, i, ScrW(), i)
	end
end
function PANEL:OnMousePressed(mc)
	if mc == MOUSE_LEFT then
		table.insert(self.PolygonData[self.CurrentPoly], {x=math.RoundToNearest(self:ScreenToLocal(gui.MouseX()), self.SnapTo), y=math.RoundToNearest(self:ScreenToLocal(gui.MouseY()-15), self.SnapTo)})
		
	elseif mc == MOUSE_RIGHT then
		local menu = DermaMenu()
			menu:AddOption("Export", function()
				self:Export()
			end):SetIcon("icon16/application_go.png")
			menu:AddOption("Copy To Clipboard", function()
				self:CopyToClipboard()
			end):SetIcon("icon16/page_copy.png")	
			menu:AddSpacer()
			menu:AddOption("Add Polygon", function()
				self.CurrentPoly = self.CurrentPoly + 1
				self.PolygonData[self.CurrentPoly] = {}
			end):SetIcon("icon16/shape_square_add.png")
			menu:AddOption("Clear", function()
				self.PolygonData[self.CurrentPoly] = {}
			end):SetIcon("icon16/note_delete.png")
			menu:AddOption("Clear All", function()
				self.PolygonData = {{}}
				self.CurrentPoly = 1
			end):SetIcon("icon16/bin_closed.png")
			menu:AddSpacer()
			local snap, m = menu:AddSubMenu("Snap To...")
			m:SetIcon("icon16/zoom.png")
			for k,v in pairs(self.SnapPoints)do
				snap:AddOption(v, function()
					self.SnapTo = v
				end)
			end
			menu:AddSpacer()
			menu:AddOption("Cancel", function() end):SetIcon("icon16/cross.png")
			menu:Open()
	elseif mc == MOUSE_MIDDLE then
		self:SetCursor("sizeall") -- ToDo: Free Snap
	end
end

function PANEL:OnMouseReleased(mc)
	if mc == MOUSE_MIDDLE then
		self:SetCursor("arrow")
	end
end

function PANEL:Export()
	MsgC(Color(255,255,200), self:Compile())
	RunConsoleCommand("showconsole")
end

function PANEL:Compile()
	local rtrn = "local polydata = {}"
	for key,poly in ipairs(self.PolygonData) do
		rtrn = rtrn..[[

	polydata[]]..key..[[] = {}]]
		for key2,point in ipairs(poly)do
			rtrn = rtrn..[[

		polydata[]]..key..[[][]]..key2..[[] = { x = ]]..point.x..[[, y = ]]..point.y..[[ }]]
		end
	end
	return rtrn.." --Put all this stuff OUTSIDE your paint hook.\n\ntable.foreachi(polydata, function(k,v) surface.DrawPoly(v) end) --Put this in your paint hook."
end

function PANEL:CopyToClipboard()
	GPad:PrintDebug("Copied to Clipboard")
	SetClipboardText(self:Compile())
end

Metro.Register("GPadMetroEditor", PANEL, "DPanel")