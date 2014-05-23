local self = {}

self.Name = "Debug"
self.Icon = "icon16/tag_pink.png"
-- editor.setReadOnly(true)
function self:Init()
	local debug = Metro.Create("RichText")
	debug:InsertColorChange(0,0,0,255)
	debug:Dock(FILL)
	function debug:WriteColorLine(strLine, colorStringColor)
		--self:InsertColorChange(unpack(colorStringColor))
		self:AppendText(strLine or "ERROR: INVALID STRING IN GPack.Std:WriteColorLine")
		self:InsertColorChange(0,0,0,255)
	end
	
	debug.WriteLine = function(panel, strLine)
		panel:AppendText(strLine or "ERROR: INVALID STRING IN GPack.Std:WriteColorLine \n")
	end

	function GPad:GetStd() -- GPad:GetStd():WriteLine("test")
		return debug
	end

	function GPad:SetStd(panelStd)
		debug = panelStd -- For epoe overrid
	end
	return debug
end

GPad.FileTypes:CreateType(self.Name, self)
