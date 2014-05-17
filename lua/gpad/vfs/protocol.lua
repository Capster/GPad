GPad.VFS.Protocol.Channels = {}

function GPad.VFS.Protocol:RegisterChannel(strName)
	if SERVER then
		GPad.VFS.Debug("Protocol:RegisterChannel() -> "..strName)
		util.AddNetworkString(strName)
		GPad.VFS.Protocol.Channels[strName] = true
	else
		GPad.VFS.Error("Unhandled channel register!")
	end
end

function GPad.VFS.Protocol:UnregisterChannel(strName)
	if SERVER then
		GPad.VFS.Protocol.Channels[strName] = false
	else
		GPad.VFS.Error("Unhandled channel unregister!")
	end
end

function GPad.VFS.Protocol:Send(strName, entPlayer, ...)
	if SERVER and not GPad.VFS.Protocol.Channels[strName] then
		GPad.VFS.Error("Unpooled channel name: "..strName)
		return false
	end
	net.Start(strName)
	
	local tblMsg = {...}
	local lenMsg = GPad.VFS.Protocol.GetTableSize(tblMsg)
	-- <-- Some shit goes here...
	net.WriteTable(tblMsg)
	net.WriteInt(lenMsg, 0x20)
	net.WriteInt(SysTime(), 0x20)
	if CLIENT then
		return net.SendToServer()
	else
		if entPlayer then
			return IsValid(entPlayer) and net.Send(entPlayer)
		else
			return net.Broadcast()
		end
	end
	
end

function GPad.VFS.Protocol:Receive(strName, funcCallback)
	if SERVER then
		self:RegisterChannel(strName)
	end
	net.Receive(strName, function(numLength, entPlayer)
		local setupBuffer = GPad.VFS.Protocol.MakeBuffer(net.ReadTable()) 
		local len = net.ReadInt(0x20) -- NumLength not working with meta tables :O
		local time = SysTime() - net.ReadInt(0x20)
		GPad.VFS.Debug("Packet Size of "..strName.." is "..string.NiceSize(len / 0x8))
		GPad.VFS.Debug("Packet Time of "..strName.." is "..time)
		
		funcCallback(setupBuffer, len, entPlayer)
	end)	
end