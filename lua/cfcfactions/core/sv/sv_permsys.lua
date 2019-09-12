--[[]
File Name: sv_permsys.lua

Purpose: Used to maintain, authorize, and check for cfcFaction permissions for various functions, utilities, and general networking

Global Tables: fpm.Permissions, fpm.Users.AuthUsers
]]--

cfcFactions.fpm = cfcFactions.fpm or {}
local fpm = cfcFactions.fpm
fpm.Permissions = {}
fpm.Users = {}

fpm.Permissions.CorePermissions = {
        --  NamedKey = table(description, all_caps_string_followed_by_underscores_for_spaces)
        --"ExamplePermission" = { Description="A short description of what the permission should do", Alias="EXAMPLE_PERM" }
        --"CanKick" = { Description="Allows a user to kick from faction.", Alias="CAN_KICK"  }
        --[""] = { Description="", Alias="" },

        --faction management
        ["CanBan"] = { Description="Allows the user to ban from their own faction.", Alias="CAN_BAN" },
        ["CanUnban"] = { Description="Allows the user to unban a member from their own faction.", Alias="CAN_UNBAN" },
        ["CanDisbandFaction"] = { Description="Allows a user to disband their faction.", Alias="CAN_DISBAND_FACTION" },
        ["CanEditAll"] = { Description="Allows a user to edit any faction detail.", Alias="CAN_EDIT_ALL" },
        ["CanEditDescription"] = { Description="Allows a user to edit the faction's description.", Alias="CAN_EDIT_DESCRIPTION" },
        ["CanEditName"] = { Description="Allows a user to edit the faction's name.", Alias="CAN_EDIT_NAME" },
        ["CanEditColor"] = { Description="Allows a user to edit the faction's color.", Alias="CAN_EDIT_COLOR" },
        ["CanEditInvite"] = { Description="Allows a user to edit the faction's invite status.", Alias="CAN_EDIT_INVITE" },

        --permissions
        ["CanEditPermissions"] = { Description="Allows a user to edit a faction's permission structure.", Alias="CAN_EDIT_PERMISSIONS" },
        ["CanAddPermissions"] = { Description="Allows a user to add a permission to a member.", Alias="CAN_ADD_PERMISSIONS" },
        ["CanSetRanks"] = { Description="Allows a user to set a member's rank.", Alias="CAN_SET_RANKS" },
        ["CanRemoveRanks"] = { Description="Allows a user to remove a member's rank.", Alias="CAN_REMOVE_RANKS" },
        ["CanRemovePermissions"] = { Description="Allows a user to remove a member's permissions.", Alias="CAN_REMOVE_PERMISSIONS" },

        --housekeeping
        ["CanViewLogs"] = { Description="Allows a user to view the faction's logs.", Alias="CAN_VIEW_LOGS" },
        ["CanViewFactionWiki"] = { Description="Allows a user to view their faction's wiki.", Alias="CAN_VIEW_FACTION_WIKI" },
        ["CanEditFactionWiki"] = { Description="Allows a user to edit their faction's wiki.", Alias="CAN_EDIT_FACTION_WIKI" },

        --misc
        ["CanSendAllMessage"]= { Description="Allows a user to send a member to any faction member.", Alias="CAN_SEND_ALL_MESSAGE" },
        ["CanReceiveAllMessage"] = { Description="Allows a user to receive a message from anyone.", Alias="CAN_RECEIVE_ALL_MESSAGE" },
        ["CanSendFactionMessage"] = { Description="Allows a user to send a message to their own faction.", Alias="CAN_SEND_FACTION_MESSAGE" },
        ["CanReceiveFactionMessage"] = { Description="Allows a user to receive a faction message from their own faction.", Alias="CAN_RECEIVE_FACTION_MESSAGE" },
        ["CanSpawnOrb"] = { Description="Allows a user to spawn a XP gathering orb.", Alias="CAN_SPAWN_XP_ORB" },
        ["CanDeleteOrb"] = { Description="Allows a user to remove a XP gathering orb.", Alias="CAN_DELETE_XP_ORB" },
        ["CanDeclareWar"] = { Description="Allows a user to declare war on other factions.", Alias="CAN_DECLARE_WAR" },
        ["CanEndWar"] = { Description="Allows a user to remove a war from another faction.", Alias="CAN_END_WAR" },
        ["CanSetAllies"] = { Description="Allows a user to set allies.", Alias="CAN_SET_ALLIES" },
        ["CanSetEnemies"] = { Description="Allows a user to set enemies.", Alias="CAN_SET_ENEMIES" },
        ["CanRemoveAllies"] = { Description="Allows a user to remove allies.", Alias="CAN_REMOVE_ALLIES" },
        ["CanRemoveEnemies"] = { Description="Allows a user to remove enemies.", Alias="CAN_REMOVE_ENEMIES" },
        ["CanHireMercs"] = { Description="Allows a user to hire mercenaries.", Alias="CAN_HIRE_MERCS" },
        ["CanFireMercs"] ={ Description="Allows a user to fire mercenaries.", Alias="CAN_FIRE_MERCS" },
        ["CanSendInvite"] = { Description="Allows a user to send out faction invites.", Alias="CAN_SEND_INVITE" },
        ["CanRevokeInvite"] = { Description="Allows a user to revoke a faction invite.", Alias="CAN_REVOKE_INVITE" }
}

--super special permissions not used by factions specifically
fpm.Permissions.SpecialPermissions = {
    ["IsDeveloper"] = { Description="Gives full permissions over everything that is cfc_Factions.", Alias="_IS_A_DEV_" },
    ["IsTester"] = { Description="A test permission to let users access experimental features.", Alias="IS_A_TESTER" },
    ["IsFactionsAdmin"] = { Description="Lets a user have full control over other factions. ", Alias="FACTIONS_ADMIN" },
    ["CanCreateFaction"] = { Description="Lets a user create their own factions.", Alias="CAN_CREATE_FACTION" },
    ["CanJoinFaction"] = { Description="Lets a user join others factions.", Alias="CAN_JOIN_FACTION" },
    ["AccessAll"] = { Description="Lets a user access factions and its content.", Alias="ACCESS_ALL" },
    ["CanLeaveFaction"] = { Description="Lets a user leave their faction.", Alias="CAN_LEAVE_FACTION" },
    ["TestPerm"] = { Description="Test permission, please ignore.", Alias="TEST_PERM" }
}

-- Create a lookup table to make later validity checks more efficient
local permissionsLookup = {}
for perm, data in pairs( fpm:FetchMergedPermissions() ) do
    local lowerPerm = string.lower( perm )
    permissionsLookup[lowerPerm] = true

    local lowerAlias = string.lower( data.Alias )
    permissionsLookup[lowerAlias] = true
end

-- Creates a mapping for alias:permission lookups
local aliasMapping = {}
for perm, data in pairs( fpm:FetchMergedPermissions() ) do
    local lowerAlias = string.lower( data.Alias )
    aliasMapping[lowerAlias] = perm
end

local function lookUpAlias( alias )
    return aliasMapping[string.lower( alias )]
end

--//internal ranks inside a self contained faction. These will always be available to default to encase
--a user decides to mess up their internal ranks.
--!Best not to change these unless a core permission is needed
fpm.defaultRanks = {
    --creator of a faction. Can do anything in their own faction
    ["leader"] = "*",

    --Coleader, can do most things but can't disband
    ["coleader"] = { "CanKick", "CanBan", "CanSendAllMessage", "CanSendFactionMessage", "CanDeclareWar",
    "CanEndWar", "CanDisbandFaction", "CanEditAll", "CanEditDescription",
    "CanEditName", "CanEditColor", "CanEditInvite",
    "CanReceiveFactionMessage", "CanEditPermissions",
    "CanViewLogs", "CanViewAdminLogs", "CanViewGlobalLogs", "CanViewFactionWiki",
    "CanEditFactionWiki", "CanSpawnOrb", "CanDeleteOrb", "CanSetAllies",
    "CanSetEnemies", "CanRemoveAllies", "CanRemoveEnemies", "CanSendInvite", "CanRevokeInvite", "CanSetRanks", "CanRemoveRanks",
    "CanSetPermissions", "CanRemovePermissions" },

    --admin, can handle things like user managment and permission managment
    ["admin"] = { "CanKick", "CanBan", "CanSendAllMessage", "CanSendFactionMessage",
    "CanReceiveFactionMessage", "CanViewLogs", "CanViewAdminLogs", "CanViewFactionWiki",
    "CanEditFactionWiki", "CanSpawnOrb", "CanDeleteOrb", "CanSetAllies",
    "CanSetEnemies", "CanRemoveAllies", "CanRemoveEnemies", "CanSendInvite", "CanRevokeInvite" },

    --a normal member
    ["member"] = { "CanSendAllMessage", "CanSendFactionMessage", "CanReceiveFactionMessage", "CanSendInvite" },

    --a trial
    ["trial"] = { "CanSendAllMessage", "CanSendFactionMessage", "CanReceiveFactionMessage" }
}

--Returns a copy of merged permissions table. Caches the return value but can be popped with forceRefresh parameter.
local mergedPermissions = nil
function fpm:FetchMergedPermissions( forceRefresh )
    if mergedPermissions and not forceRefresh then return mergedPermissions end

    mergedPermissions = table.Merge( fpm.Permissions.CorePermissions, fpm.Permissions.SpecialPermissions )

    return mergedPermissions
end

-- Revokes a user's permissions, essentially removing them from cfcFaction's permission system
function fpm:revokeUser( ply )
    if not ply:IsPlayer() and IsValid( ply ) then return false end

    fpm.Users[ply:SteamID64()] = nil

    return true
end

-- Forces init for all current humans connected
function fpm:authAllUsers()
    for _, players in pairs ( player.GetHumans() ) do
        fpm:authUser( players )
    end
end


--Auths a user and allows them to use factions properly. If not, things may(?) explode
--Or simply just don't want them using it
function fpm:authUser( ply )
    print( "Authenticating user " .. ply:SteamID() )
    --Checks and balances
    if not ply:IsPlayer() or not IsValid( ply ) then return end

    if not fpm.Users[ply:SteamID64()] == nil then
        ply:ChatPrint( "User already has proper permissions table." )
        return
    end

    fpm.Users[ply:SteamID64()] = {["Permissions"] = {}}

    -- TODO: Extract this out somewhere
    --Basic, core permissions (almost) every user should require in order to properly use factions.
    local defaultUserPermissions = {
        "AccessAll", "CanReceiveAllMessage", "CanLeaveFaction", "CanCreateFaction", "CanJoinFaction"
    }

    if ply:IsAdmin() then
        table.insert( defaultUserPermissions, "IsFactionsAdmin" )

        --testing dev access
        if ply:SteamID() == "STEAM_0:1:28607710" then
            table.insert( defaultUserPermissions, "IsDeveloper" )
            table.insert( defaultUserPermissions, "IsTester" )
        end
    end
    --Check if for some reason they should be black listed or not and remove all perms

    --fpm.Users[ply:SteamID64()] = { ["Permissions"] = defaultUserPermissions }
    for _, permission in pairs( defaultUserPermissions ) do
        self:addPermission( ply, permission )
    end
end

--Checks to see if a player has a  specific permission(s)
function fpm:hasPermission( ply, permission )
    if not IsValid( ply ) or not ply:IsPlayer() then return false end

    --If developer, pretty much free control over everything
    --if table.HasValue(fpm.Users[ply:SteamID64()].Permissions, "IsDeveloper") then return true end
    --Handling normal permissions now
    --if fpm.Users[ply:SteamID64()].Permissions["IsDeveloper" ~= nil] then return true end


    local steam64 = ply:SteamID64()
    local user = fpm.Users[steam64]
    local userPermissions = user.Permissions

    return userPermissions[permission] or false
end

--Adds a permission to the player. True if success, false if otherwise
-- TODO: Sanity check this function
function fpm:addPermission( ply, permission )
    if not IsValid( ply ) or not ply:IsPlayer() then print( "Unable to add permission, invalid player" ); return false end
    if not fpm:IsValidPermission( permission ) then ply:ChatPrint( "Unable to add permission. Unknown string." ); return false end

    local user = fpm.Users[ply:SteamID64()]

    user.Permissions[permission] = true

    return true
end

--Revokes a permission(s) from the player. True if success, false if otherwise
-- TODO: How would this fail? Should this return anything?
function fpm:revokePermission( ply, permission )
    local user = fpm.Users[ply:SteamID64()]

    user.Permissions[permission] = nil

    return true
end

--Returns a list of permissions the player currently has
function fpm:getPermissionList( ply )
    return fpm.Users.AuthUsers[ply:SteamID64()]
end

function fpm:IsValidPermission( permission )
    return permissionsLookup[string.lower( permission )] or false
end


-- Permission helpers --
-- TODO: Should these be player meta functions?
function fpm:IsDev( ply )
    return self:hasPermission( ply, "IsDeveloper" )
end

function fpm:IsFactionAdmin( ply )
    return self:hasPermission( ply, "IsFactionsAdmin" )
end

hook.Add( "Initialize", "cfcInitializeUsers", fpm:authAllUsers() )
