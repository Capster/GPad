GPad.Docks = {}

function GPad:GetFrame()
	GPad.Panel = Metro.Create("GPadIDE")
	GPad.Panel:SetVisible(false)
	return GPad.Panel
end

concommand.Add ("gpad_show",function ()
	GPad:GetFrame():SetVisible (true)
end)

function GPad:SaveSession()
	local tblDump = table.ClearKeys(GPad.Docks)
	luadata.WriteFile("gpad_workspace.txt", tblDump)
end

function GPad:LoadSession()
	GPad.PrintTable(luadata.ReadFile("gpad_workspace.txt"))
	return luadata.ReadFile("gpad_workspace.txt")
end

timer.Create("GPad.AutoSave", 5, 0, function()
	GPad:SaveSession()
end)