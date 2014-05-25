local self = {}

self.Name = "PolyEditor"
self.Icon = "gpad/document_graph.png"

function self:Init()
	local editor = Metro.Create("GPadMetroEditor")
	--editor:SetText("Poly Editor (INDEV, not working)")
	editor:Dock(FILL)
	return editor
end

GPad.FileTypes:CreateType(self.Name, self)