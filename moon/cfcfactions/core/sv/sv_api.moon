cfcFactions.api or= {}

constants = cfcFactions.constants
logger = cfcFactions.logger

apiRoot = constants.BACKEND_ROOT
apiKey = "" -- TODO: Read API Key from file0.

parseErrors = ( data ) ->
	_, errors = next data
	out = ""
	for field, fieldErrors in pairs errors
		errStr = fieldErrors
		if ( type fieldErrors ) == "table"
			errStr = table.concat fieldErrors, ", "

		out ..= "#{field}: #{errStr};"
	out

authenticatedRequest = async ( method="GET", endPoint, params, headers ) ->
	url = apiRoot .. endPoint
	overrides =
	    body: util.TableToJSON params
	    authToken: apiKey

	success, body, status = await NP.http.request method, url, overrides
	data = util.JSONToTable body

    statusType = math.floor status/100

    if statusType == 5
        paramStr = table.ToString params, "Parameters", true
        logger\fatal "Database exception for #{method} - #{endPoint}.\n#{paramStr}\nBody: #{\n#{body}"
        reject { databaseError: body }

	unless data
        paramStr = table.ToString params, "Parameters", true
        logger\fatal "Invalid JSON for #{method} - #{endPoint}.\n#{paramStr}\nBody: #{\n#{body}"
        reject { databaseError: "Invalid JSON:\n#{body}" }

	unless success
        k, v = next data.errors
		reject v --logger\fatal "#{status} => #{parseErrors data.errors}"

	data

authenticatedPost = ( endpoint, params ) ->
    authenticatedRequest "POST", endpoint, params

authenticatedDelete = ( endpoint, params ) ->
    authenticatedRequest "DELETE", endpoint, params

authenticatedPatch = ( endpoint, params ) ->
    authenticatedRequest "PATCH", endpoint, params

handleIds = ( ids ) ->
    if ( type ids ) ~= "table"
        ids = { ids }
    table.concat ( ids or {} ), ","

cfcFactions.api.CreatePlayer = ( steamId, mostRecentName ) ->
    endpoint = constants.PLAYERS_ENDPOINT
    params =
        steam_id: steamId
        most_recent_name: mostRecentName
        last_online: os.time!

    authenticatedPost endpoint, { players: params }

cfcFactions.api.CreateFaction = ( name, color, description, creatorSteamId, private, temp ) ->
    endpoint = constants.FACTIONS_ENDPOINT
    params =
        name: name
        color: color
        description: description
        creator_steam_id: creatorSteamId
        private: private
        temporary: temp

    authenticatedPost endpoint, { faction: params }

cfcFactions.api.DestroyFaction = ( id ) ->
    endpoint = "#{constants.FACTIONS_ENDPOINT}/#{handleIds id}"

    authenticatedDelete endpoint

cfcFactions.api.UpdateFaction = ( id, params ) ->
    endpoint = "#{constants.FACTIONS_ENDPOINT}/#{handleIds id}"

    authenticatedPatch endpoint, { faction: params }

cfcFactions.api.GetFactions = ( page ) ->
    endpoint = constants.FACTIONS_ENDPOINT
    endpoint = "#{endpoint}?page=#{page}" if page

    authenticatedRequest endpoint

cfcFactions.api.GetFaction = ( id ) ->
    endpoint = "#{constants.FACTIONS_ENDPOINT}/#{handleIds id}"

    authenticatedRequest endpoint

cfcFactions.api.GetPlayers = ( page ) ->
    endpoint = constants.PLAYERS_ENDPOINT
    endpoint = "#{endpoint}?page=#{page}" if page

    authenticatedRequest endpoint

cfcFactions.api.GetPlayer = ( id ) ->
    endpoint = "#{constants.PLAYERS_ENDPOINT}/#{handleIds id}" 

    authenticatedRequest endpoint

cfcFactions.api.GetPlayerBySteamID64 = ( steamID ) ->
    endpoint = constants.PLAYERS_FIND_ENDPOINT
    params =
        steam_id: steamID

    authenticatedPost endpoint, { players: params }

cfcFactions.api.UpdatePlayer = ( id, params ) ->
    endpoint = "#{constants.PLAYERS_ENDPOINT}/#{handleIds id}" 

    authenticatedPatch endpoint, { players: params }
