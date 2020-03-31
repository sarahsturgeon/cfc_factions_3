--[[
File Name: sv_users.lua

Purpose: Core faction's functions to create, edit, and destory users who use factions

Global Tables: cfcFactions.Users
]]--
cfcFactions.Users = cfcFactions.Users or {}
local factioneers = cfcFactions.Users
local logger = cfcFactions.logger

-- why are we storing some different structure on the server, just copy database?
-- ^ for factions
-- how are we doing invites?


-- Registers a new user to be accessible by factions
local function _registerUser( _, user )
    if not user:IsPlayer() then
        -- Error out, not a player
        logger:error( "Cannot register user, player is invalid!" )
        return
    end

    if factioneers:UserExists( user ) then
        -- Error out if already exist
        logger:error( "Cannot register user, user " .. user:SteamID() .. " already exists!" )
        return
    end

    logger:info( "Registering new user #P = " .. user:SteamID64() )
    local sID = user:SteamID64()
    local name = user:Nick()
    
    local success, data = await( cfcFactions.api:CreatePlayer( sID, name ) )

    if not success then
        return logger:fatal( "Register user failed: " .. data );
    end
    
    factioneers[sID] = data
    return data
end
factioneers.registerUser = async( _registerUser )

-- Checks if a user is already registered
function factioneers:UserExists( user )
    if not ( user and IsValid( user ) ) then
        -- Error out, not a player
        logger:error( "Cannot verify user, player is invalid!" )
        return false
    end

    return factioneers[user:SteamID64()] ~= nil
end

local function _AuthUser( _, user )
    if user:IsBot() then return end

    if not factioneers:UserExists( user ) then
        local steamID = user:SteamID64()

        local success, data = await( cfcFactions.api:GetPlayerBySteamID64( steamID ) )
        
        if not success then
            return logger:fatal( "Player auth failed: " .. data )
        end

        if #data == 0 then
            local success, userData = await( factioneers:registerUser( user ) )

            if not success then
                return logger:fatal( "Player auth failed: " .. userData )
            end
        else
            local userData = data[1]

            user:SetNWInt( "CFC_FactionID", userData.faction_id )
            userData.most_recent_name = user:Nick()
            userData.last_online = os.time()

            local success, userData = await( cfcFactions.api:UpdatePlayer( userData.id, userData ) )

            factioneers[user:SteamID64()] = userData
        end
    end

    local factioneer = factioneers:User( user )

    print( logger:info( "Authenticated user " .. factioneer.id .. "(" .. user:Nick() .. ")" ) )

    if factioneer.faction_id then
        cfcFactions:cacheFaction( factioneer.faction_id )
    end

end
factioneers.AuthUser = async( _AuthUser )

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
local function _UpdateUser( _, user, data )
    
    local success, userData = await( cfcFactions.api:UpdateFaction( id, data ) )

    cfcFactions.Factions[factionData.id] = factionData

    hook.Call( "CFC_Factionhook_UserEdited" )

    -- TODO: Tell clients to pull from database again 

    return userData
end
factioneers.UpdateUser = async( _UpdateUser )


function factioneers:FactionID( user )
    return factioneers[user:SteamID64()].faction_id
end

-- TODO: check correct
function factioneers:LastOnline( user )
    return factioneers[user:SteamID64()].last_online
end

-- TODO: check this is correct
function factioneers:FactionRank( user )
    return factioneers[user:SteamID64()].faction_rank
end

-- Used to update values that may change quickly
function factioneers:UpdateStats( user, lastonline, kills, deaths )
    if not factioneers:UserExists( user ) then return end

    local userTable = factioneers[user:SteamID64()]
    local userFactionTable = userTable["FactionData"]
    if IsValidString( lastonline ) then userTable["LastOnline"] = lastonline end
    if IsValidNumber( kills ) then userFactionTable.FactionData["Kills"] = kills end
    if IsValidNumber( deaths ) then userFactionTable.FactionData["Deaths"] = deaths end
end

function factioneers:SetUserFaction( user, id, rank )
    self:UpdateUser( user, _, id, rank )
end

-- This completely removes a user's data. Ill advised if they have important stuff and use factions
function factioneers:ClearFaction( user )
    local userData = factioneers:User( user )
    if not userData then return end
    userData.faction_id = nil
    -- TODO: Set other things to nil, like rank, etc.
end

function factioneers:IsInFaction( user, id )
    if not user:IsPlayer() then
        return
    end

    local GetFactionUser = factioneers[user:SteamID64()]
    if GetFactionUser == nil then return false end
    if id then
        return GetFactionUser.faction_id == id
    else
        return GetFactionUser.faction_id ~= nil
    end
end

function factioneers:FactionOwner()

end

local function factionsPlayerInitialSpawn( ply )
    factioneers:AuthUser( ply )
end

hook.Add( "PlayerInitialSpawn", "CFC_Fac_PlayerInitialSpawn", factionsPlayerInitialSpawn )
