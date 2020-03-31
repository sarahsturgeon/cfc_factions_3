--[[
File Name: sv_factions.lua

Purpose: Core faction's functions to create, edit, and destory

Global Tables: cfcFactions.Factions
]]--
if not SERVER then return end

local fpm = cfcFactions.fpm
local factioneers = cfcFactions.Users

cfcFactions.Factions = cfcFactions.Factions or {}

local function TrimStringSize( str, max )
    local TemporaryString = str
    local MaxCharTrim = max and max > 0 or 32

    return #TemporaryString > MaxCharTrim and string.Trim( str ).sub( 1, MaxCharTrim ) or str
end

function cfcFactions:Faction( id )
    -- TODO: If the faction does not return anything, we'll get nil here. Correct behavior or something to change, perhaps an empty table?
    return cfcFactions.Factions[id]
end

function _CreateFaction( _, ply, name, color, description, inviteonly, temporary )
    if not IsValid( ply ) then
        return
    end

    local factionOwner = ply
    local factionName = name
    local factionColor = color
    local factionDescription = description
    local factionInviteOnly = inviteonly
    local factionIsTemporary = temporary

    ----------------
    --[type checks]
    ----------------
    if type( factionOwner ) ~= "Player" then
        -- Send Alert -> Not a valid PlayerType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-ply-type"], 1, nil )
        return
    end

    if type( factionName ) ~= "string" then
        -- Send Alert -> Not a valid NameType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, factionOwner )
        return
    end

    if type( factionColor ) ~= "string" then
        -- Send Alert -> Not a valid ColorType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, factionOwner )
        return
    end

    if type( factionDescription ) ~= "string" then
        -- Send Alert -> Not a valid DescriptionType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, factionOwner )
        return
    end

    if type( factionInviteOnly ) ~= "boolean" then
        -- Send Alert -> Not a valid IntType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-int-type"], 1, factionOwner )
        return
    end

    if not factionOwner:IsPlayer() or not IsValid( factionOwner ) then
        -- SendAlert -> Not a valid player
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["general-error"], 1, nil )
        return
    end

    if type( factionIsTemporary ) ~= "boolean" then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-bool-type"], 1, factionOwner )
        factionIsTemporary = false
    end

    local ownerSteamID = factionOwner:SteamID64()

    local success, factionData = await( cfcFactions.api:CreateFaction( factionName, factionColor, factionDescription, ownerSteamID ) )

    if not success then error( "Failed to create faction: " .. factionData ) end

    cfcFactions.Factions[factionData.id] = factionData
    factioneers:User( factionOwner ).faction_id = factionData.id

    -- Let the owner of the faction know they successfully created the faction
    cfcFactions:SendNotifcation( string.format( "Successfully created \"%s\" with ID [%s]", factionData.name, factionData.id ), 1, ownerSteamID )

    -- TODO: Send a notifcation to ALL other players ( not the owner ) that a new Faction, "%name" was created!
    -- TODO: Tell clients to pull from database again 

    -- hook.Call( "CFC_Factionhook_FactionCreated", _, factionData.name, factionData.Owner, factionData.ID )

    --- Returns the newly created faction as a table
    return factionData
end
cfcFactions.CreateFaction = async( _CreateFaction )

local function _CacheFaction( _, factionID )
    if cfcFactions.Factions[factionID] then
        return
    end

    local success, factionList = await( cfcFactions.api:GetFaction( factionID ) )
    if not success then
        return logger:fatal( "Failed to get faction" )
    end
    local factionData = factionList[1]

    cfcFactions.Factions[factionData.id] = factionData
end
cfcFactions.CacheFaction = _CacheFaction

-- TODO: Rework, potentially test types inside the table, and if anything is nil that shouldn't be.
function cfcFactions:IsValidFaction( tbl )
    return tbl and not table.IsEmpty( tbl )
end

-- Edits a faction based on ID, player is who ever is editing it
local function _UpdateFaction( _, id, data )
    local success, factionData = await( cfcFactions.api:UpdateFaction( id, data ) )

    cfcFactions.Factions[factionData.id] = factionData

    hook.Call( "CFC_Factionhook_FactionEdited" )

    -- TODO: Tell clients to pull from database again 

    return factionData
end
cfcFactions.UpdateFaction = _UpdateFaction

-- -- When client submits a faction to create, we receive it here. This is a net side, we'll check perms here but not valid types ( We probably should )
-- local function RequestFactionCreation( len, ply )

--     if ply and not IsValid( ply ) then return end
--     -- Go through and make sure client sending has PROPER : SERVER SIDE
--     -- Permissions. Client is sending data, treat them as idiots
--     local fOwner = ply
--     local fName = net.ReadString()
--     local fDescription = net.ReadString()
--     local fIsInviteOnly = net.ReadBool()
--     local fIsTemporary = net.ReadBool()
--     local fColorSelected = net.ReadColor()

--     local PrebuiltFaction = {
--         ["Owner"] = fOwner,
--         ["Name"] = fName,
--         ["Description"] = fDescription,
--         ["Color"] = fColorSelected,
--         ["Invite"] = fIsInviteOnly,
--         ["Temporary"] = fIsTemporary
--     }

--     if not fpm:hasPermission( fOwner, "CanCreateFaction" ) then
--         cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["factions-ban"], 1, fOwner )
--         return
--     end

--     if factioneers:IsInFaction( fOwner ) then
--         cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["is-in-faction"], 1, fOwner )
--         return
--     end

--     cfcFactions:CreateFaction( PrebuiltFaction )
-- end

-- net.Receive( "CFC_Fac_RequestFactionSubmit", RequestFactionCreation )

local function RequestFactionCreation( ply, fName, fDescription, fPrivate, fColor )
    local fOwner = ply

    if not fpm:hasPermission( fOwner, "CanCreateFaction" ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["factions-ban"], 1, fOwner )
        error( "Do not have permission to create a faction" )
    end

    if factioneers:IsInFaction( fOwner ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["is-in-faction"], 1, fOwner )
        error( "Already a member of a faction" )
    end

    return cfcFactions:CreateFaction( fOwner, fName, fColor, fDescription, fPrivate, false )
end

NP.net.receive( "CFC_Fac_RequestFactionSubmit", async( RequestFactionCreation ) )

-- -- Net Receiver to handle editing a player's faction
-- -- Both owners, and anyone who has permission, as well as admins can edit a faction.
-- local function RequestFactionDetails( len, ply )

--     -- Check if user has proper permission to edit each part of a faction
--     -- CanEditAll, CanEditDescription, CanEditName, CanEditColor, CanEditInvite

--     if not IsValid( ply ) then
--         return
--     end

--     local TmpOwner = ply
--     local TmpID = net.ReadInt( 32 )
--     local TmpName = net.ReadString()
--     local TmpDescription = net.ReadString()
--     local TmpTemporary = net.ReadBool()
--     local TmpColor = net.ReadColor()
--     local EditingFaction = cfcFactions.Factions[TmpID]

--     -- We'll check if the player has the proper permission to edit each field.
--     -- If they do not pass that AND the data submitted is not empty or nil, we'll tell them improper permission
--     -- This way clients send only the data they think they need to edit a faction, if they try to sneak around it
--     -- and submit data they do not have access to, we'll tell them they're missing the permission and not assign anything

--     -- TODO: We should eventually do the notifcation system here to return a table of all error message keys that were triggered, then
--     -- send that small table all at once saying "Hey, you can't edit the name, color, and invite"
--     if not fpm:hasPermission( TmpOwner, "CanEditName" ) then
--         cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-name"], 1, TmpOwner )
--         TmpName = EditingFaction.Name
--     end

--     if not fpm:hasPermission( TmpOwner, "CanEditColor" ) then
--         cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-color"], 1, TmpOwner )
--         TmpColor = EditingFaction.Color
--     end

--     if not fpm:hasPermission( TmpOwner, "CanEditInvite" ) then
--         cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-invite"], 1, TmpOwner )
--         TmpPrivate = EditingFaction.Invite
--     end

--     if not fpm:hasPermission( TmpOwner, "CanEditDescription" ) then
--         cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-descrption"], 1, TmpOwner )
--         TmpDescription = EditingFaction.Description
--     end

--     -- Pass everything into the edit faction
--     -- If editing returns a table, then errors occured
--     local Results = cfcFactions:EditFaction( TmpID, TmpName, TmpDescription, TmpColor, TmpPrivate, TmpTemporary  )
--     if table.Count( Results ) > 0   then
--         local ErrorsToSend = "The following errors occured when editing faction: " .. table.ToString( Results, "Errors", false )
--         cfcFactions:SendNotifcation( ErrorsToSend, 1, TmpOwner )
--     end
-- end


-- net.Receive( "CFC_Fac_RequestFactionEdit", RequestFactionDetails )

-- Handles removing a faction and its attached users properly
-- player who initated the delete ( if there is one ), id of faction that was deleted
function cfcFactions:RemoveFaction( id )
    -- delete the faction and any players inside that faction.

    local factionID = id

    cfcFactions.Factions[factionID] = nil
    for _, ply in pairs( player.GetHumans() ) do
        if factioneers:IsInFaction( ply, factionID ) then
            factioneers:ClearFaction( ply )
        end
    end

    local success, data = await( cfcFactions.api:RemoveFaction( id ) )

    if not success then
        return logger:fatal( "Failed to remove faction: " .. data )
    end
end

local function RequestFactionDeletion( len, ply )
    local FactionToDelete = net.ReadInt( 32 )
    if ply and not IsValid( ply ) then return end

    -- Need to check if player ( If NOT an admin, or NOT a dev ), is in the faction )
    if fpm:IsFactionAdmin( ply ) or fpm:IsDev( ply ) then
        cfcFactions:RemoveFaction( ply, FactionToDelete )
        -- allow them to delete the faction no matter what
        -- untested for now
        return
    end

    if ply:IsInFaction( FactionToDelete ) then
        ErrorNoHalt( "Needs Testing", "RequestFactionDeletion( len, ply )" )

        if fpm:hasPermission( ply, "CanDisbandFaction" ) then
            local factionExists = cfcFactions:Faction( FactionToDelete ) ~= nil
            local playerOwnsFaction = FactionToDelete.Owner == ply:SteamID64()

            if factionExists and playerOwnsFaction then
                cfcFactions:RemoveFaction( FactionToDelete )
            end
        end
        -- Check if player has proper permission to delete the faction
        -- aka, owner
        return
    end

    -- Tell the player they cannot delete the great infinite void of nothingness
    cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["faction-delete-fail"], 1, TmpOwner )
end
net.Receive( "CFC_Fac_RequestDelete", RequestFactionDeletion )
