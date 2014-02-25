local base_path = "notepad/"

function addcsinclude(path)
	if SERVER then
		AddCSLuaFile(base_path..path)
	else
		include(base_path..path)
	end
end

addcsinclude("colors.lua")
addcsinclude("backup.lua")

addcsinclude("ide/ide.lua")
addcsinclude("ide/idebody.lua")
addcsinclude("ide/up_menu.lua")

addcsinclude("ui/nframe.lua")
addcsinclude("ui/lua_editor.lua")