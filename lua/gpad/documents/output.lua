local self = {}

self.Name = "Output"
self.Icon = "icon16/application_xp_terminal.png"

function self:Init()
	local output = Metro.Create("MetroListView")
	local Col1 = output:AddColumn( "Type" )
	local Col2 = output:AddColumn( "Information" )
	local Col3 = output:AddColumn( "Error Code" )
	
	Col1:SetMinWidth( 90 )
	Col1:SetMaxWidth( 90 )
	
	Col3:SetMinWidth( 100 )
	Col3:SetMaxWidth( 100 )
--[[
	for i = 0,5 do
		output:AddLine( "Error", "Unknown Error", "Errorcode: "..i.."." ):SetIcon("icon16/cancel.png")
	end
	for i = 0,5 do
		output:AddLine( "Warning", "Unknown Warning", "Errorcode: "..i.."." ):SetIcon("icon16/error.png")
	end
]]
	output:Dock(FILL)
	return output
end

GPad.FileTypes:CreateType(self.Name, self)