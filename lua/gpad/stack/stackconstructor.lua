local META = {}
META.__index = META

META.Type = "stack"

META.Elements 	= {}
META.TopElement = nil
META.Count		= 0

function META:__tostring()
	local stack = "[Stack ("..self.Count..")]"
	for i = 1, self.Count do
		stack = stack.."\n["..tostring(i).."] "
		if type(self.Elements[i]) == "table" and type(self.Elements[i].ToString) == "function" then
			stack = stack..self.Elements[i]:ToString()
		else
			stack = stack..tostring(self.Elements[i])
		end
	end
	return stack
end

function META:__len()
	return #self.Count
end

function META:Push(variable)
	self.Count = self.Count + 1
	self.TopElement = variable
	self.Elements[self.Count] = variable
end

function META:Pop()
	if self:IsEmpity() then return nil end
	local TopElement = self.TopElement
	self.Elements[self.Count] = nil
	self.Count = self.Count - 1
	self.TopElement = self.Elements[self.Count]
	return TopElement
end

function META:Peek(offset)
	offset = offset or 0
	if offset < 0 then offset = -offset end
	return self.Items[self.Count - offset]
end

function META:IsEmpty()
	return self.Count == 0
end

function GPad.Stack.MakeConstructor()
	return setmetatable({}, META)
end