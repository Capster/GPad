GPad = {}

if not Metro then 
	include("autorun/metro.lua")
end

include("gpad/loader.lua")

function GPad.PrintDebug(...)
	Msg"[GPad] " print(...)
end
RunConsoleCommand("gpad_show")

if SERVER then return end

GPad.IncludeDir("ui", true)