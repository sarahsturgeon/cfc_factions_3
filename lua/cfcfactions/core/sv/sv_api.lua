cfcFactions.api = cfcFactions.api or {}

local constants = cfcFactions.constants
local logger = cfcFactions.logger

local apiRoot = constants.BACKEND_ROOT
local apiKey = "" -- TODO: Read API Key from file0.

local function _authenticatedRequest( method, endpoint, params )
    local url = apiRoot .. endpoint
    local overrides = {
        params = params,
        authToken = apiKey
    }
    local success, body, statusCode = await( NP.http.request( method, url, overrides ) )
    if success then
        local data = util.JSONToTable( body )
        if data then
            return data
        else
            cfcFactions.logger.fatal( requestName, "Invalid JSON - What did you do?" )
        end
    else
        cfcFactions.logger.fatal( requestName, body )
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
    local endpoint = constants.FACTIONS_ENDPOINT
    local params = {
        steam_id = steamId,
        most_recent_name = mostRecentName
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