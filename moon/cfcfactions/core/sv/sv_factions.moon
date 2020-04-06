cfcFactions.Factions or= {}
factions = cfcFactions.Factions

logger = cfcFactions.logger

factions.CreateFaction = async ( owner, name, color, description, inviteonly, temporary ) ->
	ownerSteamID = owner\SteamID64!
	ownerName = owner\Nick!

	success, factionData = await cfcFactions.api.CreateFaction name, color, description, ownerSteamID, inviteonly, temporary
	unless success
		reject createFactionError: factionData

	logger\info "#{ownerName} created a faction: #{name}"

	return factionData

cfcFactions.net.RegisterResponse "CreateFaction", {
	{ 
		type: "string" 
		name: "name"
		minLength: 3
		maxLength: 50
	}, 
	{
		type: "colorstring"
		name: "color"
		hasAlpha: false
	},
	{
		type: "string"
		name: "description"
		maxLength: 255
	},
	{
		type: "boolean"
		name: "private"
	},
	{
		type: "boolean"
		name: "temporary"
	}
}, {}, factions.CreateFaction

factions.DeleteFaction = async ( ply, id ) ->
	plyName = ply\Nick!

	success, data = await cfcFactions.api.DeleteFaction id

	unless success
		reject deleteFactionError: data

	logger\info "#{plyName} deleted a faction: #{id}"

	return true

cfcFactions.net.RegisterResponse "DeleteFaction", {
	{ 
		type: "string" 
		name: "id"
	}
}, {
	"CanDelete"
}, factions.DeleteFaction