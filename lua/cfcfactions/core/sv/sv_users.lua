--[[
File Name: sv_users.lua

Purpose: Core faction's functions to create, edit, and destory users who use factions

Global Tables: cfcFactions.Users
]]--
cfcFactions.Users = cfcFactions.Users or {}
local cfcuser = cfcFactions.Users
local fpm = cfcFactions.fpm

-- What a user should have when first logging into the server
local function ReturnDefaultTable()
    local PreUserTable = {
        ["CFCPermissions"] = {},
        ["DisplayName"] = nil,
        -- data only pretaining to a user inside a faction
        ["FactionMetadata"] = {
            ["DateAdded"] = cfcFactions:TimeStamp(),
            ["FactionID"] = "",
            ["Kills"] = 0,
            ["Deaths"] = 0,
            ["FactionRank"] = "",
            ["InternalFactionPermissions"] = {}
        },
        ["LastOnline"] = cfcFactions:TimeStamp(),
        ["PendingInvites"] = {}
    }
    return PreUserTable
end

-- Registers a new user to be accessible by factions
function cfcuser:registeruser( user )

    if not user:IsPlayer() then
        -- Error out, not a player
        return
    end

    if cfcuser:UserExists( user ) then
        -- Error out, already exsists
        return
    end

    cfcuser[user:SteamID64()] = ReturnDefaultTable()
    cfcuser[user:SteamID64()].DisplayName = user:Nick()
end

-- Checks if a user is already registered
function cfcuser:UserExists( user )
    if not IsValid( user ) and not user then
        -- Error out, not a player
        return
    end

    if table.HasValue( cfcuser, user:SteamID64() ) then
        return true
    else
        return false
    end
end

local function IsValidAndOfType( item, gtype )
    return ( item ~= nil ) and ( type( item ) == gtype )
end

local function IsValidNumber( num )
    return IsValidAndOfType( num, 'number' )
end

local function IsValidString( str )
    return IsValidAndOfType( str, 'string' )
end


-- Used to update a player's table of associated variables
function cfcuser:UpdateUser( user, lastonline, factionid, kills, deaths, factionrank )
    local PlayerEnt = user
    if ( not IsValid( PlayerEnt ) ) and ( not PlayerEnt:IsPlayer() ) then
        if ( type( PlayerEnt ) == "string" ) then
            PlayerEnt = player.GetBySteamID64( user )
            cfcuser:UpdateUser( PlayerEnt, lastonline, factionid, kills, deaths, factionrank )
        end
    end

    if not cfcuser:UserExists( user ) then
        cfcuser:registeruser( user )
    end

    local userTable = cfcuser[user:SteamID64()]
    local userFactionTable = userTable.FactionMetadata

    if not IsValidString( lastonline ) then
        LastOnline = cfcFactions:TimeStamp()
    else
        userTable["LastOnline"] = lastonline
    end

    if ( not IsValidNumber( factionid ) ) then

    else
        if cfcFactions:IsValidFaction( cfcFactions.Factions[factionid] ) then
            userFactionTable["FactionID"] = factionid
            if IsValidNumber( kills ) then
                userFactionTable["Kills"] = kills
            end

            if IsValidNumber( deaths ) then
                userFactionTable["Deaths"] = deaths
            end

            if IsValidString( factionrank ) then
                userFactionTable["FactionRank"] = factionrank
            end
        else

        end

    end

end

-- Uses mysql.lua to save to database
function cfcuser:SaveUser( user )

end

function cfcuser:Kills( user )
    return cfcuser[user:SteamID64()].FactionMetadata.Kills
end

function cfcuser:Deaths( user )
    return cfcuser[user:SteamID64()].FactionMetadata.Deaths
end

function cfcuser:FactionID( user )
    return cfcuser[user:SteamID64()].FactionMetadata.FactionID
end

function cfcuser:LastOnline( user )
    return cfcuser[user:SteamID64()].FactionMetadata.LastOnline
end

function cfcuser:FactionRank( user )
    return cfcuser[user:SteamID64()].FactionMetadata.FactionRank
end

-- Used to update values that may change quickly
function cfcuser:UpdateStats( user, lastonline, kills, deaths )
    if not cfcuser:UserExists( user ) then return end

    local userTable = cfcuser[user:SteamID64()]
    local userFactionTable = userTable["FactionMetadata"]
    if IsValidString( lastonline ) then userTable["LastOnline"] = lastonline end
    if IsValidNumber( kills ) then userFactionTable.FactionMetadata["Kills"] = kills end
    if IsValidNumber( deaths ) then userFactionTable.FactionMetadata["Deaths"] = deaths end
end

function cfcuser:SetUserFaction( user, id, rank )
    self:UpdateUser( user, _, id, rank )
end

function cfcuser:RemoveUser( user )
    cfcuser[user:SteamID64()].FactionMetadata = nil
    cfcuser[user:SteamID64()].FactionMetadata = ReturnDefaultTable.FactionMetadata
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

    if type( user == "string" ) then
        user = player.GetBySteamID( user )
    end
    if ( user == nil ) or ( not user:IsPlayer() ) then
        return false
    end

    local GetFactionUser = cfcuser[user:SteamID64()]
    if GetFactionUser == nil then return false end

    if ( GetFactionUser.FactionMetadata.FactionID == nil ) or ( #GetFactionUser.FactionMetadata.FactionID == 0 ) then
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

local function SendUserRefresh( data )

end

local function factionsPlayerInitialSpawn( player )
    cfcFactions.fpm:authUser( player )
end
hook.Add( "PlayerInitialSpawn", "CFC_Fac_PlayerInitialSpawn", factionsPlayerInitialSpawn )