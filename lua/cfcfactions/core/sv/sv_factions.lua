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

-- Instead of generating a random ID, we'll just fetch total factions + 1
local function GenerateID()
    -- In the future, grab factions from DB and increment by 1 for total factions
    return #cfcFactions.Factions + 1
end

-- function cfcFactions:CreateFaction( owner, name, color, description, inviteOnly, temporary )
function cfcFactions:Faction( id )
    return cfcFactions.Factions[id]
end

function cfcFactions:CreateFaction( ply, name, color, description, inviteonly, temporary )
    if not IsValid( ply ) then
        return
    end
    -- change to look up total_factions = total_factions + 1
    local TmpUnqID = GenerateID()

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

    if type( factionColor ) ~= "Color" then
        -- Send Alert -> Not a valid ColorType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-table-type"], 1, factionOwner )
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

    -- UniqueName Check
    if not cfcFactions:isUniqueName( factionName ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["is-in-faction"], 1, factionOwner )
        return
    end

    if type( factionIsTemporary ) ~= "boolean" then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-bool-type"], 1, factionOwner )
        factionIsTemporary = false
    end

    -- Lets keep this short, no need for a book in a name or description.
    factionName = TrimStringSize( factionName, 25 )
    factionDescription = TrimStringSize( factionDescription, 255 )


    local CurrentTimeStamp = cfcFactions:TimeStamp()

    -- TODO: Something is wrong with the IDs here. cfcFactions.Factions[TmpUnqID] is used to set it, but then it's retrieved with cfcFactions.Factions[PlayerIDStamp]

    local PlayerIDStamp = factionOwner:SteamID64()

    -- What should a faction contain?
    cfcFactions.Factions[TmpUnqID] = {
        ["Allies"] = {},
        ["Color"] = factionColor,
        ["Created"] = CurrentTimeStamp,
        ["Currency"] = 0,
        ["Deaths"] = 0,
        ["Description"] = factionDescription,
        ["Edited"] = CurrentTimeStamp,
        ["Enemies"] = {},
        ["ID"] = TmpUnqID,
        ["Invite"] = factionInviteOnly,
        ["Kills"] = 0,
        ["LastSaved"] = "",
        ["Name"] = factionName,
        ["NeedsCleanUp"] = false,
        ["Owner"] = PlayerIDStamp,
        ["Ranks"] = cfcFactions.fpm.defaultRanks,
        ["Temporary"] = factionIsTemporary
    }

    local FinalFaction = cfcFactions.Factions[PlayerIDStamp]

    factioneers:UpdateUser( PlayerIDStamp, FinalFaction.Created, FinalFaction.ID, 0, 0, "Leader" )
    -- [TODO] SQL: Save to database
    -- function cfcFactions:SaveFaction( factionid )
    -- function cfcFactions:SaveUser( userid )

    -- Let the owner of the faction know they successfully created the faction
    cfcFactions:SendNotifcation( string.format( "Successfully created \"%s\" with ID [%s]", FinalFaction.Name, FinalFaction.ID ), 1, PlayerIDStamp )

    net.Start( "CFC_Fac_FactionCreation" )
        -- private, name, description, owner, k/d, id
        net.WriteInt( FinalFaction.ID, 32 )
        net.WriteBool( FinalFaction.Invite )
        net.WriteString( FinalFaction.Name )
        net.WriteString( FinalFaction.Description )
        net.WriteString( FinalFaction.Owner )
        net.WriteColor( FinalFaction.Color )
    net.Broadcast()

    hook.Call( "CFC_Factionhook_FactionCreated", _, FinalFaction.Name, FinalFaction.Owner, FinalFaction.ID )

    --- Returns the newly created faction as a table
    return FinalFaction
end

-- Checks a specifc string to see if it is unique amongst other factions.
function cfcFactions:isUniqueName( faction_name )
    -- TODO: Change to check this on SQL side, not server!
    for k, v in pairs( cfcFactions.Factions ) do
        if string.lower( string.Trim( v.Name ) ) == string.lower( string.Trim( faction_name ) ) then
            return false
        end
    end

    return true
end


-- REWORK
function cfcFactions:IsValidFaction( tbl )
    if ( not tbl ) and ( table.IsEmpty( tbl ) ) then
        return false
    end

    return true
end

function cfcFactions:SetAlly( id, ally )

end

function cfcFactions:SetEnemy( id, enemy )

end

function cfcFactions:RemoveAlly( id, ally )

end

function cfcFactions:RemoveEnemy( id, enemy )

end

-- Edits a faction based on ID, player is who ever is editing it
function cfcFactions:EditFaction( id, name, description, color, private, temporary  )
    local ErrorsToReturn = {}
    local EditingFaction = cfcFactions.Factions[id]
    ----------------
    --[type checks]
    ----------------

    -- Note: Since moving functions permission and type checking out to a net Receiver
    -- We cannot do anything with "Players" nor send a player message from here

    -- Solution: this function will return a value on success or failure, if failure, the outer
    -- receiver can handle what to do

    -- if not type( util.GetBySteamID64( tbl.Owner ) ) == "Player" then
    --     -- Send Alert -> Not a valid PlayerType

    --     cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-ply-type"], 1, nil )
    --     owner = player.GetBySteamID64( Faction.Owner )
    -- end

    local EditName = name
    local EditDescription = description
    local EditColor = color
    local EditPrivate = private
    local EditTemporary = temporary

    if table.IsEmpty( EditingFaction ) or not cfcFactions:IsValidFaction( EditingFaction ) then
        table.insert( ErrorsToReturn, "404-faction" )
    end

    if type( EditName ) ~= "string" then
        table.insert( ErrorsToReturn, "invalid-string-type" )
    end

    if type( EditDescription ) ~= "string" then
        table.insert( ErrorsToReturn, "invalid-string-type" )
    end

    if type( EditColor ) ~= "Color" then
        table.insert( ErrorsToReturn, "invalid-table-type" )
    end

    if type( EditPrivate ) ~= "boolean" then
        table.insert( ErrorsToReturn, "invalid-bool-type" )
    end

    if type( EditTemporary ) ~= "string" then
        table.insert( ErrorsToReturn, "invalid-string-type" )
    end

    EditName = TrimStringSize( EditName, 25 )
    EditDescription = TrimStringSize( EditDescription, 255 )

    -- Finish up and ether edit, or return the errors
    if table.Count( ErrorsToReturn > 0 ) then
        return ErrorsToReturn
    end

    -- Take whatever values are in tbl, and put them into the main faction's table.
    -- Honestly, not sure about this but for now, it works
    EditingFaction.Name = EditName
    EditingFaction.Description = EditDescription
    EditingFaction.Color = EditColor
    EditingFaction.Invite = EditPrivate
    EditingFaction.Temporary = EditTemporary

    hook.Call( "CFC_Factionhook_FactionEdited" )


    -- TODO! be sure to call save to database as well


    net.Start( "CFC_Fac_FactionChanged" )
        net.WriteInt( id, 32 )
        net.WriteString( EditingFaction.EditName )
        net.WriteString( EditingFaction.EditDescription )
        net.WriteColor( EditingFaction.Color )
        net.WriteBool( EditingFaction.Invite )
        net.WriteBool( EditingFaction.Temporary )
    net.Broadcast()

    return {}
end

local function requestFactionNews( len, ply )
    -- Look into a better way of sending faction news to client
    for k, v in pairs( string.Explode( "\n", cfcFactions:LoadNews() ) ) do
        net.Start( "CFC_Fac_SendNews" )
            net.WriteString( v .. "\n" )
            net.WriteString( ply:Nick() )
        net.Send( ply )
    end
end

net.Receive( "CFC_Fac_RequestNews", requestFactionNews )

-- When client submits a faction to create, we receive it here
local function RequestFactionCreation( len, ply )

    if ply and not IsValid( ply ) then return end
    -- Go through and make sure client sending has PROPER : SERVER SIDE
    -- Permissions. Client is sending data, treat them as idiots
    local fOwner = ply
    local fName = net.ReadString()
    local fDescription = net.ReadString()
    local fIsInviteOnly = net.ReadBool()
    local fIsTemporary = net.ReadBool()
    local fColorSelected = net.ReadColor()

    local PrebuiltFaction = {
        ["Owner"] = fOwner,
        ["Name"] = fName,
        ["Description"] = fDescription,
        ["Color"] = fColorSelected,
        ["Invite"] = fIsInviteOnly,
        ["Temporary"] = fIsTemporary
    }

    if ( not fpm:hasPermission( fOwner, "CanCreateFaction" ) ) and ( not fpm:hasPermission( fOwner, "AccessAll" ) ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["factions-ban"], 1, fOwner )
        return
    end

    if factioneers:IsInFaction( fOwner ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["is-in-faction"], 1, fOwner )
        return
    end

    cfcFactions:CreateFaction( PrebuiltFaction )
end

net.Receive( "CFC_Fac_RequestFactionSubmit", RequestFactionCreation )

--  Net Receiver to handle editing a player's faction
-- Both owners, and anyone who has permission, as well as admins can edit a faction.
local function RequestFactionDetails( len, ply )

    -- Check if user has proper permission to edit each part of a faction
    -- CanEditAll, CanEditDescription, CanEditName, CanEditColor, CanEditInvite

    if not IsValid( ply ) then
        return
    end

    local TmpOwner = ply
    local TmpID = net.ReadInt( 32 )
    local TmpName = net.ReadString()
    local TmpDescription = net.ReadString()
    local TmpTemporary = net.ReadBool()
    local TmpColor = net.ReadColor()
    local EditingFaction = cfcFactions.Factions[TmpID]

    -- We'll check if the player has the proper permission to edit each field.
    -- If they do not pass that AND the data submitted is not empty or nil, we'll tell them improper permission
    -- This way clients send only the data they think they need to edit a faction, if they try to sneak around it
    -- and submit data they do not have access to, we'll tell them they're missing the permission and not assign anything
    if not fpm:hasPermission( TmpOwner, "CanEditName" ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-name"], 1, TmpOwner )
        TmpName = EditingFaction.Name
    end

    if not fpm:hasPermission( TmpOwner, "CanEditColor" ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-color"], 1, TmpOwner )
        TmpColor = EditingFaction.Color
    end

    if not fpm:hasPermission( TmpOwner, "CanEditInvite" ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-invite"], 1, TmpOwner )
        TmpPrivate = EditingFaction.Invite
    end

    if not fpm:hasPermission( TmpOwner, "CanEditDescription" ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-descrption"], 1, TmpOwner )
        TmpDescription = EditingFaction.Description
    end

    -- Pass everything into the edit faction
    -- If editing returns a table, then errors occured
    local Results = cfcFactions:EditFaction( TmpID, TmpName, TmpDescription, TmpColor, TmpPrivate, TmpTemporary  )
    if table.Count( Results ) > 0   then
        local ErrorsToSend = "The following errors occured when editing faction: " .. table.ToString( Results, "Errors", false )
        cfcFactions:SendNotifcation( ErrorsToSend, 1, TmpOwner )
    end
end


net.Receive( "CFC_Fac_RequestFactionEdit", RequestFactionDetails )

-- Handles removing a faction and its attached users properly
-- player who initated the delete ( if there is one ), id of faction that was deleted
function cfcFactions:RemoveFaction( ply, id )
    -- delete the faction and any players inside that faction.

    local factionID = id
    local factionToDelete = cfcFactions:Faction( factionID )
    local factionIsInvalid = not factionToDelete or table.IsEmpty( factionToDelete )

    if factionIsInvalid then return end

    cfcFactions.Factions[factionID] = nil
    for _, Player in pairs( player.GetHumans() ) do
        if factioneers:IsInFaction( Player, factionID ) then
            factioneers:RemoveUser( Player )
        end
    end

    net.Start( "CFC_Fac_FactionDeleted" )
        net.WriteInt( factionID, 32 )
    net.Broadcast()
end

local function RequestFactionDeletion( len, ply )
    local FactionToDelete = net.ReadInt( 32 )
    if ply and not IsValid( ply ) then return end

    -- Need to check if player ( If NOT a admin, or NOT a dev ), is in the faction )
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
                cfcFactions:RemoveFaction( ply, FactionToDelete )
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

-- TODO: Delete this duplicate function definition
-- local function requestFactionNews( len, ply )
--     -- Look into a better way of sending faction news to client
--     for k, v in pairs( string.Explode( "\n", cfcFactions:LoadNews() ) ) do
--         net.Start( "CFC_Fac_SendNews" )
--             net.WriteString( v .. "\n" )
--             net.WriteString( ply:Nick() )
--         net.Send( ply )
--     end
-- end

