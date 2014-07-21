local loadpath = "gpad_session.txt"

local orientation = {
	Top    = 1,
	Bottom = 2,
}

function GPad:LoadWorkspace()
	local content = file.Read(loadpath, "DATA")
	content = glon.decode(content)
	for k, v in pairs(content) do
		GPad.Container:AddTab(v[1], "New", v[2] or nil, v[3] or orientation.Top)
	end
	--GPad.PrintTable(content)
	--GPad.PrintDebug(nil, "Loading workspace...")
end

function GPad:SaveWorkspace()
	local CONTENT = {}
	for k,v in pairs(GPad.Container.Docks) do
		if not v.TypeX == "Debug" or not v.TypeX == "Output" then
			--PrintTable({v.TypeX, v.GetContent and v:GetContent() or nil})
			table.insert(CONTENT, {
				v.TypeX,
				v.GetContent and v:GetContent() or nil,
				v.Orientation or orientation.Top
			})
		end
	end
	
	CONTENT = glon.encode(CONTENT)
	file.Write(loadpath, CONTENT)
	--GPad.PrintDebug(nil, "Saving workspace...")
end

timer.Create("GPad.UpdateTick", 3, 0, function() 
	if GPad and ValidPanel(GPad.Panel) then
		GPad:SaveWorkspace()
	end
end)
