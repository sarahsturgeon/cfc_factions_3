import concat, Copy, map, ToString from table
import JSONToTable from util

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
            errStr = concat fieldErrors, ", "

        out ..= "#{field}: #{errStr};"
    out

cfcFactions.api.handleIds = ( ids ) ->
    if ( type ids ) ~= "table"
        ids = { ids }
    if #ids == 0
        ids = { -1 }
    concat ids, ","

cfcFactions.api.request = async ( method="GET", endPoint, params, headers, key ) ->
    url = apiRoot .. endPoint
    overrides =
        :params
        authToken: key
        headers:
            Accept: "application/json"

    success, responseBody, status, headers = await NP.http.request method, url, overrides
    body = JSONToTable responseBody

    statusType = math.floor status/100

    -- Non json returned, absolute catastrophe
    unless body
        if logger
            paramStr = ToString params, "Parameters", true
            errorMessage = {
                "Invalid JSON for #{method} - #{url}"
                paramStr
                "Body:"
                responseBody
            }

            errorMessage = concat errorMessage, "\n"

            logger\fatal errorMessage

        reject { databaseError: "Invalid JSON:\n#{responseBody}" }

    :data = body

    -- Internal error
    if statusType == 5 or not data
        -- Change to data.errors
        exceptionData = body
        if logger
            dataCopy = Copy exceptionData

            paramStr = ToString params, "Parameters", true
            exception = dataCopy.exception
            dataCopy.traces = map dataCopy.traces, table.head
            dataCopy.exception = nil
            bodyStr = ToString dataCopy, "Body", true

            errorMessage = {
                "Database exception for #{method} - #{url}."
                url
                exception
                paramStr
                bodyStr
            }
            errorMessage = concat errorMessage, "\n"

            logger\fatal errorMessage

        reject { databaseError: exceptionData }

    unless success
        k, v = next data.errors
        reject v

    body.data = nil

    data, headers, body

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
