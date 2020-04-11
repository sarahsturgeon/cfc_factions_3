cfcFactions.api or= {}

paths = cfcFactions.Config.Paths
apiRoot = paths.BACKEND_ROOT

logger = cfcFactions.logger

parseErrors = ( data ) ->
    _, errors = next data
    out = ""
    for field, fieldErrors in pairs errors
        errStr = fieldErrors
        if ( type fieldErrors ) == "table"
            errStr = table.concat fieldErrors, ", "

        out ..= "#{field}: #{errStr};"
    out

cfcFactions.api.handleIds = ( ids ) ->
    if ( type ids ) ~= "table"
        ids = { ids }
    table.concat ( ids or {} ), ","

cfcFactions.api.request = async ( method="GET", endPoint, params, headers, key ) ->
    url = apiRoot .. endPoint
    overrides =
        :params
        authToken: key
        headers:
            Accept: "application/json"

    success, body, status = await NP.http.request method, url, overrides
    data = util.JSONToTable body

    statusType = math.floor status/100

    if statusType == 5
        paramStr = table.ToString params, "Parameters", true
        logger\fatal "Database exception for #{method} - #{endPoint}.\n#{paramStr}\nBody: #{\n#{body}" if logger
        reject { databaseError: body }

    unless data
        paramStr = table.ToString params, "Parameters", true
        logger\fatal "Invalid JSON for #{method} - #{endPoint}.\n#{paramStr}\nBody: #{\n#{body}" if logger
        reject { databaseError: "Invalid JSON:\n#{body}" }

    unless success
        k, v = next data.errors
        reject v

    data

cfcFactions.api.post = ( endpoint, params ) ->
    cfcFactions.api.request "POST", endpoint, params

cfcFactions.api.get = ( endpoint ) ->
    cfcFactions.api.request endpoint

cfcFactions.api.delete = ( endpoint, params ) ->
    cfcFactions.api.request "DELETE", endpoint, params

cfcFactions.api.patch = ( endpoint, params ) ->
    cfcFactions.api.request "PATCH", endpoint, params

cfcFactions.api.GetFactions = ( page ) ->
    endpoint = paths.FACTIONS_ENDPOINT
    -- TODO: Page stuff
    --endpoint = "#{endpoint}?page=#{page}" if page

    -- returns getResult.data, as return structure for api is strange
    ( cfcFactions.api.get endpoint )\next ( data ) -> data.data

cfcFactions.api.GetFaction = ( id ) ->
    endpoint = "#{paths.FACTIONS_ENDPOINT}/#{cfcFactions.api.handleIds id}"

    cfcFactions.api.get endpoint

cfcFactions.api.GetPlayers = ( page ) ->
    endpoint = paths.PLAYERS_ENDPOINT
    -- TODO: Page stuff
    --endpoint = "#{endpoint}?page=#{page}" if page

    -- returns getResult.data, as return structure for api is strange
    ( cfcFactions.api.get endpoint )\next ( data ) -> data.data

cfcFactions.api.GetPlayer = ( id ) ->
    endpoint = "#{paths.PLAYERS_ENDPOINT}/#{cfcFactions.api.handleIds id}"

    cfcFactions.api.get endpoint

cfcFactions.api.GetPlayerBySteamID64 = ( steamID ) ->
    endpoint = paths.PLAYERS_FIND_ENDPOINT
    params =
        steam_id: steamID

    cfcFactions.api.post endpoint, { players: params }