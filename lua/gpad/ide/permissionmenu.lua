function GPad:GetPermissionMenu()
	if ValidPanel(GPad.PermissionMenu) then
		GPad.PermissionMenu:Remove()
	end
	GPad.PermissionMenu = Metro.Create("GPadPermissonMenu")
	GPad.PermissionMenu:SetVisible(false)
	return GPad.PermissionMenu
end

concommand.Add ("gpad_showpm",function ()
	GPad:GetPermissionMenu():SetVisible(true)
end)