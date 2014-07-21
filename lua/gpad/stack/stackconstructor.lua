GPad.Stack = GPad.Consturctor()

local META = {}
META.__index = META

META.Elements 	= {}

function META:__len()
	return #self.Elements
end

function META:Push(...)
	local args = {...}
	for k, v in ipairs(args) do
		table.insert(self.Elements, v)
	end
end

function META:Pop()
	if #self == 0 then return nil end
	self.Elements[#self.Elements] = nil
	return self.Elements[#self.Elements]
end

function META:List()
	return self.Elements
end

function GPad.Stack.MakeConstructor()
	return setmetatable({}, META)
end