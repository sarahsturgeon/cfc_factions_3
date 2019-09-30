--[[]
File Name: sh_userext.lua

Purpose: Shared functions to fetch users from the global table cfcFactions.Users

]]--

local table = table

function cfcFactions:GetUser( ply )
    return cfcFactions.Users[ply:SteamID64()]
end

function cfcFactions:GetFactionUsers( factionid )
    local tmp = {}
    for _, ply in pairs( cfcFactions.Users ) do
        if ply.FactionID = factionid then
            table.insert(tmp, ply)
        end
    end
    return tmp
end
