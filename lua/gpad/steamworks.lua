function GPad.Steamworks:IsUserOnline(strSteamID) -- (On dat Server)
	for k,v in pairs(player.GetAll()) do
		if v:SteamID() == strSteamID then
			return true
		end
	end
end

function GPad.Steamworks:IsUserOffline(strSteamID)
	return not GPad.Steamworks:IsUserOnline(strSteamID)
end