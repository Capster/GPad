GPad.GLua = {}

function GPad.GLua:OverrideOutput(funcFunction)
	local funcOldFunction = funcFunction
	dumpFunction = function(...)
		GPad.PrintDebug(_, ...)
		funcOldFunction(...)
	end
	return dumpFunction
end


function GPad.GLua:SessionStart(strCode, lineBreakPoint)
	if lineBreakPoint then
		local tblCode = string.Explode("\n", strCode)
		tblCode[lineBreakPoint] = tblCode[lineBreakPoint].." return false, 'BreakPoint' "
		
		GPad:BreakPoint(lineBreakPoint)
		
		strCode = table.concat(tblCode, "\n")
	end
	
	local tblCode = {
		"local ErrorNoHalt = GPad.GLua:OverrideOutput(ErrorNoHalt)",
		"local Msg         = GPad.GLua:OverrideOutput(Msg)",
		"local MsgN        = GPad.GLua:OverrideOutput(MsgN)",
		"local MsgC        = GPad.GLua:OverrideOutput(MsgC)",
		"local print       = GPad.GLua:OverrideOutput(print)",
		strCode,
	}
	
	local strCode = table.concat(tblCode, " \n")

	local usergroup = LocalPlayer().GetUserGroup and LocalPlayer():GetUserGroup() or "developer"
	local nick = LocalPlayer():Nick() 

	local f = CompileString(strCode, usergroup.."_"..nick)
	
	GPad.Output:Clear()
	
	local id = util.CRC(strCode)

	xpcall(f, function(message)
		GPad.Error(_, message) -- ToDo: Stack trace
		old_ErrorNoHalt(message)
	end)
	
	return id
end

function GPad.GLua:SessionEnd(numID)
	-- ToDo: Local stream
end
