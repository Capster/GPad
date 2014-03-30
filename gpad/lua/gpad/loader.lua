function GPad.IncludeDir(directoryName, boolRecursive)
	local this = debug.getinfo(1).short_src:gsub("\\", "/"):GetPathFromFilename()
	local f, p = file.Find(this.."/"..directoryName.."/*.lua", "GAME")
	for k, v in pairs(f) do
		if CLIENT then
			include(directoryName.."/"..v)
		else
			AddCSLuaFile(directoryName.."/"..v)
		end
	end
	if boolRecursive then
		for k, v in pairs(p) do
			GPad.IncludeDir(directoryName.."/"..v, true)
		end
	end
end