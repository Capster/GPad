local loadpath = "gpad_session.txt"

function GPad:LoadWorkspace()
	local content = file.Read(loadpath, "DATA")
	content = glon.decode(content)
	for k, v in pairs(content) do
		GPad.Container:AddTab(v[1], "New", v[2] or nil, v[3] or GPad.Orientation.Top)
	end
	--GPad.PrintTable(content)
	GPad.PrintDebug("Loading workspace...")
end

function GPad:SaveWorkspace()
	local CONTENT = {}
	for k,v in pairs(GPad.Container.Docks) do
		if not v.TypeX == "Debug" or not v.TypeX == "Output" then
			--PrintTable({v.TypeX, v.GetContent and v:GetContent() or nil})
			table.insert(CONTENT, {
				v.TypeX,
				v.GetContent and v:GetContent() or nil,
				v.Orientation or GPad.Orientation.Top
			})
		end
	end
	
	CONTENT = glon.encode(CONTENT)
	file.Write(loadpath, CONTENT)
	--GPad.PrintDebug("Saving workspace...")
end

timer.Create("GPad.UpdateTick", 3, 0, function() 
	if GPad and ValidPanel(GPad.Panel) then
		GPad:SaveWorkspace()
	end
end)