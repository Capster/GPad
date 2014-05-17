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

-- Push

function META:PushString(strString)
	self:AddElement(strString)
end

function META:PushNumber(numNumber)
	self:AddElement(numNumber)
end

function META:PushTable(tblTable)
	self:AddElement(tblTable)
end

function META:PushBool(boolBool)
	self:AddElement(boolBool)
end

-- Pull

function META:PullNextByType(strType)
	for curIndex, curElement in pairs(self:GetBuffer()) do
		if type(curElement) == strType then
			table.remove(self:GetBuffer(), curIndex)
			return curElement
		end
	end
end

function META:PullString()
	return self:PullNextByType("string")
end

function META:PullNumber()
	return self:PullNextByType("number")
end

function META:PullTable()
	return self:PullNextByType("table")
end

function META:PullBool()
	return self:PullNextByType("boolean")
end


function GPad.VFS.Protocol.MakeBuffer(tblBuffer)
	local inBuffer = setmetatable({}, META)
	inBuffer:SetBuffer(tblBuffer)
	
	return inBuffer
end