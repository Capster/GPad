if CLIENT then return end
GPad.VFTP.Session = {}
GPad.VFTP.Session.TimeOut = 0

GPad.VFTP.Session.Connections = {}

function GPad.VFTP.Session:Start(entPlayer)
	if not entPlayer:GetVFTPStatus("AUTH") then
		entPlayer:SetVFTPStatus("AUTH", true)
		GPad.VFTP.Session.Connections[entPlayer] = true
		if GPad.VFTP.Session.TimeOut ~= 0 then
			GPad.VFTP.Session:CreateTimeout(entPlayer, GPad.VFTP.Session.TimeOut)
		end
		return GPad.VFTP.Debug("Starting Session for "..tostring(entPlayer))
	end
end

function GPad.VFTP.Session:End(entPlayer, strCustomReason)
	if entPlayer:GetVFTPStatus("AUTH") then
		entPlayer:SetVFTPStatus("AUTH", false)
		GPad.VFTP.Session.Connections[entPlayer] = nil
		return GPad.VFTP.Debug("Ending Session for "..tostring(entPlayer)..(strCustomReason and " ("..strCustomReason..")" or nil))
	else
		GPad.VFTP.Error("Ending Session without start?")
	end
end

function GPad.VFTP.Session:CreateTimeout(entPlayer, numSeconds)
	timer.Simple(numSeconds, function()
		self:Timeout(entPlayer)
	end)
end

function GPad.VFTP.Session:Timeout(entPlayer)
	entPlayer:SetVFTPStatus("AUTH", false)
	GPad.VFTP.Session.Connections[entPlayer] = nil
	return GPad.VFTP.Debug("Ending Session for "..tostring(entPlayer).." (Timeout)")
end

--GPad.VFTP.Session:Start(player.GetByID(1))