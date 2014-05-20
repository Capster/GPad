local META = {}

META.__index = META
META.Type = "Consturctor"

function META:Setup(tblRoot)
	table.Add(self, tblRoot)
end

function META:GenerateHash()
	self.__Hash = string.format("%p", self)
end

function META:AddHook(strFunction, funcCallback)
	self:GenerateHash()
	hook.Add(strFunction, self.__Hash, funcCallback)
end

function META:RemoveHook(strFunction)
	if not self.__Hash then return end
	hook.Remove(strFunction, self.__Hash)
end

function META:BindHook(strFunction)
	self:GenerateHash()
	
	self[strFunction] = function() end
	
	hook.Add(strFunction, self.__Hash, function()
		self[strFunction]()
	end)
end

function META:UnbindHook(strFunction)
	if not self.__Hash then return end
	
	self[strFunction] = nil
	
	hook.Remove(strFunction, self.__Hash)
end

function GPad.Consturctor(tblRoot)
	local constructor = setmetatable({}, META)	
	constructor:Setup(tblRoot or {})
	return constructor
end