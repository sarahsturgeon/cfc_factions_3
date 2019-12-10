--[[
File Name: sv_factions.lua

Purpose: Core faction's functions to create, edit, and destory

Global Tables: cfcFactions.Factions
]]--
if not SERVER then return end

local file = file
local table = table
local net = net
local util = util
local table = table
local fpm = cfcFactions.fpm
local cfg = cfcFactions.Config.Server
local factioneers = cfcFactions.Users

cfcFactions.Factions = cfcFactions.Factions or {}

-- Instead of generating a random ID, we'll just fetch total factions + 1
local function GenerateID()
    return ( ( #cfcFactions.Factions ) + 1 )
end

-- function cfcFactions:CreateFaction( owner, name, color, description, inviteOnly, temporary )
function cfcFactions:Faction( id ) 
    return cfcFactions.Factions[id]
end

function cfcFactions:CreateFaction( tbl )
    if not tbl and table.IsEmpty( tbl ) then
        return
    end
    local FactionTemporaryTable = tbl
    local TmpUnqID = GenerateID()
    local factionOwner = FactionTemporaryTable.Owner
    local factionName = FactionTemporaryTable.Name
    local factionColor = FactionTemporaryTable.Color
    local factionDescription = FactionTemporaryTable.Description
    local factionInviteOnly = FactionTemporaryTable.InviteOnly
    local factionIsTemporary = FactionTemporaryTable.Temporary

    ----------------
    --[type checks]
    ----------------
    if not type( factionOwner ) == "Player" then
        -- Send Alert -> Not a valid PlayerType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-ply-type"], 1, nil )
        return
    end

    if not type( factionName ) == "string" then
        -- Send Alert -> Not a valid NameType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, factionOwner )
        return
    end

    if not type( factionColor ) == "Color" then
        -- Send Alert -> Not a valid ColorType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-table-type"], 1, factionOwner )
        return
    end

    if not type( factionDescription ) == "string" then
        -- Send Alert -> Not a valid DescriptionType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, factionOwner )
        return
    end

    if not type( factionInviteOnly ) == "boolean" then
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

    if not type( factionIsTemporary ) == "boolean" then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-int-type"], 1, factionOwner )
        factionIsTemporary = false
    end


    local CurrentTimeStamp = cfcFactions:TimeStamp()
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
        ["Owner"] = factionOwner:SteamID64(),
        ["Ranks"] = cfcFactions.fpm.defaultRanks
    }
    local FinalFaction = cfcFactions.Factions[TmpUnqID]

    -- function factioneers:UpdateUser( user, lastonline, factionid, kills, deaths, factionrank )


    factioneers:UpdateUser( player.GetBySteamID64( FinalFaction.Owner ), FinalFaction.Created, FinalFaction.ID, 0, 0, "Leader" )
    -- SQL: Save to database
    -- function cfcFactions:SaveFaction( factionid )
    -- function cfcFactions:SaveUser( userid )

    -- Let the owner of the faction know they successfully created the faction
    cfcFactions:SendNotifcation( string.format( "Successfully created \"%s\" with ID [%s]", FinalFaction.Name, FinalFaction.ID ), 1, player.GetBySteamID64( FinalFaction.Owner ) )
    
    net.Start( "CFC_Fac_FactionCreation" )
        --private, name, description, owner, k/d, id
        net.WriteInt( FinalFaction.ID, 32 )
        net.WriteBool( FinalFaction.Invite )
        net.WriteString( FinalFaction.Name )
        net.WriteString( FinalFaction.Description )
        net.WriteString( FinalFaction.Owner )
        net.WriteInt( FinalFaction.Kills, 32 )
        net.WriteInt(  FinalFaction.Deaths, 32 )
    net.Broadcast()

    hook.Call( "CFC_Factionhook_FactionCreated", _, FinalFaction.Name, FinalFaction.Owner, FinalFaction.ID )

    --- Returns the newly created faction as a table
    return FinalFaction
end

-- Checks a specifc string to see if it is unique amongst other factions.
function cfcFactions:isUniqueName( faction_name )
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
    else
        return true
    end
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
function cfcFactions:EditFaction( tbl )
    ----------------
    --[type checks]
    ----------------
    if not cfcFactions:IsValidFaction( tbl ) or table.IsEmpty( tbl ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["404-faction"], 1, owner )
        return
    end

    local owner
    if not type( util.GetBySteamID64( tbl.Owner ) ) == "Player" then
        -- Send Alert -> Not a valid PlayerType

        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-ply-type"], 1, nil )
        owner = player.GetBySteamID64( Faction.Owner )
    end

    -- Take whatever values are in tbl, and put them into the main faction's table.
    -- Honestly, not sure about this but for now, it works
    table.Merge( cfcFactions.Factions[tbl.ID], tbl )
    
    -- if not type( name ) == "string" then
    --     -- Send Alert -> Not a valid NameType
    --     cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, owner )
    --     return false
    -- end

    -- if not type( color ) == "Color" then
    --     -- Send Alert -> Not a valid ColorType
    --     cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-table-type"], 1, owner )
    --     return false
    -- end

    -- if not type( description ) == "string" then
    --     -- Send Alert -> Not a valid DescriptionType
    --     cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, owner )
    --     return false
    -- end

    -- if not type( inviteOnly ) == "boolean" then
    --     -- Send Alert -> Not a valid IntType
    --     cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-int-type"], 1, owner )
    --     return false
    -- end

    hook.Call( "CFC_Factionhook_FactionEdited" )

    ReplicateClientsideFaction( cfcFactions.Factions[tbl.ID], "MODIFIED" )
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

-- If Requested, Send Faction details to client to edit
-- local function RequestFactionDetails( len, ply )

--     -- Check if user has proper permission to edit each part of a faction
--     -- CanEditAll, CanEditDescription, CanEditName, CanEditColor, CanEditInvite
--     local faction = cfcFactions.Factions[id]
--     faction.Name = name
--     faction.Description = description
--     faction.Color = color
--     faction.Invite = inviteOnly

--     -- We'll check if the player has the proper permission to edit each field.
--     -- If they do not pass that AND the data submitted is not empty or nil, we'll tell them improper permission
--     -- This way clients send only the data they think they need to edit a faction, if they try to sneak around it
--     -- and submit data they do not have access to, we'll tell them they're missing the permission and not assign anything
--     if fpm:hasPermission( player, "CanEditName" ) then
--         faction.Name = name
--     else
--         if ( ( name and #name > 0 ) or name == nil ) then
--             cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-name"], 1, owner )
--         end
--     end

--     if fpm:hasPermission( player, "CanEditColor" ) then
--         faction.Color = color
--     else
--         if ( ( not table.IsEmpty( color ) ) or color == nil ) then
--             cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-color"], 1, owner )
--         end
--     end

--     if fpm:hasPermission( player, "CanEditInvite" ) then
--         faction.Invite = inviteOnly
--     else
--         if ( not ( inviteOnly == nil ) ) then
--             cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-invite"], 1, owner )
--         end
--     end

--     if fpm:hasPermission( owner, "CanEditDescription" ) then
--         faction.Description = description
--     else
--         if ( ( description and #description > 0 ) or description == nil ) then
--             cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-descrption"], 1, owner )
--         end
--     end
--     -- save to db

--     -- Broadcast change to players
-- end


-- net.Receive( "CFC_Fac_RequestFactionEdit", RequestFactionDetails )

-- Handles removing a faction and its attached users properly
-- player who initated the delete (if there is one), id of faction that was deleted
function cfcFactions:RemoveFaction( ply, id )
    -- delete the faction and any players inside that faction.

    local factionID = id
    local factionToDelete = cfcFactions:Faction( factionID )

     if factionToDelete and not table.IsEmpty( factionToDelete ) then
        cfcFactions.Factions[factionID] = nil
        for _, Player in pairs( player.GetHumans() ) do
            if factioneers:IsInFaction( Player, factionID ) then
                factioneers:RemoveUser( Player )
            end
        end
        net.Start("CFC_Fac_FactionDeleted")
            net.WriteInt(factionID, 32)
        net.Broadcast()
    end

end

local function RequestFactionDeletion(len, ply)

    local FactionToDelete = net.ReadInt(32)
    if ply and not IsValid( ply ) then return end
    --Need to check if player (If NOT a admin, or NOT a dev), is in the faction)
    if fpm:IsFactionAdmin( ply ) or fpm:IsDev( ply ) then
        cfcFactions:RemoveFaction( ply, FactionToDelete )
        --allow them to delete the faction no matter what
        --untested for now
    elseif ply:IsInFaction( FactionToDelete ) then
        --Can they even disband?
        ErrorNoHalt( "Needs Testing", "RequestFactionDeletion(len, ply)" )
        if fpm:hasPermission( ply, "CanDisbandFaction") then
            --Does the faction exist?
            if cfcFactions:Faction(FactionToDelete) ~= nil then 
                --Lastily, to prevent minging, is the faction owner the same player requesting the deletion?
                if cfcFactions:Faction(FactionToDelete.Owner == ply:SteamID64() ) then
                    --delete!
                    cfcFactions:RemoveFaction( ply, FactionToDelete )

                end
            end
        end
        --Check if player has proper permission to delete the faction
        --aka, owner
    else
        --Tell the player they cannot delete the great infinite void of nothingness
        ErrorNoHalt("Needs Finish", "RequestFactionDeletion(len, ply)" ) 
    end

end

net.Receive("CFC_Fac_RequestDelete", RequestFactionDeletion )

local function requestFactionNews( len, ply )
    -- Look into a better way of sending faction news to client
    for k, v in pairs( string.Explode( "\n", cfcFactions:LoadNews() ) ) do
        net.Start( "CFC_Fac_SendNews" )
            net.WriteString( v .. "\n" )
            net.WriteString( ply:Nick() )
        net.Send( ply )
    end
end

