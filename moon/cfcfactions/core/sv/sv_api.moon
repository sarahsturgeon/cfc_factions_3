cfcFactions.api or= {}

paths = cfcFactions.Config.Paths

apiKeyLocation = paths.AUTH_KEY_LOCATION
apiKey = ( file.Read apiKeyLocation ) or ""

-- Make serverside requests authenticated
cfcFactions.api.baseRequest or= cfcFactions.api.request

cfcFactions.api.request = ( method, endPoint, params, headers ) ->
    cfcFactions.api.baseRequest method, endPoint, params, headers, apiKey

cfcFactions.api.CreatePlayer = ( steamId, mostRecentName ) ->
    endpoint = paths.PLAYERS_ENDPOINT
    params =
        steam_id: steamId
        most_recent_name: mostRecentName
        last_online: os.time!

    cfcFactions.api.post endpoint, { players: params }

cfcFactions.api.CreateFaction = ( name, color, description, creatorSteamId, private, temp ) ->
    endpoint = paths.FACTIONS_ENDPOINT
    params =
        name: name
        color: color
        description: description
        creator_steam_id: creatorSteamId
        private: private
        temporary: temp

    cfcFactions.api.post endpoint, { factions: params }

cfcFactions.api.DestroyFaction = ( id ) ->
    endpoint = "#{paths.FACTIONS_ENDPOINT}/#{cfcFactions.api.handleIds id}"

    cfcFactions.api.delete endpoint

cfcFactions.api.UpdateFaction = ( id, params ) ->
    endpoint = "#{paths.FACTIONS_ENDPOINT}/#{cfcFactions.api.handleIds id}"

    cfcFactions.api.patch endpoint, { factions: params }

cfcFactions.api.UpdatePlayer = ( id, params ) ->
    endpoint = "#{paths.PLAYERS_ENDPOINT}/#{cfcFactions.api.handleIds id}"

    cfcFactions.api.patch endpoint, { players: params }
