--[[
File Name: sv_users.lua

Purpose: Core faction's functions to create, edit, and destory users who use factions

Global Tables: cfcFactions.Users
]]--
cfcFactions.Users = cfcFactions.Users or {}
local factioneers = cfcFactions.Users

-- What a user should have when first logging into the server
local function ReturnDefaultTable()
    local PreUserTable = {
        ["SteamID"] = "",
        ["CFCPermissions"] = {},
        ["DisplayName"] = "",
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
function factioneers:registerUser( user )

    if not user:IsPlayer() then
        -- Error out, not a player
        return
    end

    if factioneers:UserExists( user ) then
        -- Error out if already exist
        return
    end

    print( "Registering new user #P = " .. user:SteamID64() )
    factioneers[user:SteamID64()]  = ReturnDefaultTable()
    factioneers[user:SteamID64()].DisplayName = user:Nick()
    factioneers[user:SteamID64()].SteamID = user:SteamID()

    --[TODO] Save to DB!
end

-- Checks if a user is already registered
function factioneers:UserExists( user )
    if not ( user and IsValid( user ) ) then
        -- Error out, not a player
        return false
    end

    if factioneers[user:SteamID64()] ~= nil then
        return true
    else
        return false
    end
end

local function IsValidAndOfType( item, gtype )
    return ( item ~= nil ) and ( type( item ) == gtype )
end

local function IsValidNumber( num )
    return IsValidAndOfType( num, "number" )
end

local function IsValidString( str )
    return IsValidAndOfType( str, "string" )
end

-- Returns a table of the user's stuff
function factioneers:User( ply )
    if type( ply ) ~= "Player" then return end

    local playerIsValid = IsValid( ply ) and ply:IsPlayer()
    local playerExists = factioneers:UserExists( ply )

    if not playerIsValid then return end
    if not playerExists then return end

    return factioneers[ply:SteamID64()]
end

-- Used to update a player's table of associated variables
function factioneers:UpdateUser( user, lastonline, factionid, kills, deaths, factionrank )
    local plyEnt = user

    local playerIsInvalid = not ( IsValid( plyEnt ) and plyEnt:IsPlayer() )

    -- TODO: name this to describe what it is
    local plyEntIsString = type( plyEnt ) == "string"

    if playerIsInvalid and plyEntIsString then
        plyEnt = player.GetBySteamID64( user )
        factioneers:UpdateUser( plyEnt, lastonline, factionid, kills, deaths, factionrank )
    end

    if not factioneers:UserExists( user ) then
        factioneers:registerUser( user )
    end

    local userTable = factioneers[user:SteamID64()]
    local userFactionTable = userTable.FactionMetadata

    if not IsValidString( lastonline ) then
        LastOnline = cfcFactions:TimeStamp()
    else
        userTable["LastOnline"] = lastonline
    end

    if IsValidNumber( factionid ) then
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
          -- Conditional Statement for if a faction is NOT valid.
          -- We can likely send error to client stateing that.
          return
        end
        -- alert user not a proper number
        -- Conditional Statement for if a faction id is not a number
        return
    end

end

-- TODO: Uses mysql.lua to save to database
function factioneers:SaveUser( user )

end

function factioneers:Kills( user )
    return factioneers[user:SteamID64()].FactionMetadata.Kills
end

function factioneers:Deaths( user )
    return factioneers[user:SteamID64()].FactionMetadata.Deaths
end

function factioneers:FactionID( user )
    return factioneers[user:SteamID64()].FactionMetadata.FactionID
end

function factioneers:LastOnline( user )
    return factioneers[user:SteamID64()].FactionMetadata.LastOnline
end

function factioneers:FactionRank( user )
    return factioneers[user:SteamID64()].FactionMetadata.FactionRank
end

-- Used to update values that may change quickly
function factioneers:UpdateStats( user, lastonline, kills, deaths )
    if not factioneers:UserExists( user ) then return end

    local userTable = factioneers[user:SteamID64()]
    local userFactionTable = userTable["FactionMetadata"]
    if IsValidString( lastonline ) then userTable["LastOnline"] = lastonline end
    if IsValidNumber( kills ) then userFactionTable.FactionMetadata["Kills"] = kills end
    if IsValidNumber( deaths ) then userFactionTable.FactionMetadata["Deaths"] = deaths end
end

function factioneers:SetUserFaction( user, id, rank )
    self:UpdateUser( user, _, id, rank )
end

--This completely removes a user's data. Ill advised if they have important stuff and use factions
function factioneers:RemoveUser( user )
    factioneers[user:SteamID64()].FactionMetadata = nil
    factioneers[user:SteamID64()].FactionMetadata = ReturnDefaultTable().FactionMetadata
    -- TODO: Save to DB!
end

function factioneers:HasExistingInvite( user, id )
    local playerIsValid = IsValid( user ) and user:IsPlayer()

    if not playerIsValid then return end

    if table.hasValue( factioneers[user:SteamID64()].PendingInvites.FactionID, id ) then
        return true
    end

    return false
end

function factioneers:AddUserInvite( user, id, inviter )
    local playerIsValid = IsValid( user ) and user:IsPlayer()
    local hasInvitesPending = factioneers:HasExistingInvite( user, id )

    if playerIsValid and not hasInvitesPending then
        table.insert( factioneers[user:SteamID64()].PendingInvites, {
            ["FactionID"] = id,
            ["InviterSteamID"] = inviter:SteamID64()
        } )
    end
end

function factioneers:RemoveUserInvite( user, id )
    local playerIsValid = IsValid( user ) and user:IsPlayer()

    if not playerIsValid then return end

    factioneers[user:SteamID64()].PendingInvites[id] = nil
end

function factioneers:IsInFaction( user )

    --TODO, rework to use sql checking instead of internal server tables
    if type( user == "string" ) then
        user = player.GetBySteamID( user )
    end
    if ( user == nil ) or ( not user:IsPlayer() ) then
        return false
    end

    local GetFactionUser = factioneers[user:SteamID64()]
    if GetFactionUser == nil then return false end

    if ( GetFactionUser.FactionMetadata.FactionID == nil ) or ( #GetFactionUser.FactionMetadata.FactionID == 0 ) then
        return false
    else
        return true
    end
end

function factioneers:IsInFaction( user, id )
    if not user:IsPlayer() then
        return
    end

    local GetFactionUser = factioneers[user:SteamID64()]
    if GetFactionUser == nil then return false end
    if GetFactionUser.FactionMetadata.FactionID == id then
        return true
    else
        return false
    end
end

-- TODO: Delete or fill
-- local function SendUserRefresh( data )
-- end

local function factionsPlayerInitialSpawn( ply )
    cfcFactions.fpm:authUser( ply )
end
hook.Add( "PlayerInitialSpawn", "CFC_Fac_PlayerInitialSpawn", factionsPlayerInitialSpawn )
