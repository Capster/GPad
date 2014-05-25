GPad.GLua = {}

local function gpad_stamp()
--[[
	MsgC(Color(200, 200, 200), "[")
	MsgC(Color(160, 160, 160), "GPad")
	MsgC(Color(200, 200, 200), "]")]]
end

function GPad.GLua:SessionStart(strCode, lineBreakPoint)
	if lineBreakPoint then
		local tblCode = string.Explode("\n", strCode)
		tblCode[lineBreakPoint] = tblCode[lineBreakPoint].." return false, 'BreakPoint' "
		
		GPad:BreakPoint(lineBreakPoint)
		
		strCode = table.concat(tblCode, "\n")
	end
	
	local code = ""
	code = code .. "local ErrorNoHalt = ErrorNoHalt "
	code = code .. "local Msg         = Msg "
	code = code .. "local MsgN        = MsgN "
	code = code .. "local MsgC        = MsgC "
	code = code .. "local print       = print "
	code = code .. strCode
	
	local f = CompileString(code, (LocalPlayer().GetUserGroup and LocalPlayer():GetUserGroup() or "developer").."_"..LocalPlayer():Nick())

	local old_ErrorNoHalt = ErrorNoHalt
	local old_Msg         = Msg
	local old_MsgN        = MsgN
	local old_MsgC        = MsgC
	local old_print       = print
	
	GPad.Output:Clear()
	
	local id = util.CRC(strCode)
	
	ErrorNoHalt = function(text)
		GPad.Warning(_, text)
		old_ErrorNoHalt(text)
	end
	Msg = function(text)
		GPad.PrintDebug(_, text)
		old_Msg(text)
	end
	MsgN = function(text)
		GPad.PrintDebug(_, text)
		old_MsgN(text)
	end
	MsgC = function(color, ...)
		GPad.PrintDebug(_, ...)
		old_MsgC(color, ...)
	end
	print = function(text)
		GPad.PrintDebug(_, text)
		old_print(text)
	end

	xpcall(f, function(message)
		GPad.Error(_, message) -- ToDo: Stack trace
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
