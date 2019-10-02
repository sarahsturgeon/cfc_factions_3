--[[]
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
local cfcuser = cfcFactions.Users 

cfcFactions.Factions = cfcFactions.Factions or {}

function cfcFactions:CreateFaction( owner, name, color, description, inviteOnly, temporary )
    local TmpUnqID = cfcFactions:UUID()
    local factionOwner = owner
    local factionName = name
    local factionColor = color
    local factionDescription = description
    local factionInviteOnly = inviteOnly
    local factionIsTemporary = temporary

    if nil then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["generalError"], 1, nil )
    end

    ----------------
    --[type checks]
    ----------------
    if not type( factionOwner ) == "Player" then
        --Send Alert -> Not a valid PlayerType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-ply-type"], 1, nil )
        return
    end

    if not type( factionName ) == "string" then
        --Send Alert -> Not a valid NameType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, owner )
        return
    end

    if not type( factionColor ) == "Color" then
        --Send Alert -> Not a valid ColorType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-table-type"], 1, owner )
        return
    end

    if not type( factionDescription ) == "string" then
        --Send Alert -> Not a valid DescriptionType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, owner )
        return
    end

    if not type( factionInviteOnly ) == "boolean" then
        --Send Alert -> Not a valid IntType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-int-type"], 1, owner )
        return
    end

    if not factionOwner:IsPlayer() or not IsValid( factionOwner ) then
        --SendAlert -> Not a valid player
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["general-error"], 1, nil )
        return
    end

    --[Permissions]
    if not fpm:hasPermission( factionOwner, "CanCreateFaction" ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["faction-ban"], 1, owner )
        --TODO: make return here
        --return
    end

    --IsInFaction Check
    if cfcuser:IsInFaction( factionOwner ) == true then 
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["is-in-faction"], 1, Owner )
        return 
    end

    --UniqueName Check
    if not cfcFactions:isUniqueName( factionName ) then 
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["is-in-faction"], 1, owner )
        return
    end

    if not type( factionIsTemporary ) == "boolean" then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-int-type"], 1, owner )
        factionIsTemporary = false
    end

    --What should a faction contain? 
    cfcFactions.Factions[TmpUnqID] = {
        ["ID"] = TmpUnqID,
        ["Name"] = factionName,
        ["Ranks"] = cfcFactions.fpm.defaultRanks,
        ["Owner"] = factionOwner:SteamID64(),
        ["Description"] = factionDescription,
        ["Color"] = factionColor,
        ["Invite"] = factionInviteOnly,
        ["Kills"] = 0,
        ["Deaths"] = 0,
        ["Currency"] = 0,
        ["Created"] = cfcFactions:TimeStamp(),
        ["Edited"] = cfcFactions:TimeStamp(),
        ["LastSaved"] = "",
        ["NeedsCleanUp"] = false,
        ["Allies"] = {},
        ["Enemies"] = {}
    }

    cfcuser:registeruser( factionOwner, factionid, "Leader" )

    --SQL: Save to database
    --function cfcFactions:SaveFaction( factionid )
    --function cfcFactions:SaveUser( userid )

    --Let the owner of the faction know they successfully created the faction
    cfcFactions:SendNotifcation( string.format( "Successfully created \"%s\" with ID [%s]", cfcFactions.Factions[TmpUnqID].Name, cfcFactions.Factions[TmpUnqID].ID ), 1, owner )

    --Tell clients a new faction was created
    --Package the table and send to clients
    local CopyOfFactionToSend = table.Copy( cfcFactions.Factions[TmpUnqID] )
    --Some details should be omitted before sending, so we'll create a copy of the table and remove as needed 
    CopyOfFactionToSend.LastSaved = nil
    CopyOfFactionToSend.NeedsCleanUp = nil
  
    local FactionTableJsonified = util.TableToJSON( CopyOfFactionToSend, false ) 
  
    net.Start( "CFC_Fac_SendFactionSubmit" )
        net.WriteString( FactionTableJsonified )
    net.Broadcast()

    ---Returns the newly created faction as a table
    return cfcFactions.Factions[TmpUnqID]
end

--Checks a specifc string to see if it is unique amongst other factions.
function cfcFactions:isUniqueName( faction_name )
    for k, v in pairs( cfcFactions.Factions ) do
        if string.lower( string.Trim( v.Name ) ) == string.lower( string.Trim( faction_name ) ) then
            return false
        end
    end
    return true
end

function cfcFactions:IsValidFaction( id )
    if cfcFactions.Factions[id] == nil then return false end
    return true
end

function cfcFactions:SetAlly( id )

end

function cfcFactions:SetEnemy( id )

end

function cfcFactions:RemoveAlly( id )

end

function cfcFactions:RemoveEnemy( id )

end

--Edits a faction based on ID, player is who ever is editing it
function cfcFactions:EditFaction( id, name, color, description, inviteOnly, player )

    ----------------
    --[type checks]
    ----------------
    if not cfcFactions:IsValidFaction( id ) then
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["404-faction"], 1, player )
        return false
    end

    if not type( player ) == "Player" then
        --Send Alert -> Not a valid PlayerType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-ply-type"], 1, nil )
        return false
    end

    if not type( name ) == "string" then
        --Send Alert -> Not a valid NameType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, player )
        return false
    end

    if not type( color ) == "Color" then
        --Send Alert -> Not a valid ColorType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-table-type"], 1, player )
        return false
    end

    if not type( description ) == "string" then
        --Send Alert -> Not a valid DescriptionType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-string-type"], 1, player )
        return false
    end

    if not type( inviteOnly ) == "boolean" then
        --Send Alert -> Not a valid IntType
        cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["invalid-int-type"], 1, player )
        return false
    end

    --Check if user has proper permission to edit each part of a faction
    --CanEditAll, CanEditDescription, CanEditName, CanEditColor, CanEditInvite
    local faction = cfcFactions.Factions[id]
    --if IsAdmin or IsDeveloper, allow freely edit of a faction
    if fpm:IsDeveloper( player ) or fpm:IsFactionAdmin( player ) or fpm:hasPermission( player, "CanEditAll" ) then
        faction.Name = name
        faction.Description = description
        faction.Color = color
        faction.Invite = inviteOnly
        return true

    else
        --We'll check if the player has the proper permission to edit each field. 
        --If they do not pass that AND the data submitted is not empty or nil, we'll tell them improper permission
        --This way clients send only the data they think they need to edit a faction, if they try to sneak around it
        --and submit data they do not have access to, we'll tell them they're missing the permission and not assign anything
        if fpm:hasPermission( player, "CanEditName" ) then
            faction.Name = name
        else
            if ( ( name and #name > 0 ) or name == nil ) then
                cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-name"], 1, owner )
            end
        end

        if fpm:hasPermission( player, "CanEditColor" ) then
            faction.Color = color
        else
            if ( ( not table.IsEmpty( color ) ) or color == nil ) then
                cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-color"], 1, owner )
            end
        end

        if fpm:hasPermission( player, "CanEditInvite" ) then
            faction.Invite = inviteOnly
        else
            if ( not ( inviteOnly == nil ) ) then
                cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-invite"], 1, owner )
            end
        end

        if fpm:hasPermission( player, "CanEditDescription" ) then
            faction.Description = description
        else
            if ( ( description and #description > 0 ) or description == nil ) then
                cfcFactions:SendNotifcation( cfcFactions.ErrorMessages["no-permission-descrption"], 1, owner )
            end
        end
    end

    --save to db

    --Broadcast change to players
end

--Handles removing a faction( s ) and its attached users properly
function cfcFactions:RemoveFaction( ply, id )
    if fpm:IsDev( ply ) then
        if cfcFactions.Factions[id] ~= nil then
            cfcFactions.Factions[id] = nil
            ply:SetFactionID( nil )
            ply:SetFactionRank( nil )
            --TODO: Remove all players too
        end
    end
end

local function requestFactionNews( len, ply )
    --Look into a better way of sending faction news to client
    for k, v in pairs( string.Explode( "\n", cfcFactions:LoadNews() ) ) do
        net.Start( "CFC_Fac_SendNews" )
            net.WriteString( v .. "\n" )
            net.WriteString( ply:Nick() )
        net.Send( ply )
    end
end

net.Receive( "CFC_Fac_RequestNews", requestFactionNews )

--When client submits a faction to create, we receive it here
local function RequestFactionCreation( len, ply )

    local fOwner = ply
    local fName = net.ReadString()
    local fDescription = net.ReadString()
    local fIsInviteOnly = net.ReadBool()
    local fIsTemporary = net.ReadBool()
    local fColorSelected = net.ReadColor()

    cfcFactions:CreateFaction( fOwner, fName, fColorSelected, fDescription, fIsInviteOnly, fIsTemporary )

end

net.Receive( "CFC_Fac_RequestFactionSubmit", RequestFactionCreation )

--If Requested, Send Faction details to client to edit 
local function SendFactionDetails( len, ply )


end
net.Receive( "CFC_Fac_RequestFactionEdit", SendFactionDetails )

