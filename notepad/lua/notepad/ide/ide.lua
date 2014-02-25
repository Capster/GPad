Notepad = {}
Msg"[Notepad] " print"loading"

function Notepad:GetFrame ()
	if not Notepad.Panel then
		Notepad.Panel = vgui.Create ("NotepadFrame")
		Notepad.Panel:SetNotepad(self)
		Notepad.Panel:LoadWorkspace ()
	end
	return Notepad.Panel
end

function draw.OutlinedRect(bordh, x, y, w, h,color)
	surface.SetDrawColor(color)
	surface.DrawRect( x, y, w, bordh )
	surface.DrawRect( x, y+bordh, bordh, h )
	surface.DrawRect( x+w, y, bordh, h )
	surface.DrawRect( x+bordh, y+h, w, bordh )
end


function Notepad:Paint()
	if Notepad.Panel then
		local _,h = Notepad.Panel:GetPos()
		if h <= 0 and not Notepad.Panel:IsMaximized() then
			draw.OutlinedRect(5, 0, 0, ScrW()-5, ScrH()-5, Color(0,0,0xFF,0x3E))
		end
	end
end

function Notepad:Hide()
	Notepad.GetFrame():Hide()
end

hook.Add("HUDPaint", "NotepadPaint", Notepad.Paint)

concommand.Add ("notepad",
	function()
		Notepad.GetFrame():SetVisible (true)
	end
)

concommand.Add ("notepad_reload",
	function()
		Notepad.GetFrame():Reload()
	end
)