local PANEL = {}

fastlua.Bind(PANEL, "Folder", "")
fastlua.Bind(PANEL, "Side", "")

function PANEL:Init ()
	xpcall (function ()
		self:SetSize(ScrW() * 0.3, ScrH() * 0.6)
		self:Center()
		self:SetDraggable(true)
		self:SetDeleteOnClose(false)
		self:SetVisible(false)
		self:MakePopup()
		
	end, ErrorNoHalt)
end

function PANEL:Think()
	self:SetTitle("GPad Permission Editor: "..self.Side)
	Metro.Frame.Think(self)
end

Metro.Register("GPadPermissonMenu", PANEL, "MetroFrame")