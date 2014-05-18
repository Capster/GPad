if CLIENT then return end
GPad.VFTP.Session = {}
GPad.VFTP.Session.TimeOut = 3

function GPad.VFTP.Session:Start(entPlayer)
	if not entPlayer:GetVFTPStatus("AUTH") then
		entPlayer:SetVFTPStatus("AUTH", true)
		timer.Simple(GPad.VFTP.Session.TimeOut, function()
			self:Timeout(entPlayer)
		end)
		return GPad.VFTP.Debug("Starting Session for "..tostring(entPlayer))
	end
end

function GPad.VFTP.Session:End(entPlayer)
	if entPlayer:GetVFTPStatus("AUTH") then
		entPlayer:SetVFTPStatus("AUTH", false)
		return GPad.VFTP.Debug("Ending Session for "..tostring(entPlayer))
	else
		GPad.VFTP.Error("Ending Session without start?")
	end
end

function GPad.VFTP.Session:Timeout(entPlayer)
	entPlayer:SetVFTPStatus("AUTH", false)
	return GPad.VFTP.Debug("Ending Session for "..tostring(entPlayer).." (Timeout)")
end

GPad.VFTP.Session:Start(player.GetByID(1))