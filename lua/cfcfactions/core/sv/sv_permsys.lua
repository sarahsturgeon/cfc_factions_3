--[[
File Name: sv_permsys.lua

Purpose: Used to maintain, authorize, and check for cfcFaction permissions for various functions, utilities, and general networking

Global Tables: fpm.Permissions, fpm.Users.AuthUsers
]]--

cfcFactions.fpm = cfcFactions.fpm or {}
local fpm = cfcFactions.fpm
fpm.Permissions = {}
local factioneers = cfcFactions.Users
local logger = cfcFactions.logger

fpm.Permissions.CorePermissions = {
        --  NamedKey = table( description )
        -- "ExamplePermission" = {Description = "A short description of what the permission should do"}
        -- "CanKick" = {Description = "Allows a user to kick from faction."}
        -- [""] = {Description = ""},

        -- TODO: Should probably also have a number assigned to each one for easy managment. Instead of looking up by keyName, can just check for a number. 
        -- CAN_BAN = 6 for example. 

        ["CanBan"]                   = {
            Description = "Allows the user to ban from their own faction."
        },
        ["CanUnban"]                 = {
            Description = "Allows the user to unban a member from their own faction."
        },
        ["CanDisbandFaction"]        = {
            Description = "Allows a user to disband their faction."
        },
        ["CanEditAll"]               = {
            Description = "Allows a user to edit any faction detail."
        },
        ["CanEditDescription"]       = {
            Description = "Allows a user to edit the faction's description."
        },
        ["CanEditName"]              = {
            Description = "Allows a user to edit the faction's name."
        },
        ["CanEditColor"]             = {
            Description = "Allows a user to edit the faction's color."
        },
        ["CanEditInvite"]            = {
            Description = "Allows a user to edit the faction's invite status."
        },
        ["CanEditPermissions"]       = {
            Description = "Allows a user to edit a faction's permission structure."
        },
        ["CanAddPermissions"]        = {
            Description = "Allows a user to add a permission to a member."
        },
        ["CanSetRanks"]              = {
            Description = "Allows a user to set a member's rank."
        },
        ["CanRemoveRanks"]           = {
            Description = "Allows a user to remove a member's rank."
        },
        ["CanRemovePermissions"]     = {
            Description = "Allows a user to remove a member's permissions."
        },
        ["CanViewLogs"]              = {
            Description = "Allows a user to view the faction's logs."
        },
        ["CanViewFactionWiki"]       = {
            Description = "Allows a user to view their faction's wiki."
        },
        ["CanEditFactionWiki"]       = {
            Description = "Allows a user to edit their faction's wiki."
        },
        ["CanSendAllMessage"]        = {
            Description = "Allows a user to send a member to any faction member."
        },
        ["CanSendFactionMessage"]    = {
            Description = "Allows a user to send a message to their own faction."
        },
        ["CanReceiveFactionMessage"] = {
            Description = "Allows a user to receive a faction message from their own faction."
        },
        ["CanSpawnXPObject"]         = {
            Description = "Allows a user to spawn a XP gathering object."
        },
        ["CanDeleteXPObject"]        = {
            Description = "Allows a user to remove a XP gathering object."
        },
        ["CanDeclareWar"]            = {
            Description = "Allows a user to declare war on other factions."
        },
        ["CanUndeclareWar"]          = {
            Description = "Allows a user to remove a war from another faction."
        },
        ["CanSetAllies"]             = {
            Description = "Allows a user to set allies."
        },
        ["CanSetEnemies"]            = {
            Description = "Allows a user to set enemies."
        },
        ["CanRemoveAllies"]          = {
            Description = "Allows a user to remove allies."
        },
        ["CanRemoveEnemies"]         = {
            Description = "Allows a user to remove enemies."
        },
        ["CanHireMercs"]             = {
            Description = "Allows a user to hire mercenaries."
        },
        ["CanFireMercs"]             = {
            Description = "Allows a user to fire mercenaries."
        },
        ["CanSendInvite"]            = {
            Description = "Allows a user to send out faction invites."
        },
        ["CanRevokeInvite"]          = {
            Description = "Allows a user to revoke a faction invite."
        },
        ["CanDamageAllies"]          = {
            Description = "Allows a user to damage allies."
        },
        ["CanDamageTeammates"]       = {
            Description = "Allows a user to damage teammates."
        },
        ["IsDeveloper"]          = {
            Description = "Gives full permissions over everything that is cfc_Factions."
        },
        ["IsTester"]             = {
            Description = "A test permission to let users access experimental features."
        },
        ["IsFactionsAdmin"]      = {
            Description = "Lets a user have full control over other factions. "
        },
        ["CanCreateFaction"]     = {
            Description = "Lets a user create their own factions."
        },
        ["CanJoinFaction"]       = {
            Description = "Lets a user join other's factions."
        },
        ["AccessAll"]            = {
            Description = "Lets a user access factions and its content."
        },
        ["CanLeaveFaction"]      = {
            Description = "Lets a user leave their faction."
        },
        ["TestPerm"]             = {
            Description = "Test permission, please ignore."
        },
        ["CanReceiveAllMessage"] = {
            Description = "Allows a user to receive a message from anyone."
        }
}


-- //interal ranks inside a self contained faction. These will always be avaible to default to encase
-- a user decides to mess up their internal ranks.
-- !Best not to change these unless a core permission is needed

-- TODO: Perhaps move to a json format instead of hard coding ranks
fpm.defaultRanks = {
    -- creator of their own faction. Can do anything in their own faction
    ["leader"] = " * ",

    -- Coleader, can do most things but can't disband
    ["coleader"] = {
        "CanKick", "CanBan", "CanSendAllMessage", "CanSendFactionMessage", "CanDeclareWar",
        "CanUndeclareWar", "CanDisbandFaction", "CanEditAll", "CanEditDescription",
        "CanEditName", "CanEditColor", "CanEditInvite",
        "CanReceiveFactionMessage", "CanEditPermissions",
        "CanViewLogs", "CanViewAdminLogs", "CanViewGlobalLogs", "CanViewFactionWiki",
        "CanEditFactionWiki", "CanSpawnXPOrb", "CanDeleteXPOrb", "CanSetAllies",
        "CanSetEnemies", "CanRemoveAllies", "CanRemoveEnemies", "CanSendInvite", "CanRevokeInvite", "CanSetRanks", "CanRemoveRanks",
        "CanSetPermissions", "CanRemovePermissions"
    },

    -- admin, can handle things like user managment and permission managment
    ["admin"] = {
        "CanKick", "CanBan", "CanSendAllMessage", "CanSendFactionMessage",
        "CanReceiveFactionMessage", "CanViewLogs", "CanViewAdminLogs", "CanViewFactionWiki",
        "CanEditFactionWiki", "CanSpawnXPOrb", "CanDeleteXPOrb", "CanSetAllies",
        "CanSetEnemies", "CanRemoveAllies", "CanRemoveEnemies", "CanSendInvite", "CanRevokeInvite"
    },

    -- a normal member
    ["member"] = {
        "CanSendAllMessage",
        "CanSendFactionMessage",
        "CanReceiveFactionMessage",
        "CanSendInvite"
    },

    -- a user
    ["user"] = {
        "CanSendAllMessage",
        "CanSendFactionMessage",
        "CanReceiveFactionMessage"
    }
}

-- Revokes a user's permissions, essentialy removing them from cfcFaction's permission system
function fpm:RevokeUser( ply )
    local isValidPlayer = ply:IsPlayer() and IsValid( ply )

    if not isValidPlayer then return false end

    factioneers[ply:SteamID64()].CFCPermissions = nil

    return true
end

-- forces init for all current humans connected
function fpm:AuthAllUsers()
    for _, players in pairs ( player.GetHumans() ) do
        fpm:AuthUser( players )
    end
end
hook.Add( "Initialize", "CFC_FACTIONS3_InitializeUsers", fpm:AuthAllUsers() )

-- Auths a user and allows them to use factions properly. If not, things make explode
-- Or simply just don't want them using it
function fpm:AuthUser( authPlayer )
    logger:info( "Authenticating Factions user " .. authPlayer:SteamID() )
    -- Checks and balances
    if not authPlayer:IsPlayer() then
        return
    end

    local userExists = factioneers:UserExists( authPlayer )
    local hasPermissions = userExists and factioneers[authPlayer:SteamID64()].CFCPermissions ~= nil

    if userExists and hasPermissions then
        -- Error out, ply already has proper permissions for authentication
        return
    end

    factioneers:RegisterUser( authPlayer )

    -- Basic, core permissions ( almost ) every user should require in order to properly use factions.
    local AUTH_USER_PERMS = {
        "AccessAll", "CanReceiveAllMessage", "CanLeaveFaction", "CanCreateFaction", "CanJoinFaction"
    }

    if IsValid( authPlayer ) and authPlayer:IsAdmin() then
        table.insert( AUTH_USER_PERMS, "IsFactionsAdmin" )
        -- In hindsight, probably shouldn't actually give devs extra permissions based on credits. If someone were to stop development for CFC, 
        -- they would still have entire access to factions. 
        -- So here is a TODO: If you release factions as a finished product, for the love of god uncouple this from release. 
        -- Else you'll have billy bob who left 8 years ago still maintain access to everyone's factions 
        if ( cfcFactions.Credits.Developers[authPlayer:SteamID()] ~= nil ) then
            table.insert( AUTH_USER_PERMS, "IsDeveloper" )
            table.insert( AUTH_USER_PERMS, "IsTester" )
        end
    end

    for _, AuthPermission in pairs( AUTH_USER_PERMS ) do
        self:AddPermission( authPlayer, AuthPermission )
    end
end

-- Checks to see if a ply has a  specific permission( player, string )
-- returns false if they do not have it, true if they do
function fpm:HasPermission( ply, permission )
    -- Handling normal permissions now
    if not ply:IsPlayer() then
        logger:error( "Cannot check permission, player is invalid!" )
        return
    end

    if not self:IsValidPermission( permission ) then
        return false
    end

    local PlayerTable = factioneers[ply:SteamID64()].CFCPermissions
    local PlayerFactionTable = factioneers[ply:SteamID64()].FactionMetadata.InternalFactionPermissions

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
    if not table.HasValue( PlayerTable,  "AccessAll" ) then
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

-- Adds a permission to the ply. True if success, false if otherwise
function fpm:AddPermission( ply, permission )
    local isValidPlayer = IsValid( ply ) or not ply:IsPlayer()

    if not isValidPlayer then
        logger:error( "Unable to add permission, invalid player!" )
        return false
    end

    if not fpm:IsValidPermission( permission ) then
        logger:error( "Unable to add permission. Unknown string." )
        ply:ChatPrint( "Unable to add permission. Unknown string." )
        return false
    end

    local usr = factioneers:User( ply )


    table.insert( usr.CFCPermissions, permission )

    return true
end

-- Revokes a permission( s ) from the ply. True if success, false if otherwise
function fpm:RevokePermission( ply, permission_string )
    local usr = factioneers[ply:SteamID64()]

    for Key, Permission in pairs( usr.CFCPermissions ) do
        if Permission == permission_string then
            usr.CFCPermissions[Key] = nil
            return true
        end
    end

    return false
end

function fpm:GetPermissionList( ply )
    return fpm.Users.AuthUsers[ply:SteamID64()]
end

function fpm:IsValidPermission( permission )
    if not permission then return end

    for perm, _ in pairs( fpm.Permissions.CorePermissions ) do
        if string.lower( perm ) == string.lower( permission ) then
            return true
        end
    end
end

function fpm:IsFactionDev( ply )
    return self:HasPermission( ply, "IsDeveloper" )
end

function fpm:IsFactionAdmin( ply )
    return self:HasPermission( ply, "IsFactionsAdmin" )
end


