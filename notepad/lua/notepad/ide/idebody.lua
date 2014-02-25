local PANEL = {}


function PANEL:Init ()
	xpcall (function ()
	self:SetTitle ("Notepad++")
	self:SetSize (ScrW () * 0.85, ScrH () * 0.85)
	self:Center ()
	self:SetDeleteOnClose (false)
	self:MakePopup ()
	
	self.UpMenu = Notepad.UpMenu (self)
	
	self.Editor = vgui.Create("lua_editor",self)
	Notepad.code = self.Editor
	end, ErrorNoHalt)
end

function PANEL:PerformLayout ()
	DFrame.PerformLayout (self)
	local y = 21
	if self.UpMenu then
		self.UpMenu:SetPos (2, y)
		self.UpMenu:SetWide (self:GetWide () - 4)
		y = y + self.UpMenu:GetTall ()
	end
	if self.Editor then
		self.Editor:Dock(FILL)
	end
end

function PANEL:SetNotepad(notepad)
	return true
end

function PANEL:LoadWorkspace()
	return true
end

function PANEL:Reload()
	self:Remove()
	Notepad.Panel = nil
	Notepad.GetFrame():SetVisible (true)
end

vgui.Register ("NotepadFrame", PANEL, "NFrame")