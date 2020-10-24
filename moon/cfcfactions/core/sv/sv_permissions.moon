import Add, HasValue, insert from table

cfcFactions.permissions or= {}
perms = cfcFactions.permissions

logger = cfcFactions.logger

perms.assertMany = async ( ply, targetFactionID, permissions, permissionTarget ) ->
    return if #permissions == 0

    permissions = table.Copy permissions
    errors = {}

    plys = { ply\GetFactionsID! }
    insert plys, permissionTarget\GetFactionsID! if permissionTarget

    success, playerData = await cfcFactions.api.GetPlayer plys

    unless success
        reject playerData

    if #playerData ~= #plys
        reject { permissionError: "Couldn't find players" }

    callerData = playerData[1]
    targetData = playerData[2]

    if targetFactionID and ( callerData.faction.id ~= targetFactionID )
        if ply\IsAdmin!
            return
        else
            reject { permissionError: "Not a member of this faction" }

    onPlayer = false

    for _, permData in pairs callerData.permissions
        if table.RemoveByValue permissions, permData.name
            if permData.is_targeted
                onPlayer = true

    for missingPerm in *permissions
        insert errors, "Missing #{missingPerm}"

    if onPlayer
        if targetData
            if callerData.faction.id ~= targetData.faction.id
                insert errors, "Target player not in same faction"
            elseif callerData.rank.power < targetData.rank.power
                insert errors, "Cannot target this player"
        else
            insert errors, "No target player specified"

    reject { permissionError: errors } if #errors > 0

perms.assert = ( ply, permission, permissionTarget ) ->
    perms.assertMany ply, { permission }, permissionTarget