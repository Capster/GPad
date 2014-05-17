function GPad:GetFrame()
	GPad.Panel = Metro.Create("GPadIDE")
	GPad.Panel:SetVisible(false)
	return GPad.Panel
end

concommand.Add ("gpad_show",function ()
	GPad:GetFrame():SetVisible (true)
end)