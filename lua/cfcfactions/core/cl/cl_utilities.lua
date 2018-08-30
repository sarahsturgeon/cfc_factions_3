local cfcFactions = cfcFactions or {}
if not CLIENT then return end



--Used to clean a string in order to properly use it as a 
--dynamic variable name
function cfcFactions:SanitizeLuaVariableName(inputstring)
	if inputstring == nil then return "" end
	local tmp = ""

	for k=1,#inputstring do
		tmp = string.Replace(inputstring," ","_")
	end
	return string.lower(tmp)
end



