Backup = {}

function Backup.Set(str)
        file.Write( "_backup.txt", str )
end

function Backup.Get()
		if not file.Exists( "data/_backup.txt", "GAME" ) then
			file.Write( "_backup.txt", "" )
		end
        return file.Read("data/_backup.txt", "GAME")
end

function Backup.Create(str)
		-- Fo New guys
		if not file.IsDir("backup", "DATA") then file.CreateDir("backup") end
		--
		local name = "backup/save_"..os.date("%d.%m.%y %H.%M.%S",os.time())..".txt"
		chat.AddText(Color(100,50,50),"[Backup] ",Color(255,255,255),"Saved as "..name)
        return file.Write(name, str)
end