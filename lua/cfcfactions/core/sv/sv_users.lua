--[[
File Name: sv_users.lua

Purpose: Core faction's functions to create, edit, and destory users who use factions

Global Tables: cfcFactions.Users
]]--
cfcFactions.Users = cfcFactions.Users or {}
local cfcuser = cfcFactions.Users
local fpm = cfcFactions.fpm

-- Registers a new user to be accessible by factions
function cfcuser:registeruser( user, factionid, rank )

    if not user:IsPlayer() then
        -- Error out, not a player
        return
    end

    if cfcuser:UserExists( user ) then
        -- Error out, already exsists
        return
    end

    local PreUserTable = {
        ["DisplayName"] = user:Nick(),
        ["LastOnline"] = cfcFactions:TimeStamp(),
        ["PendingInvites"] = {},
        ["CFCPermissions"] = {},
        -- data only pretaining to a user inside a faction
        ["FactionMetadata"] = {
            ["DateAdded"] = cfcFactions:TimeStamp(),
            ["FactionID"] = "",
            ["Kills"] = 0,
            ["Deaths"] = 0,
            ["FactionRank"] = "",
            ["InternalFactionPermissions"] = {},
            ["HoursInFaction"] = 0
        }
    }
    cfcuser[user:SteamID64()] = PreUserTable

end

-- Checks if a user is already registered
function cfcuser:UserExists( user )

    if not user:IsPlayer() then
        -- Error out, not a player
        return
    end

    if table.HasValue( cfcuser, user:SteamID64() ) then
        return true
    else
        return false
    end
end

local function IsValidAndOfType( item, t )
    return item ~= nil and type( item ) == t
end

local function IsValidNumber( num )
    return IsValidAndOfType( num, 'number' )
end

local function IsValidString( str )
    return IsValidAndOfType( str, 'string' )
end

-- Used to update a player's table of associated variables
function cfcuser:UpdateUser( user, lastonline, factionid, kills, deaths, factionrank, hoursinfaction )
    if not cfcuser:UserExists( user ) then return end

    local userTable = cfcuser[user:SteamID64()]
    local userFactionTable = userTable["FactionMetadata"]
    if IsValidString( lastonline ) then userTable["LastOnline"] = lastonline end
    if IsValidNumber( factionId ) and cfcFactions:IsValidFaction( factionid ) then
        userFactionTable["FactionId"] = factionid
    end
    if IsValidNumber( kills ) then userFactionTable["Kills"] = kills end
    if IsValidNumber( deaths ) then userFactionTable["Deaths"] = deaths end
    if IsValidString( factionrank ) then userFactionTable["FactionRank"] = factionrank end
    if IsValidNumber( hoursinfaction ) and hoursinfaction > 0 then userFactionTable["HoursInFaction"] = hoursinfaction end
end

-- Used to update values that may change quickly
function cfcuser:UpdateStats( user, lastonline, kills, deaths, hoursinfaction )
    if not cfcuser:UserExists( user ) then return end

    local userTable = cfcuser[user:SteamID64()]
    local userFactionTable = userTable["FactionMetadata"]
    if IsValidString( lastonline ) then userTable["LastOnline"] = lastonline end
    if IsValidNumber( kills ) then userFactionTable["Kills"] = kills end
    if IsValidNumber( deaths ) then userFactionTable["Deaths"] = deaths end
    if IsValidNumber( hoursinfaction ) and hoursinfaction > 0 and IsInFaction( user ) then userFactionTable["HoursInFaction"] = hoursinfaction end
end

function cfcuser:SetUserFaction( user, id, rank )
    if not user:IsPlayer() then
        -- Error out, not a player
        return
    end

    if not cfcFactions:IsValidFaction( id ) then
        -- Error out, invalid faction
        return
    end
    local GetFactionUser = cfcuser[user:SteamID64()]
    GetFactionUser.FactionID = id
    GetFactionUser.FactionRank = rank
end

function cfcuser:RemoveUser( user )
    cfcuser[user:SteamID64()].FactionMetadata = nil
    cfcuser[user:SteamID64()].FactionMetadata = {
        ["DateAdded"] = cfcFactions:TimeStamp(),
        ["FactionID"] = "",
        ["Kills"] = 0,
        ["Deaths"] = 0,
        ["FactionRank"] = "",
        ["InternalFactionPermissions"] = {},
        ["HoursInFaction"] = 0
    }

end

function cfcuser:HasExistingInvite( user, id )
    if Isvalid( user ) and user:IsPlayer() then
        if table.hasValue( cfcuser[user:SteamID64()].PendingInvites.FactionID, id ) then
            return true
        else
            return false
        end
        return
    end
end

function cfcuser:AddUserInvite( user, id, inviter )
    if Isvalid( user ) and user:IsPlayer() then
        if not cfcuser:HasExistingInvite( user, id ) then
            table.insert( cfcuser[user:SteamID64()].PendingInvites, {
                ["FactionID"] = id,
                ["InviterSteamID"] = inviter:SteamID64()
            } )
        end
    end
end

function cfcuser:RemoveUserInvite( user, id )
    if Isvalid( user ) and user:IsPlayer() then
        cfcuser[user:SteamID64()].PendingInvites[id] =nil
    end
end

function cfcuser:IsInFaction( user )
    if not user:IsPlayer() then
        return
    end

    local GetFactionUser = cfcuser[user:SteamID64()]
    if GetFactionUser == nil then return false end
    if GetFactionUser.FactionID == nil then
        return false
    else
        return true
    end
end

function cfcuser:IsInFaction( user, id )
    if not user:IsPlayer() then
        return
    end

    local GetFactionUser = cfcuser[user:SteamID64()]
    if GetFactionUser == nil then return false end
    if GetFactionUser.FactionMetadata.FactionID == id then
        return true
    else
        return false
    end
end
