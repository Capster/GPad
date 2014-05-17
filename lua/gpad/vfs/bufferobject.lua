local META = {}
META.__index = META
 
META.Type = "Buffer Object"

META.Buffer = {}

function META:__len()
	return #self.Buffer
end

function META:__add(newBuffer)
	return table.Add(self.Buffer, newBuffer)
end

function META:GetBuffer()
	return self.Buffer
end

function META:SetBuffer(tblBuffer)
	self.Buffer = tblBuffer
end

function META:AddElement(objNewElement)
	table.insert(self.Buffer, objNewElement)
end

function META:RemoveElement(numID)
	table.remove(self.Buffer, numID)
end

function GPad.VFS.Protocol.MakeBuffer(tblBuffer)
	local inBuffer = setmetatable({}, META)
	inBuffer:SetBuffer(tblBuffer)
	
	return inBuffer
end