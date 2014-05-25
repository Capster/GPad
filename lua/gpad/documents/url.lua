local self = {}

self.Name = "HTMLPage"
self.Icon = "gpad/document_web.png"

function self:Init()
	local html = Metro.Create("MetroHTML")
	html:Dock(FILL)
	html.m_bScrollbars = false
	html:OpenURL("www.google.com")
	return html
end

GPad.FileTypes:CreateType(self.Name, self)