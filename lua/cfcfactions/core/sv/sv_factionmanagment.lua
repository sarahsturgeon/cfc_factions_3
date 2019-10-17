--[[
File Name: sv_factionmanagment.lua

Purpose: server-side commands to manipulate cfcFactions
]]--
if not SERVER then return end
local table = table
local string = string
local os = os
local fpm = cfcFactions.fpm

--------------------------------------------------------------------------------------------------------------
-- FACTIONS MANAGMENT COMMANDS
--------------------------------------------------------------------------------------------------------------

-- Creates a Faction based on "Name":string, "Color":string, "Description":string, "Invite Only":number
local function createFaction( ply, cmd, args )
    -- TODO: create faction from here
    cfcFactions:CreateFaction( ply, "My Faction", {255, 0, 0, 255}, "My Test Faction", 1 )
    PrintTable( cfcFactions.Factions )
end

concommand.Add( "fpvp_createfaction", createFaction )

-- Sets a player's internal faction rank based on "Player name":string, "Rank":string. Autotabs complete on name and rank
local function factionSetRank( ply, cmd, args )

end

concommand.Add( "fpvp_setrank", factionSetRank )

-- Invites a player to their faction based on "Player Name":string. Autotabs on name.
local function factionInvitePlayer( ply, cmd, args )

end

concommand.Add( "fpvp_inviteplayer", factionInvitePlayer )

-- Tells the client to open up their invite( s ) derma menu to view any incoming invites.
local function factionCheckInvites( ply, cmd, args )

end

concommand.Add( "fpvp_checkinvites", factionCheckInvites )


-- Kicks a player from the faction based on "Player Name":string. Autotabs on name.
local function factionKickPlayer( ply, cmd, args )
    local tokick = args[1]
    -- Be sure to make sure the player has permission to even kick a player from a faction.
    -- Player cannot be a "Leader" of a faction.
    if tokick:IsPlayer() and toKick:GetFactionRank() ~= "Leader" then

    end
end

concommand.Add( "fpvp_kickplayer", factionKickPlayer )

-- Clears a faction invite based on "Invite ID":string, Autotabs on Invite ID.
local function factionClearInvite( ply, cmd, args )

end

concommand.Add( "fpvp_clearinvite", factionClearInvite )

-- Clears all faction invites
local function factionClearAllPending( ply, cmd, args )
    if not ply:IsPlayer() then return end
    ply:SetNWBool( "invitePending", false )
end

concommand.Add( "fpvp_clearallpending", factionClearAllPending )

--------------------------------------------------------------------------------------------------------------
-- Permission System : tester only
--------------------------------------------------------------------------------------------------------------
-- Grants a player permission based on "Player Name":player, "Permission":string
local function allowFactionPermission( ply, cmd, args )
    if fpm:IsValidPermission( args[1] ) then
        if fpm:hasPermission( ply, "IsDeveloper" ) then
            if fpm:addPermission( ply, args[1] ) == true then
                ply:ChatPrint( string.format( "You have been granted access: %s", args[1] ) )
            end
        else
            ply:ChatPrint( "You require developer level permissions for this command." )
        end
    else
        ply:ChatPrint( "Unknown permission was not added." )
    end
end

concommand.Add( "fpvp_allowpermission", allowFactionPermission )

-- Removes a player permission based on "Player Name":player, "Permission":string
local function removeFactionPermission( ply, cmd, args )
    if fpm:IsValidPermission( args[1] ) then
        if fpm:hasPermission( ply, "IsDeveloper" ) then
            if fpm:revokePermission( ply, args[1] ) then
                print( string.format( "Success on removing permission %s", args[1] ) )
            end
        else
            ply:ChatPrint( "You require developer level permissions for this command." )
        end
    else
        print( string.format( "Failure on removing permission %s", args[1] ) )
    end
end

concommand.Add( "fpvp_removepermission", removeFactionPermission )

-- Checks if a player has permission based on "Player Name":player, "Permission":string
local function checkFactionPermission( ply, cmd, args )
    if fpm:IsValidPermission( args[1] ) then
        if fpm:hasPermission( ply, args[1] ) then
            print( string.format( "Player has proper permission %s.", args[1] ) )
        else
            print( string.format( "Player does not have proper permission %s.", args[1] ) )
        end
    else
        print( string.format( "%s is not a valid permission.", args[1] ) )
    end
end

concommand.Add( "fpvp_checkpermission", checkFactionPermission )

-- Prints a list of all possible permissions.
local function printFactionPermissions( ply, cmd, args )
    for key, value in pairs( fpm:FetchMergedPermissions() ) do
        ply:PrintMessage( HUD_PRINTCONSOLE, string.format( "[%s]\n\t\tDescription: %s\n", key, value.Description ) )
    end
end

concommand.Add( "fpvp_printpermissions", printFactionPermissions )

-- Revokes a player's permissions completely based on "Player Name":string, autotabs on complete.
local function factionRevokeUser( ply, cmd, args )
    if fpm:hasPermission( ply, "IsDeveloper" ) then
        fpm:revokeUser( ply )
    else
        ply:ChatPrint( "You require developer level permissions for this command." )
    end
end

concommand.Add( "fpvp_revokeuser", factionRevokeUser )

--------------------------------------------------------------------------------------------------------------
-- ADMIN COMMANDS : admin only
--------------------------------------------------------------------------------------------------------------
-- player:player, faction_id:number
local function forceSetFaction( ply, cmd, args )
    local factionid = args[1]
    if factionid == nil then -- err out
        return
    end
end

concommand.Add( "fpvp_forcesetfaction", forceSetFaction )

-- player:player
local function forceRemoveFaction( ply, cmd, args )

end

concommand.Add( "fpvp_forceremovefaction", forceRemoveFaction )

-- nil
local function viewFactionGlobalLogs( ply, cmd, args )

end

concommand.Add( "fpvp_viewgloballogs", viewFactionGlobalLogs )

--------------------------------------------------------------------------------------------------------------
-- MERC COMMANDS
--------------------------------------------------------------------------------------------------------------

-- player, string
local function factionHireMerc( ply, cmd, args )

end

concommand.Add( "fpvp_hiremerc", factionHireMerc )
-- player, string
local function factionFireMerc( ply, cmd, args )

end

concommand.Add( "fpvp_firemerc", factionFireMerc )

--------------------------------------------------------------------------------------------------------------
-- LOGGING COMMANDS : admin only
--------------------------------------------------------------------------------------------------------------

-- nil
local function deleteAllAdminLogs( ply, cmd, args )
    -- change to false later
    if not ply:IsPlayer() then
        MsgN( "Deleted all adminlogs in database!" )
        sql_db:DeleteAllLogs()
    else
        MsgN( "Only rcon can issue this command." )
    end
end

concommand.Add( "fpvp_deletealladminlogs", deleteAllAdminLogs )

-- nil
local function deleteFactionLogs( ply, cmd, args )

end

concommand.Add( "fpvp_deletefactionlogs", deleteFactionLogs )

-- id:number
local function forceDeleteFactionLogs( ply, cmd, args )

end

concommand.Add( "fpvp_forcedeletefactionlogs", forceDeleteFactionLogs )

--------------------------------------------------------------------------------------------------------------
-- CLIENT MENU COMMANDS
--------------------------------------------------------------------------------------------------------------

-- nil
local function factionMenu( ply, cmd, args )
    ply:CFCToggleMenu()
end

concommand.Add( "fpvp_factionmenu", factionMenu )

-- nil
local function factionCheckContract( ply, cmd, args )

end

concommand.Add( "fpvp_checkcontract", factionCheckContract )

local function factionCreateContract( ply, cmd, args )

end

concommand.Add( "fpvp_createcontract", factionCreateContract )
--------------------------------------------------------------------------------------------------------------
-- DEBUGGING COMMANDS : superadmin only
--------------------------------------------------------------------------------------------------------------

-- nil
local function factionShowInternals( ply, cmd, args )
    if ply:IsPlayer() then return end
    if IsValid( ply ) then return end
    PrintTable( cfcFactions )
end

concommand.Add( "fpvp_showinternals", factionShowInternals )

-- nil
local function factionForceInitilize( ply, cmd, args )
    -- only rcon
    if ply:IsPlayer() then
        MsgN( "Forcing mysql initlizing" )
        sql_db:initilize()
    end
end

concommand.Add( 'fpvp_forceinitilize', factionForceInitilize )

-- nil
local function factionResetdb( ply, cmd, args )

end

concommand.Add( "fpvp_resetdb", factionResetdb )

local function factionTestPermSys( ply, cmd, args )
    -- Revoke auth
    print( "Revoking user" )
    cfcFactions.fpm:revokeUser( ply )

    -- auth
    print( "Authing user" )
    cfcFactions.fpm:authUser( ply )

    -- allow
    print( "Allowing permission to test" )
    ply:ConCommand( "fpvp_allowpermission TestPerm" )

    -- test for allow
    ply:ConCommand( "fpvp_checkpermission TestPerm" )

    -- remove
    print( "Removing perm" )
    ply:ConCommand( "fpvp_removepermission TestPerm" )

    -- test for remove
    ply:ConCommand( "fpvp_checkpermission TestPerm" )
end

concommand.Add( "fpvp_testpermsys", factionTestPermSys )

local function factionDebugTest( ply, cmd, args )
    if fpm:IsDev( ply ) then
         cfcFactions:RemoveFaction( ply, ply:GetFactionID() )
         ply:concommand( "fpvp_createfaction" )
    end
end

concommand.Add( "fpvp_debugtest", factionDebugTest )

local function factionDebugMsg( ply, cmd, args )
    local argstring = ""
    for k = 1, #args do
        argstring = argstring .. args[k] .. " "
    end

    if fpm:IsDev( ply ) then
         cfcFactions:SendNotifcation( argstring, 3, ply )
    end
end

concommand.Add( "fpvp_debugmsg", factionDebugMsg )

--------------------------------------------------------------------------------------------------------------
-- HOOKS
--------------------------------------------------------------------------------------------------------------

local function factionsPlayerInitialSpawn( player )
    cfcFactions.fpm:authUser( player )
end

hook.Add( "PlayerInitialSpawn", "CFC_Fac_PlayerInitialSpawn", factionsPlayerInitialSpawn )
