local self = {}

self.Name = "Image"
self.Icon = "icon16/image.png"

function self:Init()
	local img = Metro.Create("MetroHTML")
	img:Dock(FILL)
	return img
end

GPad.FileTypes:CreateType(self.Name, self)