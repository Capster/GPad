GPad.VFTP.Color = Color(0xFF, 0xA2, 0xA2)	

function GPad.VFTP.Print(...)
	MsgC(GPad.VFTP.Color, "[VFTP] ") print(...)
end

function GPad.VFTP.Debug(...)
	if GPad.DEVMODE then
		GPad.VFTP.Print(...)
	end
end

function GPad.VFTP.Error(...)
	MsgC(GPad.VFTP.Color, "[VFTP] ") MsgC(Color(0xFF,0,0), ...) print""
end

function GPad.VFTP.Panic(err)
	for k,v in pairs(player.GetAll()) do
		GPad.VFTP.Session:End(v, "Kernel panic: "..err)
	end
	GPad.VFTP.Error("Kernel panic: "..err)
end