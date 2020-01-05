--[[
File Name: sh_userext.lua

Purpose: Shared functions to fetch users from the global table cfcFactions.Users

]]--
function cfcFactions:GetUser( ply )
    if SERVER then
        return cfcFactions.Users[ply:SteamID64()]
    end

    --TODO: Get user on clientside
end

-- old function, make sure to redo when this is called
-- should return a table of your fellow factioneers ( of same id )
function cfcFactions:GetFactionUsers( factionid )
    local tmp = {}

    for _, ply in pairs( cfcFactions.Users ) do
        if ply.FactionID == factionid then
            table.insert( tmp, ply )
        end
    end

    return tmp
end
