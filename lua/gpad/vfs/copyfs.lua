GPad.VFS.FSS = {}

local Tag = "CreateVFS"

if CLIENT then
	GPad.VFS.Protocol:Receive(Tag, function(inBuffer)
		local size = inBuffer:PullNumber()
		local FS = inBuffer:PullTable()
		GPad.VFS.FSS["SERVER"] = GPad.VFS.MakeRoot("Server")
		GPad.VFS.FSS["SERVER"]:SetFileSystem(FS)
		PrintTable(GPad.VFS.FSS["SERVER"]:GetFileSystem()) -- Debug. ( Missing File Browser :C )
	end)
end

if SERVER then
	GPad.VFS.Protocol:RegisterChannel(Tag)
	
	function GPad.VFS.SendServerPack(entPlayer)
		GPad.VFS.Protocol:Send(Tag, entPlayer, 1,file.Find("*", "LUA"))
	end
	GPad.VFS.SendServerPack(entPlayer) -- Debug. ( Missing Auth )
end
