local PANEL = {}

fastlua.Bind(PANEL, "Text", "Done")

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(105, 32, 122))
	draw.SimpleText(self.Text, "MetroSmall", 10, h/2, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black )
end


function PANEL:PerformLayout ()

end

Metro.Register("GPadStatusBar", PANEL, "DPanel")