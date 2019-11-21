--[[
File Name: sv_permsys.lua

Purpose: Used to maintain, authorize, and check for cfcFaction permissions for various functions, utilities, and general networking

Global Tables: fpm.Permissions, fpm.Users.AuthUsers
]]--

cfcFactions.fpm = cfcFactions.fpm or {}
local fpm = cfcFactions.fpm
fpm.Permissions = {}
local factioneers = cfcFactions.Users

fpm.Permissions.CorePermissions = {
        --  NamedKey = table( description )
        -- "ExamplePermission" = {Description = "A short description of what the permission should do"}
        -- "CanKick" = {Description = "Allows a user to kick from faction."}
        --[""] = {Description = ""},

        -- faction managment
        ["CanBan"] = {Description = "Allows the user to ban from their own faction."},
        ["CanUnban"] = {Description = "Allows the user to unban a member from their own faction."},
        ["CanDisbandFaction"] = {Description = "Allows a user to disband their faction."},
        ["CanEditAll"] = {Description = "Allows a user to edit any faction detail."},
        ["CanEditDescription"] = {Description = "Allows a user to edit the faction's description."},
        ["CanEditName"] = {Description = "Allows a user to edit the faction's name."},
        ["CanEditColor"] = {Description = "Allows a user to edit the faction's color."},
        ["CanEditInvite"] = {Description = "Allows a user to edit the faction's invite status."},


        -- permssions
        ["CanEditPermissions"] = {Description = "Allows a user to edit a faction's permission structure."},
        ["CanAddPermissions"] = {Description = "Allows a user to add a permission to a member."},
        ["CanSetRanks"] = {Description = "Allows a user to set a member's rank."},
        ["CanRemoveRanks"] = {Description = "Allows a user to remove a member's rank."},
        ["CanRemovePermissions"] = {Description = "Allows a user to remove a member's permissions."},

        -- housekeeping
        ["CanViewLogs"] = {Description = "Allows a user to view the faction's logs."},
        ["CanViewFactionWiki"] = {Description = "Allows a user to view their faction's wiki."},
        ["CanEditFactionWiki"] = {Description = "Allows a user to edit their faction's wiki."},

        -- misc
        ["CanSendAllMessage"]= {Description = "Allows a user to send a member to any faction member."},

        ["CanSendFactionMessage"] = {Description = "Allows a user to send a message to their own faction."},
        ["CanReceiveFactionMessage"] = {Description = "Allows a user to receive a faction message from their own faction."},
        ["CanSpawnXPObject"] = {Description = "Allows a user to spawn a XP gathering object."},
        ["CanDeleteXPObject"] = {Description = "Allows a user to remove a XP gathering object."},
        ["CanDeclareWar"] = {Description = "Allows a user to declare war on other factions."},
        ["CanUndeclareWar"] = {Description = "Allows a user to remove a war from another faction."},
        ["CanSetAllies"] = {Description = "Allows a user to set allies."},
        ["CanSetEnemies"] = {Description = "Allows a user to set enemies."},
        ["CanRemoveAllies"] = {Description = "Allows a user to remove allies."},
        ["CanRemoveEnemies"] = {Description = "Allows a user to remove enemies."},
        ["CanHireMercs"] = {Description = "Allows a user to hire mercenaries."},
        ["CanFireMercs"] ={Description = "Allows a user to fire mercenaries."},
        ["CanSendInvite"] = {Description = "Allows a user to send out faction invites."},
        ["CanRevokeInvite"] = {Description = "Allows a user to revoke a faction invite."},
        ["CanDamageAllies"] = {Description = "Allows a user to damage allies."},
        ["CanDamageTeammates"] = {Description = "Allows a user to damage teammates."}
}

-- super special permissions not used by factions specifically
fpm.Permissions.SpecialPermissions = {
    ["IsDeveloper"] = {Description = "Gives full permissions over everything that is cfc_Factions."},
    ["IsTester"] = {Description = "A test permission to let users access experimental features."},
    ["IsFactionsAdmin"] = {Description = "Lets a user have full control over other factions. "},
    ["CanCreateFaction"] = {Description = "Lets a user create their own factions."},
    ["CanJoinFaction"] = {Description = "Lets a user join other's factions."},
    ["AccessAll"] = {Description = "Lets a user access factions and its content."},
    ["CanLeaveFaction"] = {Description = "Lets a user leave their faction."},
    ["TestPerm"] = {Description = "Test permission, please ignore."},
    ["CanReceiveAllMessage"] = {Description = "Allows a user to receive a message from anyone."}
}

-- //interal ranks inside a self contained faction. These will always be avaible to default to encase
-- a user decides to mess up their internal ranks.
-- !Best not to change these unless a core permission is needed
fpm.defaultRanks = {
    -- creator of a faction. Can do anything in their own faction
    ["leader"] = " * ",

    -- Coleader, can do most things but can't disband
    ["coleader"] = {"CanKick", "CanBan", "CanSendAllMessage", "CanSendFactionMessage", "CanDeclareWar",
    "CanUndeclareWar", "CanDisbandFaction", "CanEditAll", "CanEditDescription",
    "CanEditName", "CanEditColor", "CanEditInvite",
    "CanReceiveFactionMessage", "CanEditPermissions",
    "CanViewLogs", "CanViewAdminLogs", "CanViewGlobalLogs", "CanViewFactionWiki",
    "CanEditFactionWiki", "CanSpawnXPOrb", "CanDeleteXPOrb", "CanSetAllies",
    "CanSetEnemies", "CanRemoveAllies", "CanRemoveEnemies", "CanSendInvite", "CanRevokeInvite", "CanSetRanks", "CanRemoveRanks",
    "CanSetPermissions", "CanRemovePermissions"},
    -- admin, can handle things like user managment and permission managment
    ["admin"] = {"CanKick", "CanBan", "CanSendAllMessage", "CanSendFactionMessage",
    "CanReceiveFactionMessage", "CanViewLogs", "CanViewAdminLogs", "CanViewFactionWiki",
    "CanEditFactionWiki", "CanSpawnXPOrb", "CanDeleteXPOrb", "CanSetAllies",
    "CanSetEnemies", "CanRemoveAllies", "CanRemoveEnemies", "CanSendInvite", "CanRevokeInvite"},
    -- a normal member
    ["member"] = {"CanSendAllMessage", "CanSendFactionMessage",
    "CanReceiveFactionMessage", "CanSendInvite"},
    -- a user
    ["user"] = {"CanSendAllMessage", "CanSendFactionMessage",
    "CanReceiveFactionMessage"}
}

-- Returns a copy of merged tables for all permissions ( Special and core ).
function fpm:FetchMergedPermissions()
    return table.Merge( fpm.Permissions.CorePermissions, fpm.Permissions.SpecialPermissions )
end

-- Revokes a user's permissions, essentialy removing them from cfcFaction's permission system
function fpm:revokeUser( player )
    if player:IsPlayer() and IsValid( player ) then
        factioneers[player:SteamID64()].CFCPermissions = nil
        return true
    end

    return false
end


-- forces init for all current humans connected
function fpm:authAllUsers()
    for _, players in pairs ( player.GetHumans() ) do
        fpm:authUser( players )
    end
end

-- Auths a user and allows them to use factions properly. If not, things make explode
-- Or simply just don't want them using it
function fpm:authUser( authPlayer )
    print( "Authenticating Factions user " .. authPlayer:SteamID() )
    -- Checks and balances
    if not authPlayer:IsPlayer() then
        return
    end

    if factioneers:UserExists( authPlayer ) then
        if ( not ( factioneers[authPlayer:SteamID64()].CFCPermissions == nil ) ) then
            -- Error out, player already has proper permissions for authentication
            return
        end
    end

    factioneers:registeruser( authPlayer )

    -- Basic, core permissions ( almost ) every user should require in order to properly use factions.
    local AuthUserPerms = {
        "AccessAll", "CanReceiveAllMessage", "CanLeaveFaction", "CanCreateFaction", "CanJoinFaction"
    }

    if IsValid( authPlayer ) and authPlayer:IsAdmin() then
        table.insert( AuthUserPerms, "IsFactionsAdmin" )
        -- Testing dev access, SteamID is 'Voodoo'
        -- Remove code when final branch is published
        if ( cfcFactions.Credits.Developers[authPlayer:SteamID()] ~= nil ) then
            table.insert( AuthUserPerms, "IsDeveloper" )
            table.insert( AuthUserPerms, "IsTester" )
        end
    end

    -- fpm.Users[player:SteamID64()] = { ["Permissions"] = AuthUserPerms }
    for _, AuthPermission in pairs( AuthUserPerms ) do
        self:addPermission( authPlayer, AuthPermission )
    end
end

-- Checks to see if a player has a  specific permission( s )
function fpm:hasPermission( player, permission )
    -- Handling normal permissions now
    if not player:IsPlayer() then
        return
    end
    if not self:IsValidPermission( permission ) then
        return false
    end

    local PlayerTable = factioneers[player:SteamID64()].CFCPermissions
    local PlayerFactionTable = factioneers[player:SteamID64()].FactionMetadata.InternalFactionPermissions

    if PlayerTable == nil then
        return false
    end
    if PlayerFactionTable == nil then
        return false
    end

    -- If Developer, let them do anything.
    if table.HasValue( PlayerTable, "IsDeveloper" )  then
        return true
    end
    -- If they can't even access factions, just return false for everything.
    if table.HasValue( PlayerTable,  "AccessAll" ) then
        return false
    end

    -- Check the global CFC Permissions for the permission.
    for CFCPermKey, CFCPermDescription in pairs( PlayerTable ) do
        if CFCPermDescription == permission then
            return true
        end
    end

    -- Check the Faction permissions ( Player editable permissions ) for the permission.
    for FactionPermKey, FactionPermDescription in pairs( PlayerFactionTable ) do
        if FactionPermDescription == permission then
            return true
        end
    end

    return false
end

-- Adds a permission to the player. True if success, false if otherwise
function fpm:addPermission( player, permission )
    if not IsValid( player ) or not player:IsPlayer() then print( "Unable to add permission, invalid player" ) return false end
    if not fpm:IsValidPermission( permission ) then
        player:ChatPrint( "Unable to add permission. Unknown string." )
         return false
    end

    local usr = factioneers[player:SteamID64()]
    if fpm:IsSpecialPermission( permission ) == false then
        table.insert( usr.FactionMetadata.InternalFactionPermissions, permission )
    else
        table.insert( usr.CFCPermissions, permission )
    end
    return true
end

-- Revokes a permission( s ) from the player. True if success, false if otherwise
function fpm:revokePermission( player, permission_string )
    local usr = factioneers[player:SteamID64()]
    for Key, Permission in pairs( usr.CFCPermissions ) do
        if Permission == permission_string then
            usr.CFCPermissions[k] = nil
            return true
        end

    end
    return false
end
function fpm:IsSpecialPermission( perm )
    if fpm:IsValidPermission( perm ) then
        if ( fpm.Permissions.SpecialPermissions[perm] ~= nil ) then
            return true
        else
            return false
        end
    end

end
-- Returns a list of permissions the player currently has
function fpm:getPermissionList( player )
    return fpm.Users.AuthUsers[player:SteamID64()]
end

function fpm:IsValidPermission( permission )
    if permission == nil then return end
    for k, v in pairs( fpm.Permissions.CorePermissions ) do
        if string.lower( k ) == string.lower( permission ) then
            return true
        end

    end

    for n, m in pairs( fpm.Permissions.SpecialPermissions ) do
        if string.lower( n ) == string.lower( permission ) then
            return true
        end
    end
end

function fpm:IsDev( player )
    if self:hasPermission( player, "IsDeveloper" ) then return true end
    return false
end

function fpm:IsFactionAdmin( player )
    if self:hasPermission( player, "IsFactionsAdmin" ) then return true end
    return false
end

hook.Add( "Initialize", "cfcInitializeUsers", fpm:authAllUsers() )
