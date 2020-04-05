cfcFactions.Factions or= {}
factions = cfcFactions.Factions

logger = cfcFactions.logger

factions.CreateFaction = async ( owner, name, color, description, inviteonly, temporary ) ->
	ownerSteamID = owner\SteamID64!
	ownerName = owner\Nick!

	print inviteonly, temporary

	factionPromise = cfcFactions.api.CreateFaction name, color, description, ownerSteamID, inviteonly, temporary
	factionData = await factionPromise, AwaitTypes.PROPAGATE

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
