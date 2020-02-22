include("cfcfactions/constants/constants.lua")

cfcFactions.api = cfcFactions.api or {}

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
        success = cfcFactions.logger.debug,
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

function cfcFactions.api:CreatePlayer( ply )
    local endpoint = constants.FACTIONS_ENDPOINT
    local params = {}
    params["steam_id"] = ply:SteamID()
    params["most_recent_name"] = ply:Name()

    return authenticatedPost( endpoint, params )
end
function cfcFactions.api:CreateFaction( name, color, description, creator )
    local endpoint = constants.FACTIONS_ENDPOINT
    local params = {}
    params.name = name
    params.color = color
    params.description = description

    local creatorId = creator:SteamID()
    params["creator_steam_id"] = creatorId

    return authenticatedPost( endpoint, params )
end

function cfcFactions.api:DestroyFaction( id, destroyer )
    if not destroyer:FactionID() == id then
        return -- TODO: NotOwnerError
    end

    local endpoint = constants.FACTIONS_ENDPOINT
    local params = {}
    params.id = id

    return authenticatedDelete( endpoint, params )
end

function cfcFactions.api:UpdateFaction( id, params, updater )
    local isFactionOwner = updater:Faction():OwnerSteamId() == updater:SteamID()
    if not isFactionOwner then
        return -- TODO: NotOwnedError
    end
end

function cfcFactions.api:GetFaction( id )
    local endpoint = constants.FACTIONS_ENDPOINT .. "/" .. id

    return authenticatedRequest( endpoint )
end

function cfcFactions.api:GetPlayer( id )
    local endpoint = constants.FACTIONS_ENDPOINT .. "/" .. id

    return authenticatedRequest( endpoint )
end