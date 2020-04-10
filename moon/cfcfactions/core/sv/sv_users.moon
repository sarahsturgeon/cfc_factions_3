cfcFactions.Users or= {}

users = cfcFactions.Users

logger = cfcFactions.logger

authUser = async ( ply ) ->
	return if ply\IsBot!

	steamID = ply\SteamID64!
	name = ply\Nick!
	local userData

	success, data = await cfcFactions.api.GetPlayerBySteamID64 steamID

	unless success
		logger\fatal "Player auth failed - Couldn't get player: #{table.ToString data, nil, true}"
		return


	if #data > 0
		userData = data[1]

        userData.most_recent_name = name
        userData.last_online = os.time!

		success, userData = await cfcFactions.api.UpdatePlayer userData.id, userData

		unless success
			logger\fatal "Player auth failed - Couldn't update player: #{table.ToString userData, nil, true}"
			return

		logger\info "Authenticated existing player: #{name} (#{userData.id})"
	else
		success, userData = await cfcFactions.api.CreatePlayer steamID, name

		unless success
			logger\fatal "Player auth failed - Couldn't create player: #{table.ToString userData, nil, true}"
			return

		logger\info "Authenticated new player: #{name} (#{userData.id})"

    ply\SetNWInt "CFC_DatabaseID", userData.id

hook.Add "PlayerInitialSpawn", "cfc_AuthUser", authUser