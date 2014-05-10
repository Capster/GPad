local self = {}

self.Name = "Code"
self.Icon = "icon16/page_red.png"

function self:Init()
	local code = Metro.Create("GPadEditor")
	code:Dock(FILL)
	return code
end


GPad.FileTypes:CreateType(self.Name, self)