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
    if #ids == 0
        ids = { -1 }
    table.concat ids, ","

cfcFactions.api.request = async ( method="GET", endPoint, params, headers, key ) ->
    url = apiRoot .. endPoint
    overrides =
        :params
        authToken: key
        headers:
            Accept: "application/json"

    success, body, status, headers = await NP.http.request method, url, overrides
    data = util.JSONToTable body

    statusType = math.floor status/100

    unless data
        if logger
            paramStr = table.ToString params, "Parameters", true
            logger\fatal "Invalid JSON for #{method} - #{url}.\n#{paramStr}\nBody: #{\n#{body}"
        reject { databaseError: "Invalid JSON:\n#{body}" }

    if statusType == 5
        if logger
            dataCopy = table.Copy data

            paramStr = table.ToString params, "Parameters", true
            exception = dataCopy.exception
            dataCopy.traces = table.map dataCopy.traces, table.head
            dataCopy.exception = nil
            bodyStr = table.ToString dataCopy, "Body", true
            logger\fatal "Database exception for #{method} - #{url}.\n#{exception}\n#{paramStr}\n#{bodyStr}"
        reject { databaseError: data }

    unless success
        k, v = next data.errors
        reject v

    data, headers

cfcFactions.api.post = ( endpoint, params ) ->
    cfcFactions.api.request "POST", endpoint, params

cfcFactions.api.get = ( endpoint ) ->
    cfcFactions.api.request "GET", endpoint

cfcFactions.api.delete = ( endpoint, params ) ->
    cfcFactions.api.request "DELETE", endpoint, params

cfcFactions.api.patch = ( endpoint, params ) ->
    cfcFactions.api.request "PATCH", endpoint, params

cfcFactions.api.GetFactions = ( page, pageCount ) ->
    endpoint = paths.FACTIONS_ENDPOINT
    endpoint = "#{endpoint}?page=#{page}" if page
    endpoint = "#{endpoint}&items=#{pageCount}" if pageCount

    cfcFactions.api.get endpoint

cfcFactions.api.GetFaction = ( id ) ->
    endpoint = "#{paths.FACTIONS_ENDPOINT}/#{cfcFactions.api.handleIds id}"

    cfcFactions.api.get endpoint

cfcFactions.api.GetPlayers = ( page, pageCount ) ->
    endpoint = paths.PLAYERS_ENDPOINT
    endpoint = "#{endpoint}?page=#{page}" if page
    endpoint = "#{endpoint}&items=#{pageCount}" if pageCount

    cfcFactions.api.get endpoint

cfcFactions.api.GetPlayer = ( id ) ->
    endpoint = "#{paths.PLAYERS_ENDPOINT}/#{cfcFactions.api.handleIds id}"

    cfcFactions.api.get endpoint

cfcFactions.api.GetPlayerBySteamID64 = ( steamID ) ->
    endpoint = paths.PLAYERS_FIND_ENDPOINT
    params =
        steam_id: steamID

    cfcFactions.api.post endpoint, { players: params }