local self = {}

self.Name = "Code"
self.Icon = "gpad/document_lua.png"

function self:Init(strCode)
	local code = Metro.Create("GPadEditor")
	code:Dock(FILL)
	code:SetCode(strCode or "")
	return code
end

function self:GetContent(panelPage)
	return panelPage:GetCode()
end


GPad.FileTypes:CreateType(self.Name, self)