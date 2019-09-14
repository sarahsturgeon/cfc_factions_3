--[[]
File Name: sv_users.lua

Purpose: Core faction's functions to create, edit, and destory users who use factions

Global Tables: cfcFactions.Users
]]--

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


--


function cfcuser:SetUserRank(player, rank)

end

function cfcuser:SetUserFaction(player, id)

end


--incomplete till factions is finished
function cfcuser:SetUserContract(player, contract)


end

function cfcuser:SetUserPermission(player, permission)

end

function cfcuser:RemoveUserRank(player)

end

function cfcuser:RemoveUserFaction(player)

end

--incomplete till factions is finished
function cfcuser:RemoveUserContract(player)

end

function cfcuser:AddUserInvite(player, id, inviter)

end

function cfcuser:RemoveUserInvite(player, id, revoker)

end

function cfcuser:SetUserPermission(player, permission)

end

function cfcuser:RemoveUserPermission(player, permission)

end

function cfcuser:IsInFaction(player) 

end
