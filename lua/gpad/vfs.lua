function GPad.VFS.Debug(...)
	if GPad.DEVMODE then
		Msg"[VFS] " print(...)
	end
end

function GPad.VFS.Error(...)
	Msg"[VFS] " MsgC(Color(0xFF,0,0), ...) print""
end



