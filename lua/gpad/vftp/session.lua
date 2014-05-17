if CLIENT then return end
GPad.VFTP.Session = {}
GPad.VFTP.Session.TimeOut = 3

function GPad.VFTP.Session:Start(entPlayer)
	if not entPlayer:GetVFTPStatus("AUTH") then
		entPlayer:SetVFTPStatus("AUTH", true)
		timer.Simple(GPad.VFTP.Session.TimeOut, function()
			-- ToDo: timeout
		end)
		return GPad.VFTP.Debug("Starting Session for "..tostring(entPlayer))
	else
		--GPad.VFTP.Error("Ending Session without start?")
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