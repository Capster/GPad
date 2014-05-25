local self = {}

self.Name = "Image"
self.Icon = "gpad/document_image.png"

function self:Init()
	local img = Metro.Create("MetroHTML")
	img:Dock(FILL)
	return img
end

GPad.FileTypes:CreateType(self.Name, self)