GPad.VFS.Protocol = {}

function GPad.VFS.Protocol:RegisterChannel(strName)
	if SERVER then
		GPad.VFS.Debug("Protocol:RegisterChannel() -> "..strName)
		util.AddNetworkString(strName)
	else
		GPad.VFS.Error("Unhandled channel register!")
	end
end
