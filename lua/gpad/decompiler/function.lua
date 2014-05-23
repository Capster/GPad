local META = {}

META.__index = META

function META:__tostring()
	return string.format("function[%s]", string.format("%p", self:GetFunction()))
end

function META:GetStartLine()
	return self.StartLine
end

function META:GetEndLine()
	return self.EndLine
end

function META:GetLineRange()
	return self.EndLine - self.StartLine
end

function META:GetFilePath()
	return self.FilePath
end

function META:GetFunction()
	return self.Function
end

function META:GetInfoTable()
	return self.InfoTable
end

function META:GetParameterList()
	if self.ParameterList == nil then
		self.ParameterList = GLib.Lua.ParameterList (self)
	end

	return self.ParameterList
end

function META:GetRawFunction()
	return self.Function
end

function META:IsNative()
	return self.Native
end

function GPad.Decompiler.Function(func)
	local self = setmetatable({}, META)
	self.Function = func
	self.InfoTable = func and debug.getinfo(func) or nil
	self.ParameterList = nil

	self.FilePath = self.InfoTable and self.InfoTable.short_src

	self.StartLine = self.InfoTable and self.InfoTable.linedefined
	self.EndLine = self.InfoTable and self.InfoTable.lastlinedefined

	self.Native = self.InfoTable and self.InfoTable.what == "C"
	return self
end

-- print(GPad.Decompiler.Function(jit.on):IsNative())
