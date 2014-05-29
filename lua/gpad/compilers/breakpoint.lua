function GPad:BreakPoint(numLine)
	hook.Run("GPad.BreakpointCall")
	GPad.PrintDebug(nil, "Exec Breakpoint on line: "..numLine)
end

function GPad:RevertPoint(numLine)
	hook.Run("GPad.RevertPoint")
	-- ToDO: ...
end