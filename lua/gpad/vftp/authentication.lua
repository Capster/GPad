GPad.VFTP.Authentication = {}

local Tag = "VFTPAuthentication"

if CLIENT then

	function GPad.VFTP.Authentication:Auth()
		GPad.VFS.Protocol:Send(Tag)
	end
	
	timer.Simple(1, function()
		GPad.VFTP.Authentication:Auth()
	end)
	
	GPad.VFS.Protocol:Receive(Tag, function(inBuffer)
		GPad.VFTP.Error("SERVER -> Access Denied")
	end)
end

if SERVER then
	GPad.VFS.Protocol:RegisterChannel(Tag)
	
	GPad.VFS.Protocol:Receive(Tag, function(inBuffer, _, entPlayer)
		if entPlayer.IsResticted and entPlayer:IsResticted() or entPlayer:IsSuperAdmin() then
			GPad.VFTP.Print(entPlayer, "Success")
			GPad.VFTP.Session:Start(entPlayer) -- Starting New Session (Fix Timeout, pls)
			return 
		end
		GPad.VFS.Protocol:Send(Tag, entPlayer)
	end) -- Log it, pls
end
