GPad.GLua = {}

function GPad.GLua:SessionStart(strCode)
	local code = ""
	code = code .. "local ErrorNoHalt = ErrorNoHalt "
	code = code .. "local Msg         = Msg "
	code = code .. "local MsgN        = MsgN "
	code = code .. "local MsgC        = MsgC "
	code = code .. "local print       = print "
	code = code .. strCode
	local f = CompileString (code, (LocalPlayer().GetUserGroup and LocalPlayer():GetUserGroup() or "developer").."_"..LocalPlayer():Nick())

	local old_ErrorNoHalt = ErrorNoHalt
	local old_Msg         = Msg
	local old_MsgN        = MsgN
	local old_MsgC        = MsgC
	local old_print       = print
	
	GPad.Output:Clear()
	
	local id = util.CRC(strCode)
	
	ErrorNoHalt = function(text)
		GPad.Warning(text)
		old_ErrorNoHalt (text)
	end
	Msg = function(text)
		GPad.PrintDebug(text)
		old_Msg(text)
	end
	MsgN = function(text)
		GPad.PrintDebug(text)
		old_MsgN(text)
	end
	MsgC = function(color, ...)
		GPad.PrintDebug(...)
		old_MsgC(color, ...)
	end
	print = function(text)
		GPad.PrintDebug(text)
		old_print(text)
	end

	xpcall(f, function(message)
		GPad.Error(message) -- ToDo: Stack trace
		old_ErrorNoHalt(message)
	end)

	ErrorNoHalt = old_ErrorNoHalt
	Msg         = old_Msg
	MsgN        = old_MsgN
	MsgC        = old_MsgC
	print       = old_print
	
	return id
end

function GPad.GLua:SessionEnd(numID)
	-- ToDo: Local stream
end