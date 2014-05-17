local META = FindMetaTable("Player")

function META:SetVFTPStatus(strStatus, boolStatus)
	self:SetNWBool("VFTP: "..strStatus, boolStatus)
end

function META:GetVFTPStatus(strStatus)
	return self:GetNWBool("VFTP: "..strStatus)
end