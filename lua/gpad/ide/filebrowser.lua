
function GPad:GetFileBrowser()
	GPad.FileBrowser = Metro.Create("GPadFileBrowser")
	GPad.FileBrowser:SetVisible(false)
	return GPad.FileBrowser
end

concommand.Add ("gpad_showfb",function ()
	GPad:GetFileBrowser():SetVisible(true)
end)