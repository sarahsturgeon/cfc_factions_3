--[[]
File Name: sv_factions.lua

Purpose: Core faction's functions to create, edit, and destory

Global Tables: cfcFactions.Factions
]]--
if not SERVER then return end

local file = file
local table = table
local net = net
local util = util
local table = table
local fpm = cfcFactions.fpm
local cfg = cfcFactions.Config.Server

cfcFactions.Factions = cfcFactions.Factions or {}


function cfcFactions:CreateFaction(Owner, Name, Color, Description, InviteOnly)
	
	local TmpUnqID = cfcFactions:UUID()
	local factionOwner = Owner
	local factionName = Name
	local factionColor = Color
	local factionDescription = Description
	local factionInviteOnly = InviteOnly


	----------------
	--todo: remove
	--Testing notifcations
	----------------
	if(nil) then
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["generalError"], 1, nil)
	end


	----------------
	--[type checks]
	----------------
	if (not type(factionOwner) == "Player") then
		--Send Alert -> Not a valid PlayerType
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["invalid-ply-type"], 1, nil)
		return
	end

	if (not type(factionName) == "string") then
		--Send Alert -> Not a valid NameType
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["invalid-string-type"], 1, Owner)
		return
	end

	if (not type(factionColor) == "table") then
		--Send Alert -> Not a valid ColorType
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["invalid-table-type"], 1, Owner)
		return
	end

	if (not type(factionDescription) == "string") then
		--Send Alert -> Not a valid DescriptionType
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["invalid-string-type"], 1, Owner)
		return
	end

	if (not type(factionInviteOnly) == "boolean") then
		--Send Alert -> Not a valid IntType
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["invalid-int-type"], 1, Owner)
		return
	end

	if (not factionOwner:IsPlayer()) or (not IsValid(factionOwner)) then
		--SendAlert -> Not a valid player
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["general-error"], 1, nil)
		return
	end

	if (factionOwner:IsInFaction()) then
		--SendAlert -> Already in a Faction
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["is-in-faction"], 1, Owner)
	end






	--[Permissions]
	if (not fpm:hasPermission(factionOwner, "CanCreateFaction")) then
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["faction-ban"], 1, Owner)
		--todo: make return here
		--return
	end




	--IsInFaction Check
	if factionOwner:IsInFaction() == true then 
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["is-in-faction"], 1, Owner)
		return 
	end
	--UniqueName Check
	if not cfcFactions:isUniqueName(factionName) then 
		cfcFactions:SendNotifcation(cfcFactions.ErrorMessages["is-in-faction"], 1, Owner)
		return
	end
	--



	--What should a faction contain? 
	cfcFactions.Factions[TmpUnqID] = {
		["ID"] = TmpUnqID,
		["Name"] = factionName,
		["Ranks"] = cfcFactions.fpm.defaultRanks,
		["Owner"] = factionOwner:SteamID64(),
		["Description"] = factionDescription,
		["Color"] = factionColor,
		["Invite"] = factionInviteOnly,
		["Kills"] = 0,
		["Deaths"] = 0,
		["XP"] = 0,
		["Currency"] = 0,
		["Created"] = cfcFactions:TimeStamp(),
		["Edited"] = cfcFactions:TimeStamp(),
		["LastSaved"] = nil,
		["NeedsCleanUp"] = false,
		["Allies"] = {},
		["Enemies"] = {},
		["Contracts"] = {},
		["Talents"] = nil,



	}
	local owner = fpm.Users[factionOwner:SteamID64()]
	--set user id and rank using ply:Set functions
	owner.FactionID = TmpUnqID
	owner.FactionRank = cfcFactions.Factions[TmpUnqID].Ranks["Leader"]

	--function cfcFactions:SaveFaction(factionid)
	--function cfcFactions:SaveUser(userid)
	cfcFactions:SendNotifcation(string.format("Successfully created \"%s\" with ID [%s]",cfcFactions.Factions[TmpUnqID].Name, cfcFactions.Factions[TmpUnqID].ID), 1, Owner)
	---Returns the newly created faction as a table
	return cfcFactions.Factions[TmpUnqID]

end

--Checks a specifc string to see if it is unique amongst other factions.
function cfcFactions:isUniqueName(faction_name)
	for k,v in pairs(cfcFactions.Factions) do
		if string.lower(string.Trim(v.Name)) == string.lower(string.Trim(faction_name)) then
			return false
		end
	end
	return true
	
end

function cfcFactions:IsValidFaction(id)
	if (cfcFactions.Factions[id] == nil) then return false end
	return true

end

function cfcFactions:SetAlly(id)

end

function cfcFactions:SetEnemy(id)

end

function cfcFactions:RemoveAlly(id)

end

function cfcFactions:RemoveEnemy(id)

end


--Edits a faction based on ID, player is who ever is editing it
function cfcFactions:EditFaction(id, name, color, description, inviteOnly, player)

	--Can't edit a non valid faction
	if not cfcFactions:IsValidFaction(id) then

	end
	local faction = cfcFactions.Factions[id]

	--Check if user can edit the faction, 

	--CanEditAll, CanEditDescription, CanEditName, CanEditColor, CanEditInvite


	--if IsAdmin or IsDeveloper, allow freely edit of a faction
	if fpm:IsDeveloper(player) or fpm:IsFactionAdmin(player) then
	


	else
	--else check for normal permissions
	--ONLY IF, that specific element is being edited. 

		if not fpm:hasPermission(player, "CanEditAll") then

		end

		--if string ~= string then
		if not fpm:hasPermission(player, "CanEditDescription") then

		end
		--end
		if not fpm:hasPermission(player, "CanEditDescription") then

		end
		if not fpm:hasPermission(player, "CanEditDescription") then

		end
		if not fpm:hasPermission(player, "CanEditDescription") then

		end

	end



	--save to db

	--send to players
end

--Handles removing a faction(s) and its attached users properly
function cfcFactions:RemoveFaction(ply, id)
	if fpm:IsDev(ply) then
		if cfcFactions.Factions[id] ~= nil then
			cfcFactions.Factions[id] = nil
			ply:SetFactionID(nil)
			ply:SetFactionRank(nil)
			--todo: Remove all players too
		end
	end
end


net.Receive("CFC_Fac_RequestNews", function(len, ply)
	for k ,v in pairs(string.Explode("\n",cfcFactions:LoadNews())) do
		net.Start("CFC_Fac_SendNews")
		net.WriteString(v .. "\n")
		net.WriteString(ply:Nick())
		net.Send(ply)
	end
end)
