function resource.AddDirectory(dir)
	local f, d = file.Find(dir .. '/*', 'GAME')
	
	for k, v in pairs(f) do
		resource.AddSingleFile(dir .. '/' .. v)
	end
	
	for k, v in pairs(d) do
		resource.AddDirectory(dir .. '/' .. v)
	end
end


resource.AddDirectory("materials/gpad")