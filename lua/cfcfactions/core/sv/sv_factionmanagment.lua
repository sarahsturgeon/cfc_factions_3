--[[
File Name: sv_factionmanagment.lua

Purpose: server-side commands to manipulate cfcFactions
]]--
if not SERVER then return end
local table = table
local string = string
local os = os
local fpm = cfcFactions.fpm
local logger = cfcFactions.logger

--------------------------------------------------------------------------------------------------------------
-- FACTIONS MANAGMENT COMMANDS
--------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------
-- Permission System : dev only

--------------------------------------------------------------------------------------------------------------
-- Grants a player permission based on "Player Name":player, "Permission":string
local function allowFactionPermission( ply, cmd, args )
    if fpm:IsValidPermission( args[1] ) then
        if fpm:hasPermission( ply, "IsDeveloper" ) then
            if fpm:addPermission( ply, args[1] ) == true then
                ply:ChatPrint( string.format( "You have been granted access: %s", args[1] ) )
                logger:info( string.format( "%s has been granted access to %s", ply:GetName(), args[1] ) )
            end
        else
            ply:ChatPrint( "You require developer level permissions for this command." )
            logger:info( string.format( "%s requires developer level to edit permissions.", ply:GetName() ) )
        end
    else
        ply:ChatPrint( "Unknown permission was not added." )
        logger:info( string.format( "Invalid permission: %s", args[1] ) )
    end
end

concommand.Add( "fpvp_allowpermission", allowFactionPermission )

-- Removes a player permission based on "Player Name":player, "Permission":string
local function removeFactionPermission( ply, cmd, args )
    if fpm:IsValidPermission( args[1] ) then
        if fpm:hasPermission( ply, "IsDeveloper" ) then
            if fpm:revokePermission( ply, args[1] ) then
                logger:info( string.format( "%s has been denied access to %s", ply:GetName(), args[1] ) )
            end
        else
            ply:ChatPrint( "You require developer level permissions for this command." )
            logger:info( string.format( "%s requires developer level to edit permissions.", ply:GetName() ) )
        end
    else
        logger:info( string.format( "Invalid permission: %s", args[1] ) )
    end
end

concommand.Add( "fpvp_removepermission", removeFactionPermission )

-- Checks if a player has permission based on "Player Name":player, "Permission":string
local function checkFactionPermission( ply, cmd, args )
    if fpm:IsValidPermission( args[1] ) then
        if fpm:hasPermission( ply, args[1] ) then
            logger:info( string.format( "Player has proper permission %s.", args[1] ) )
        else
            logger:info( string.format( "Player does not have proper permission %s.", args[1] ) )
        end
    else
        logger:info( string.format( "%s is not a valid permission.", args[1] ) )
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

--------------------------------------------------------------------------------------------------------------
-- CLIENT MENU COMMANDS
--------------------------------------------------------------------------------------------------------------

-- nil
local function factionMenu( ply, cmd, args )
    ply:CFCToggleMenu()
end

concommand.Add( "fpvp_factionmenu", factionMenu )

--------------------------------------------------------------------------------------------------------------
-- HOOKS
--------------------------------------------------------------------------------------------------------------

local function factionsPlayerInitialSpawn( player )
    cfcFactions.fpm:authUser( player )
end


