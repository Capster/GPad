local function ToByte( Code ) return string.gsub( Code, ".", function( Char ) return "\\" .. string.byte( Char ) end); end
local function Random( V ) local a = ""; for i = V, math.random( V * 1, V * 3 ) do a = a .. " ".. ( "_" ):rep( i ) .."=_[\"".. ToByte( table.Random( { "RunStringEx", "DOF_Kill", "ColorToHSV", "DOFModeLHack", "AddOriginTpPVS", "AccessorFuncNW", "ErrorNoHalt", "GetTaskID", "LerpVector", "NewMesh", "PlayerDataUpdate", "STNDRD" } ) ) .. "\"]" end return a end
local function Obfuscate( Code ) return "local _=_G;".. Random( 5 ) .."__=_[\"" .. ToByte( "string" ) .. "\"][\"" .. ToByte( "reverse" ) .. "\"]".. Random( 8 ) .."_[\"".. ToByte( "RunString" ) .. "\"](__\"" .. ToByte( Code:reverse() ) .. "\")".. Random( 5 ); end

function GPad.GLua:Obfuscate(strCode)
	return Obfuscate(strCode)
end