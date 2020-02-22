cfcFactions.api = cfcFactions.api or {}

local constants = cfcFactions.constants
local logger = cfcFactions.logger

local apiRoot = constants.BACKEND_ROOT
local apiKey = "" -- TODO: Read API Key from file0.

local function onFail( requestName )
    return function( reason )
        cfcFactions.logger.error( requestName, reason )
    end
end

local function authenticatedRequest( method, endpoint, params )
    method = method or "GET"
    local url = apiRoot .. endpoint
    local onFailure = onFail( method .. "/" .. endpoint .. ":" .. params.id )

    local struct = HTTPRequest({
        failed = onFailure,
        success = logger.debug,
        method = method,
        url = url,
        parameters = params,
        type = "application/json",
        ["Token"] = apiKey
    })

    return HTTP( struct )
end

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
    local params = {}
    params["steam_id"] = steamId
    params["most_recent_name"] = mostRecentName

    return authenticatedPost( endpoint, params )
end
function cfcFactions.api:CreateFaction( name, color, description, creatorSteamId )
    local endpoint = constants.FACTIONS_ENDPOINT
    local params = {}
    params.name = name
    params.color = color
    params.description = description
    params["creator_steam_id"] = creatorSteamId

    return authenticatedPost( endpoint, params )
end

function cfcFactions.api:DestroyFaction( id )
    local endpoint = constants.FACTIONS_ENDPOINT
    local params = {}
    params.id = id

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