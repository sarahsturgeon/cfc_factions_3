--[[
File Name: sh_sharedutils.lua

Purpose: Shared functions that contain various useful tables and functions used across cfcFactions

Global Tables: cfcFactions.Dermas, cfcFactions.Alerts, cfcFactions.ErrorMessages, cfcFactions.Credits

]]--

local net = net
local string = string
local table = table
cfcFactions.Credits = cfcFactions.Credits or {}
-- Sends a notifaction msg:string, mtype:number, player:entity

-- Table of anyone who wants credit in developing factions. Names are changed dynamically if they are on the SERVER
-- For extra effect, pull their name from their steam page directly.
cfcFactions.Credits.Developers = {
    ["STEAM_0:1:74678877"] = "Bleck",
    ["STEAM_0:1:39801724"] = "Decline",
    ["STEAM_0:1:77453431"] = "hmmm",
    ["STEAM_0:1:28482516"] = "iLikeYoBraids",
    ["STEAM_0:1:13693373"] = "Lego1042",
    ["STEAM_0:1:115301653"] = "Periapsis",
    ["STEAM_0:0:21170873"] = "Phatso",
    ["STEAM_0:1:28607710"] = "Voodoo"
}

-- If someone who helped code factions is on, change the hardcoded name to match their current display name ( steamid )
function cfcFactions.Credits:GenerateDeveloperNames()
    for KEY, ID in pairs( cfcFactions.Credits.Developers ) do

        for KEY2, PLAYER in pairs( player.GetHumans() ) do
            if KEY == PLAYER:SteamID() then
                print( "Changing " .. PLAYER:Nick() .. "'s name." )
                cfcFactions.Credits.Developers[KEY] = PLAYER:Nick()
            end
        end
    end
    return cfcFactions.Credits.Developers
end


cfcFactions.ErrorMessages = {
    ["general-error"]         = "An unknown error occured",
    ["invalid-ply-type"]      = "Not a valid PlayerType",
    ["invalid-string-type"]   = "Not a valid StringType",
    ["invalid-table-type"]    = "Not a valid TableType",
    ["invalid-int-type"]      = "Not a valid IntType",
    ["invalid-bool-type"]     = "Not a valid BoolType",
    ["is-in-faction"]         = "Already in a faction",
    ["factions-unavailable"]  = "Unable to create a faction right now",
    ["database-connect-fail"] = "Unable to connect to database.",
    ["kick-faction-fail"]     = "Cannot kick player not of same faction.",
    ["kick-perm-fail"]        = "Cannot kick player, incorrect permissions",
    ["edit-perm-fail"]        = "Cannot edit faction, you do not have this required permission. \"%s\"",
    ["global-pvp-enable"]     = "Cannot enable global pvp for this faction.",
    ["global-pvp-disable"]    = "Cannot disable global pvp for this faction.",
    ["404-faction"]           = "This faction does not exsist",
    ["404-ply"]               = "This player does not exsist",
    ["faction-create-fail"]   = "You cannot create any more factions",
    ["invite-is-in-faction"]  = "Player is already in a faction",
    ["invite-is-pending"]     = "Player already has a pending invite from this faction",
    ["is-admin"]              = "Player is an admin",
    ["is-user"]               = "Player is a user",
    ["is-developer"]          = "Player is a developer",
    ["is-tester"]             = "Player is a tester",
    ["is-gay"]                = "Cannot kick Phatso. The fuck?",
    ["depreciated-key"]       = "Deprecated key permission. Removing",
    ["factions-ban"]           = "Unable to use factions. Banned from using Factions.",
    ["contract-barred"]       = "Barred from creating contracts! Request an admin.",
    ["insufficient-funds"]    = "You lack the required funds to allow this contract.",
    ["excessive-kills"]       = "Too many kills requested. Set a lower number.",
    ["contract-accept-fail"]  = "Unable to accept contract",
    ["duplicate-name"]        = "Unable to create faction, duplicate name or too similar to exsisting faction name.",
    ["test-string"]           = "Test String, please ignore.",
    ["contract-ban"]          = "Unable to create contract. Barred from creating contracts",
    ["no-permission-edit"]    = "Unable to edit faction. Missing EditFaction permission.",
    ["no-permission-name"]    = "Unable to edit faction. Missing Editname permission.",
    ["no-permission-color"]   = "Unable to edit faction. Missing EditColor permission.",
    ["no-permission-invite"]  = "Unable to edit faction. Missing EditInvite permission.",
    ["faction-delete-fail"]   = "Unable to delete faction"
}

function cfcFactions:TimeStamp()
    return os.date( "%H:%M:%S - %d/%m/%Y", os.time() )
end

-- function cfcFactions:UUID()
--     local template ='xxxxxxxxxxxxxxxxxxxx'
--     return string.gsub( template, '[xy]', function ( c )
--         local v = ( c == 'x' ) and math.random( 0, 9 ) or math.random( 0, 9 )
--         return string.format( '%x', v )
--     end )
-- end

-- TODO: add "respond" option, enabled SendNotifcation to tell the user to respond to whatever alert is showing.
-- Sends a notifcation to an optional player
-- msg = string or predifined key hard coded above ( cfcFactions.ErrorMessages )
-- mtype = Number, Error being 1, Msg being 2, Alert being 3, Warning being 4
-- player to send the notifcation to. Optional
function cfcFactions:SendNotifcation( msg, mtype, player )

    if type( msg ) == "number" then
        msg = cfcFactions.ErrorMessages[msg] and cfcFactions.ErrorMessages[msg] or ""
    end

    if not IsValid( player ) then
        return
    end

    -- only 4 types of error types.
    if mtype == nil then mtype = 1 end
    if mtype > 4 then mtype = 1 end
    if mtype < 1 then mytype = 1 end

    if CLIENT then
        if #msg <= 256 then
            if not player:IsPlayer() then
                MsgN( msg, mtype )
                return
            end
            net.Start( "CFC_Fac_SendTextAlert" )
            net.WriteString( msg )
            net.WriteInt( mtype, 4 )
            if player:IsPlayer() then
                net.WriteEntity( player )
            else
                net.WriteEntity( nil )
            end
            net.SendToServer()
        end
    end

    if SERVER then
        if #msg <= 256 then
            if IsValid( player ) and player:IsPlayer() then
                net.Start( "CFC_Fac_SendServerTextAlert" )
                    net.WriteString( msg )
                    net.WriteInt( mtype, 4 )
                    net.WriteEntity( player )
                net.Send( player )
            else
                MsgN( msg )
            end
        end
    end
end


function cfcFactions.colorToInt( c )
    return bit.lshift( c.r, 16 ) + bit.lshift( c.g, 8 ) + c.b
end

function cfcFactions.intToColor( n )
    return Color(
        bit.band( bit.rshift( n, 16 ), 0xFF ),
        bit.band( bit.rshift( n, 8 ), 0xFF ),
        bit.band( n, 0xFF ),
        255
    )
end
