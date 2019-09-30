--[[]
File Name: sv_users.lua

Purpose: Core faction's functions to create, edit, and destory users who use factions

Global Tables: cfcFactions.Users
]]--
cfcFactions.Users = cfcFactions.Users or {}
local cfcuser = cfcFactions.Users 
local fpm = cfcFactions.fpm

--Registers a new user to be accessible by factions
function cfcuser:registeruser(user, factionid, rank)

	if not user:IsPlayer() then 
		--Error out, not a player
		return 
	end

	if cfcuser:UserExists( user ) then
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
		["InternalFactionPermissions"] = nil,
		["PendingInvites"] = {}

	}
	cfcuser[user:SteamID64()] = PreUserTable

end

--Checks if a user is already registered
function cfcuser:UserExists( user )

	if not user:IsPlayer() then 
		--Error out, not a player
		return 
	end

	if table.HasValue(cfcuser, user:SteamID64( ) ) then
		return true
	else
		return false
	end
end

local function IsValidAndOfType(item, t)
    return item ~= nil and type( item ) == t
end

local function IsValidNumber( num )
    return IsValidAndOfType(num, 'number')
end

local function IsValidString( str )
    return IsValidAndOfType(str, 'string')
end

--Used to update a player's table of associated variables
function cfcuser:UpdateUser(user, lastonline, factionid, kills, deaths, factionrank, hoursinfaction)
    if not cfcuser:UserExists( user ) then return end

    local userTable = cfcuser[user:SteamID64()]
    if IsValidString( lastonline ) then userTable["LastOnline"] = lastonline end
    if IsValidNumber( factionId ) and cfcFactions:IsValidFaction( factionid ) then 
        userTable["FactionId"] = factionid 
    end    
    if IsValidNumber( kills ) then userTable["Kills"] = kills end
    if IsValidNumber( deaths ) then userTable["Deaths"] = deaths end
    if IsValidString( factionrank ) then userTable["FactionRank"] = factionrank end
    if IsValidNumber( hoursinfaction ) and hoursinfaction > 0 then userTable["HoursInFaction"] = hoursinfaction end
end

--Used to update values that may change quickly
function cfcuser:UpdateStats(user, lastonline, kills, deaths, hoursinfaction)
    if not cfcuser:UserExists( user ) then return end

    local userTable = cfcuser[user:SteamID64()]
    if IsValidString( lastonline ) then userTable["LastOnline"] = lastonline end
    if IsValidNumber( kills ) then userTable["Kills"] = kills end
    if IsValidNumber( deaths ) then userTable["Deaths"] = deaths end
    if IsValidNumber( hoursinfaction ) and hoursinfaction > 0 and IsInFaction( user ) then userTable["HoursInFaction"] = hoursinfaction end
end
--


function cfcuser:SetUserRank(user, rank)

end

function cfcuser:SetUserFaction(user, id, rank)
	if not user:IsPlayer() then 
		--Error out, not a player
		return 
	end

	if not cfcFactions:IsValidFaction( id ) then
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

function cfcuser:RemoveUserRank( user )

end

function cfcuser:RemoveUserFaction( user )

end

function cfcuser:AddUserInvite(user, id, inviter)

end

function cfcuser:RemoveUserInvite(user, id, revoker)

end

function cfcuser:IsInFaction( user ) 
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
