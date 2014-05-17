function GPad.IncludeDir(directoryName, boolRecursive, strType)
	strType = strType or "cl"
	local this = debug.getinfo(1).short_src:gsub("\\", "/"):GetPathFromFilename()
	local f, p = file.Find(this.."/"..directoryName.."/*.lua", "GAME")
	for k, v in pairs(f) do
		if CLIENT and strType == "cl" or strType == "sh" then
			include(directoryName.."/"..v)
		else
			if strType == "sv" or strType == "sh" then
				include(directoryName.."/"..v)
			end
			AddCSLuaFile(directoryName.."/"..v)
		end
	end
	if boolRecursive then
		for k, v in pairs(p) do
			GPad.IncludeDir(directoryName.."/"..v, true)
		end
	end
end