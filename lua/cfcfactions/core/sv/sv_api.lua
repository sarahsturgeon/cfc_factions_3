cfcFactions.api = cfcFactions.api or {}

local constants = cfcFactions.constants
local logger = cfcFactions.logger

local apiRoot = constants.BACKEND_ROOT
local apiKey = "" -- TODO: Read API Key from file0.

function table.mapSelf( tab, f )
    for k, v in pairs( tab ) do
        tab[k] = f( v )
    end
end

function table.map( tab, f )
    local out = table.Copy( tab )
    table.mapSelf( out, f )
    return out
end

local function errorAsString( obj )
    for k, v in pairs( obj ) do
        return k .. ": " .. v
    end
end

local function _authenticatedRequest( method, endpoint, params )
    local url = apiRoot .. endpoint
    local overrides = {
        body = util.TableToJSON( params ),
        authToken = apiKey
    }
    local success, body, status = await( NP.http.request( method, url, overrides ) )
    local data = util.JSONToTable( body )
    if data then
        if success then
            return data
        else
            -- TODO: Redo this part based on status
            logger:fatal( status .. " => " .. table.concat( table.map( data.errors, errorAsString ), ", " ) )
        end
    else
        logger:fatal( "Invalid JSON:\n" .. body )
    end
end
local authenticatedRequest = async( _authenticatedRequest )

local function authenticatedPost( endpoint, params )
    return authenticatedRequest( "POST", endpoint, params )
end

local function authenticatedDelete( endpoint, params )
    return authenticatedRequest( "DELETE", endpoint, params )
end

local function authenticatedPatch( endpoint, params )
    return authenticatedRequest( "PATCH", endpoint, params )
end

function cfcFactions.api:CreatePlayer( steamId, mostRecentName )
    local endpoint = constants.PLAYERS_ENDPOINT
    local params = {
        players = {
            steam_id = steamId,
            most_recent_name = mostRecentName,
        }
    }
    return authenticatedPost( endpoint, params )
end
function cfcFactions.api:CreateFaction( name, color, description, creatorSteamId )
    local endpoint = constants.FACTIONS_ENDPOINT
    local params = {
        name = name,
        color = color,
        description = description,
        creator_steam_id = creatorSteamId
    }

    return authenticatedPost( endpoint, params )
end

function cfcFactions.api:DestroyFaction( id )
    local endpoint = constants.FACTIONS_ENDPOINT
    local params = {
        id = id
    }

    return authenticatedDelete( endpoint, params )
end

function cfcFactions.api:UpdateFaction( id, params )
    local endpoint = constants.FACTIONS_ENDPOINT .. "/" .. id

    return authenticatedPatch( endpoint, params )
end

function cfcFactions.api:GetFactions( page )
    local endpoint = constants.FACTIONS_ENDPOINT
    if page then endpoint = endpoint .. "?page=" .. page end

    return authenticatedRequest( endpoint )
end

function cfcFactions.api:GetFaction( id )
    local endpoint = constants.FACTIONS_ENDPOINT .. "/" .. id

    return authenticatedRequest( endpoint )
end

function cfcFactions.api:GetPlayers( page )
    local endpoint = constants.PLAYERS_ENDPOINT
    if page then endpoint = endpoint .. "?page=" .. page end

    return authenticatedRequest( endpoint )
end

function cfcFactions.api:GetPlayer( id )
    local endpoint = constants.PLAYERS_ENDPOINT .. "/" .. id

    return authenticatedRequest( endpoint )
end

function cfcFactions.api:GetPlayerBySteamID64( steamID )
    local endpoint = constants.PLAYERS_FIND_ENDPOINT .. "/"
    local params = {
        players = {
            steam_id = steamID
        }
    }

    return authenticatedPost( endpoint, params )
end