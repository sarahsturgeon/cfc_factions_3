cfcFactions = cfcFactions or {}
cfcFactions.__index = cfcFactions

if SERVER then
    AddCSLuaFile()
    --defines all others files to be loaded for the server
    include("cfcfactions/core/sv/sv_init.lua")
end

if CLIENT then
	--defines all others files to be loaded for the client
	print("INCLUDING CL_INIT.LUA")
    include("cfcfactions/core/cl/cl_init.lua")
end

