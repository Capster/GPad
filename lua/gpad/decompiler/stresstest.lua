local abc = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}

function GPad.StressTest()
	local str = ""

	for i = 1, 20 do	
		str = "|"..str
		for k,v in pairs(abc) do
			str = str..v
			str = str.."㶗"
		end

		for k,v in pairs(abc) do	
			str = str..(v):upper()
			str = str.."㶗"
		end
		str = str.."| \n"
	end

	return str
end