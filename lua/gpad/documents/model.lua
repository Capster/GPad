local self = {}

self.Name = "Model"
self.Icon = "gpad/document_web.png"

function self:Init(model)
	local panelModel = Metro.Create("GPadModelPanel")
	panelModel:Dock(FILL)
	panelModel:SetModel(model)
	return panelModel
end

GPad.FileTypes:CreateType(self.Name, self)