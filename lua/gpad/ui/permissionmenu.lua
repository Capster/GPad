local PANEL = {}


function PANEL:Init ()
	xpcall (function ()
		self:SetTitle("GPad Permission Editor")
		self:SetSize(ScrW() * 0.3, ScrH() * 0.6)
		self:Center()
		self:SetDraggable(true)
		self:SetDeleteOnClose(false)
		self:SetVisible(false)
		self:SetSizable(true)
		self:MakePopup()
		
	end, ErrorNoHalt)
end

Metro.Register("GPadPermissonMenu", PANEL, "MetroFrame")