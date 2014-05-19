local META = {}

META.__index = META
META.Type = "VFSRoot"

function META:IsDirectory()
	return true
end

function META:IsRootDirectory()
	return true
end

function META:SetName(strName)
	self.Name = strName
end

function META:GetName()
	return self.Name
end

function GPad.VFS.MakeRoot(strName)
	local Root = setmetatable({}, META)
	
	Root:SetName(strName)
	
	return Root
end