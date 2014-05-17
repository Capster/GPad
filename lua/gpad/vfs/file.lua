local META = {}

META.__index = META
META.Type = "VFSFile"

function META:__len()
	return #self:GetSize()
end

function META:IsDirectory()
	return false
end

function META:IsRootDirectory()
	return false
end

function META:IsFile()
	return true
end

function META:IsMovable()
	return true -- ToDO: remove 777 from all files
end

function META:IsWritable()
	return true -- ToDO: remove 777 from all files
end

function META:IsReadable()
	return true -- ToDO: remove 777 from all files
end

function META:SetPath(strPath)
	self.__path = strPath
end

function META:GetPath()
	return self.__path
end

function META:AddFile()
	GPad.VFS.Error("lel wat?")
end

function META:GetSize()
	return self.__size
end

function META:GetNiceSize()
	return string.NiceSize(self.__size)
end

function META:SetSize(numSize)
	self.__size = numSize
end

function META:GetContents()
	return self.__contents
end

function META:SetContents(strContent) -- Why String? - Because its Garry's mod, bitch.
	self.__contents = strContent
end

function GPad.VFS.File(strPath, strContent, numSize)
	local File = setmetatable({}, META)
	
	File:SetPath(strPath)
	File:SetContents(strContent)
	File:SetSize(numSize)
	
	return File
end