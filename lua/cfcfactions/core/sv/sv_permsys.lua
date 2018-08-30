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


		--	NamedKey = table(description, all_caps_string_followed_by_underscores_for_spaces)
		--"ExamplePermission" = {Description="A short description of what the permission should do",Alias="EXAMPLE_PERM"}
		--"CanKick" = {Description="Allows a user to kick from faction.", Alias="CAN_KICK"}
		--[""] = {Description="",Alias=""},


		--faction managment
		["CanBan"] = {Description="Allows the user to ban from their own faction.",Alias="CAN_BAN"},
		["CanUnban"] = {Description="Allows the user to unban a member from their own faction.",Alias="CAN_UNBAN"},
		["CanDisbandFaction"] = {Description="Allows a user to disband their faction.",Alias="CAN_DISBAND_FACTION"},
		["CanEditAll"] = {Description="Allows a user to edit any faction detail.",Alias="CAN_EDIT_ALL"},
		["CanEditDescription"] = {Description="Allows a user to edit the faction's description.",Alias="CAN_EDIT_DESCRIPTION"},
		["CanEditName"] = {Description="Allows a user to edit the faction's name.",Alias="CAN_EDIT_NAME"},
		["CanEditColor"] = {Description="Allows a user to edit the faction's color.",Alias="CAN_EDIT_COLOR"},
		["CanEditInvite"] = {Description="Allows a user to edit the faction's invite status.",Alias="CAN_EDIT_INVITE"},

		--permssions
		["CanEditPermissions"] = {Description="Allows a user to edit a faction's permission structure.",Alias="CAN_EDIT_PERMISSIONS"},
		["CanAddPermissions"] = {Description="Allows a user to add a permission to a member.",Alias="CAN_ADD_PERMISSIONS"},
		["CanSetRanks"] = {Description="Allows a user to set a member's rank.",Alias="CAN_SET_RANKS"},
		["CanRemoveRanks"] = {Description="Allows a user to remove a member's rank.",Alias="CAN_REMOVE_RANKS"},
		["CanRemovePermissions"] = {Description="Allows a user to remove a member's permissions.",Alias="CAN_REMOVE_PERMISSIONS"},

		--housekeeping
		["CanViewLogs"] = {Description="Allows a user to view the faction's logs.",Alias="CAN_VIEW_LOGS"},
		["CanViewFactionWiki"] = {Description="Allows a user to view their faction's wiki.",Alias="CAN_VIEW_FACTION_WIKI"},
		["CanEditFactionWiki"] = {Description="Allows a user to edit their faction's wiki.",Alias="CAN_EDIT_FACTION_WIKI"},	

		--misc
		["CanSendAllMessage"]= {Description="Allows a user to send a member to any faction member.",Alias="CAN_SEND_ALL_MESSAGE"},
		["CanReceiveAllMessage"] = {Description="Allows a user to receive a message from anyone.",Alias="CAN_RECEIVE_ALL_MESSAGE"},
		["CanSendFactionMessage"] = {Description="Allows a user to send a message to their own faction.",Alias="CAN_SEND_FACTION_MESSAGE"},
		["CanReceiveFactionMessage"] = {Description="Allows a user to receive a faction message from their own faction.",Alias="CAN_RECEIVE_FACTION_MESSAGE"},
		["CanSpawnXPObject"] = {Description="Allows a user to spawn a XP gathering object.",Alias="CAN_SPAWN_XP_OBJECT"},
		["CanDeleteXPObject"] = {Description="Allows a user to remove a XP gathering object.",Alias="CAN_DELETE_XP_OBJECT"},
		["CanDeclareWar"] = {Description="Allows a user to declare war on other factions.",Alias="CAN_DECLARE_WAR"},
		["CanUndeclareWar"] = {Description="Allows a user to remove a war from another faction.",Alias="CAN_UNDECLARE_WAR"},
		["CanSetAllies"] = {Description="Allows a user to set allies.",Alias="CAN_SET_ALLIES"},
		["CanSetEnemies"] = {Description="Allows a user to set enemies.",Alias="CAN_SET_ENEMIES"},
		["CanRemoveAllies"] = {Description="Allows a user to remove allies.",Alias="CAN_REMOVE_ALLIES"},
		["CanRemoveEnemies"] = {Description="Allows a user to remove enemies.",Alias="CAN_REMOVE_ENEMIES"},
		["CanHireMercs"] = {Description="Allows a user to hire mercenaries.",Alias="CAN_HIRE_MERCS"},
		["CanFireMercs"] ={Description="Allows a user to fire mercenaries.",Alias="CAN_FIRE_MERCS"},
		["CanSendInvite"] = {Description="Allows a user to send out faction invites.",Alias="CAN_SEND_INVITE"},
		["CanRevokeInvite"] = {Description="Allows a user to revoke a faction invite.",Alias="CAN_REVOKE_INVITE"}

}
--super special permissions not used by factions specifically
fpm.Permissions.SpecialPermissions = {
	["IsDeveloper"] = {Description="Gives full permissions over everything that is cfc_Factions.",Alias="_IS_A_DEV_"},
	["IsTester"] = {Description="A test permission to let users access experimental features.",Alias="IS_A_TESTER"},
	["IsFactionsAdmin"] = {Description="Lets a user have full control over other factions. ",Alias="FACTIONS_ADMIN"},
	["CanCreateFaction"] = {Description="Lets a user create their own factions.",Alias="CAN_CREATE_FACTION"},
	["CanJoinFaction"] = {Description="Lets a user join other's factions.",Alias="CAN_JOIN_FACTION"},
	["AccessAll"] = {Description="Lets a user access factions and its content.",Alias="ACCESS_ALL"},
	["CanLeaveFaction"] = {Description="Lets a user leave their faction.",Alias="CAN_LEAVE_FACTION"},
	["TestPerm"] = {Description="Test permission, please ignore.", Alias="TEST_PERM"}

}

local function lookUpAlias(alias)
	
	for k , v in pairs(fpm:FetchMergedPermissions()) do
		if v.Alias == alias.Alias then return k end
	end

end

--Dev Note: Permissons should not be able to be used yet since its missing
--the table infront of it. Ether redefine how permissions are coded
--or go through and throw a table infront of every single permission
--in order for them to be properly used.

--IE: CanKick to fpm.Permissions.CorePermissions.CanKick


--//interal ranks inside a self contained faction. These will always be avaible to default to encase
--a user decides to mess up their internal ranks. 
--!Best not to change these unless a core permission is needed
fpm.defaultRanks = {
	--creator of a faction. Can do anything in their own faction
	["leader"] = "*",

	--Coleader, can do most things but can't disband
	["coleader"] = {"CanKick", "CanBan", "CanSendAllMessage", "CanSendFactionMessage", "CanDeclareWar",
	"CanUndeclareWar", "CanDisbandFaction", "CanEditAll", "CanEditDescription",
	"CanEditName", "CanEditColor", "CanEditInvite",
	"CanReceiveFactionMessage", "CanEditPermissions",
	"CanViewLogs", "CanViewAdminLogs", "CanViewGlobalLogs", "CanViewFactionWiki",
	"CanEditFactionWiki", "CanSpawnXPOrb", "CanDeleteXPOrb", "CanSetAllies",
	"CanSetEnemies", "CanRemoveAllies", "CanRemoveEnemies","CanSendInvite","CanRevokeInvite","CanSetRanks","CanRemoveRanks",
	"CanSetPermissions", "CanRemovePermissions"},
	--admin, can handle things like user managment and permission managment
	["admin"] = {"CanKick", "CanBan", "CanSendAllMessage", "CanSendFactionMessage",
	"CanReceiveFactionMessage","CanViewLogs", "CanViewAdminLogs", "CanViewFactionWiki",
	"CanEditFactionWiki", "CanSpawnXPOrb", "CanDeleteXPOrb", "CanSetAllies",
	"CanSetEnemies", "CanRemoveAllies", "CanRemoveEnemies","CanSendInvite","CanRevokeInvite"},
	--a normal member
	["member"] = {"CanSendAllMessage", "CanSendFactionMessage",
	"CanReceiveFactionMessage","CanSendInvite"},
	--a user
	["user"] = {"CanSendAllMessage", "CanSendFactionMessage",
	"CanReceiveFactionMessage"}

}

--Returns a copy of merged tables for all permissions (Special and core). Use lightly
function fpm:FetchMergedPermissions()
	return table.Merge(fpm.Permissions.CorePermissions, fpm.Permissions.SpecialPermissions)
end


--Revokes a user's permissions, essentiall removing them from cfcFaction's permission system
function fpm:revokeUser(player)

	if player:IsPlayer() and IsValid(player) then
		fpm.Users[player:SteamID64()] = nil
		return true
	end
	return false
end


--forces init for all current humans connected
function fpm:authAllUsers()
	for _ , players in pairs (player.GetHumans()) do
		fpm:authUser(players)
	end
end

--Auths a user and allows them to use factions properly. If not, things make explode
--Or simply just don't want them using it
function fpm:authUser(player)
	print("Authenticating user " .. player:SteamID())
	--Checks and balances
	if not player:IsPlayer() or not IsValid(player) then return end
	if not (fpm.Users[player:SteamID64()] == nil) then 
		player:ChatPrint("User already has proper permissions table.")
		return 
	end
	fpm.Users[player:SteamID64()] = {["Permissions"] = {}}

	local Perms = fpm.Permissions.CorePermissions
	local Special = fpm.Permissions.SpecialPermissions

	--Basic, core permissions (almost) every user should require in order to properly use factions.
	local AuthUserPerms = {
		"AccessAll","CanReceiveAllMessage","CanLeaveFaction","CanCreateFaction","CanJoinFaction"
	}

	if IsValid(player) and player:IsAdmin() then
		table.insert(AuthUserPerms, "IsFactionsAdmin")
		--testing dev access
		if player:SteamID() == "STEAM_0:1:28607710" then
			table.insert(AuthUserPerms, "IsDeveloper")
			table.insert(AuthUserPerms,"IsTester")
		end
	end
	--Check if for some reason they should be black listed or not and remove all perms

	--
	--fpm.Users[player:SteamID64()] = { ["Permissions"] = AuthUserPerms }
	for k,v in pairs(AuthUserPerms) do
		self:addPermission(player, v)
	end
	print("Authed user permissions complete.")
	PrintTable(fpm.Users[player:SteamID64()])
end

--Checks to see if a player has a  specific permission(s)
function fpm:hasPermission(player, permission)

	--If developer, pretty much free control over everything
	--if table.HasValue(fpm.Users[player:SteamID64()].Permissions, "IsDeveloper") then return true end
	--Handling normal permissions now
	for _ , perms in pairs(fpm.Users[player:SteamID64()].Permissions) do
		if perms == permission then
			return true 
		end
	end
	-- for _ , perm in pairs(fpm.Users[player:SteamID64()].Permissions) do
	-- 	if (perm == permission) then return true end
	-- end

	return false
end

--Adds a permission to the player. True if success, false if otherwise
function fpm:addPermission(player, permission)

	if not IsValid(player) or not player:IsPlayer() then print("Unable to add permission, invalid player") return false end
	if not fpm:IsValidPermission(permission) then 
		player:ChatPrint("Unable to add permission. Unknown string.")
		 return false
	end
	--add a permission based of key string
	-- "TestPerm" would be a valid key, look that up, set the trailing table to what ever TestPerm is

	local usr = fpm.Users[player:SteamID64()]

	--Permissions["key"] = "Key"[Value]
	table.insert(usr.Permissions, permission)
	return true
end


--Revokes a permission(s) from the player. True if success, false if otherwise
function fpm:revokePermission(player, permission)
	local usr = fpm.Users[player:SteamID64()]
	for k , perms in pairs(usr.Permissions) do
		if perms == permission then
			usr.Permissions[k] = nil
			return true
		end
		
	end
	return false
end

--Returns a list of permissions the player currently has
function fpm:getPermissionList(player)
	return fpm.Users.AuthUsers[player:SteamID64()]
end


function fpm:IsValidPermission(cmd)
	for k,v in pairs(fpm.Permissions.CorePermissions) do

		if string.lower(k) == string.lower(cmd) then
			return true
		end
		if v.Alias == string.lower(cmd) then
			return true
		end
	end
	for n,m in pairs(fpm.Permissions.SpecialPermissions) do
		if string.lower(n) == string.lower(cmd) then
			return true
		end
		if m.Alias == string.lower(cmd) then
			return true
		end
	end
end

hook.Add("Initialize", "cfcInitializeUsers", fpm:authAllUsers())