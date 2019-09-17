--[[]
File Name: sv_users.lua

Purpose: Core faction's functions to create, edit, and destory users who use factions

Global Tables: cfcFactions.Users
]]--
cfcFactions.Users = cfcFactions.Users or {}
local cfcuser = cfcFactions.Users 
local fpm = cfcFactions.fpm



--Any user who so much as touches factions will be registered
--User data should (probably) contain these elements

--[[
	SteamID64
		Last Display Name
		Date Added
		Faction ID
		Kills
		Deaths
		Rank
		Hours In Faction


]]--

--Example

--[[

	8932482391201
		Display Name = Phatso
		Date Added = 4:43 PM 9/14/2019
		Faction ID = 92013218
		Kills = 0
		Deaths = 69
		Rank = Leader
		Hours In Faction = 56


]]
--Core functions missing: RegisterUser, RemoveUser, Update User, Save User (to mysql)
function cfcuser:registeruser(user, factionid, rank)

	if not user:IsPlayer() then 
		--Error out, not a player
		return 
	end

	if cfcuser:UserExists(user) then
		--Error out, already exsists
		return
	end

	local PreUserTable = {
		["DisplayName"] = user:Nick(),
		["DateAdded"] = cfcFactions:TimeStamp(),
		["LastOnline"] = cfcFactions:TimeStamp(),
		["FactionID"] = factionid and factionid or nil,
		["Kills"] = 0, 
		["Deaths"] = 0,
		["FactionRank"] = rank and rank or nil,
		["HoursInFaction"] = nil,
		["CFCPermissions"] = {},
		["InternalFactionPermissions"] = nil

	}
	cfcuser[user:SteamID64()] = PreUserTable

end

--Checks if a user is already registered
function cfcuser:UserExists(user)

	if not user:IsPlayer() then 
		--Error out, not a player
		return 
	end

	if table.HasValue(cfcuser, user:SteamID64()) then
		return true
	else
		return false
	end
end


function cfcuser:UpdateUser(user, lastonline, factionid, kills, deaths, factionrank, hoursinfaction)

end

function cfcuser:UpdateStats(user, lastonline, kills, deaths, hoursinfaction)

end
--


function cfcuser:SetUserRank(user, rank)

end

function cfcuser:SetUserFaction(user, id, rank)
	if not user:IsPlayer() then 
		--Error out, not a player
		return 
	end

	if not cfcFactions:IsValidFaction(id) then
		--Error out, invalid faction
		return
	end
	local GetFactionUser = cfcuser[user:SteamID64()]
	GetFactionUser.FactionID = id
	GetFactionUser.FactionRank = rank
end


--incomplete till factions is finished
function cfcuser:SetUserContract(user, contract)


end

function cfcuser:RemoveUserRank(user)

end

function cfcuser:RemoveUserFaction(user)

end

--incomplete till factions is finished
function cfcuser:RemoveUserContract(user)

end

function cfcuser:AddUserInvite(user, id, inviter)

end

function cfcuser:RemoveUserInvite(user, id, revoker)

end

function cfcuser:IsInFaction(user) 
	if not user:IsPlayer() then
		return
	end

	local GetFactionUser = cfcuser[user:SteamID64()]
	if GetFactionUser == nil then return false end
	if GetFactionUser.FactionID == nil then
		return false
	else
		return true
	end
end
