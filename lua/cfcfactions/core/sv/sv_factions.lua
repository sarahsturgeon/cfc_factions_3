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
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[1], 1, nil)
	end


	----------------
	--[type checks]
	----------------
	if (not type(factionOwner) == "Player") then
		--Send Alert -> Not a valid PlayerType
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[1], 1, nil)
		return
	end

	if (not type(factionName) == "string") then
		--Send Alert -> Not a valid NameType
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[2], 1, Owner)
		return
	end

	if (not type(factionColor) == "table") then
		--Send Alert -> Not a valid ColorType
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[3], 1, Owner)
		return
	end

	if (not type(factionDescription) == "string") then
		--Send Alert -> Not a valid DescriptionType
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[2], 1, Owner)
		return
	end

	if (not type(factionInviteOnly) == "boolean") then
		--Send Alert -> Not a valid IntType
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[4], 1, Owner)
		return
	end

	if (not factionOwner:IsPlayer()) or (not IsValid(factionOwner)) then
		--SendAlert -> Not a valid player
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[1], 1, nil)
		return
	end

	if (factionOwner:IsInFaction()) then
		--SendAlert -> Already in a Faction
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[5], 1, Owner)
	end






	--[Permissions]
	if (not fpm:hasPermission(factionOwner, "CanCreateFaction")) then
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[27], 1, Owner)
		--todo: make return here
		--return
	end




	--IsInFaction Check
	if factionOwner:IsInFaction() == true then 
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[5], 1, Owner)
		return 
	end
	--UniqueName Check
	if not cfcFactions:isUniqueName(factionName) then 
		cfcFactions:SendNotifcation(cfcFactions.ErrorTypes[5], 1, Owner)
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
		["Talents"] = {1,1,1,1,1}


	}
	local owner = fpm.Users[factionOwner:SteamID64()]
	owner.FactionID = TmpUnqID
	owner.FactionRank = cfcFactions.Factions[TmpUnqID].Ranks["Leader"]

	--function cfcFactions:SaveFaction(factionid)
	--function cfcFactions:SaveUser(userid)

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
function cfcFactions:EditFaction(Name, Color, Description, InviteOnly)

end


--Global function to refresh both users, factions, and everything in between
function cfcFactions:Refresh()

end


--Saving Users to mysql_db
function cfcFactions:SaveUsers()

end

function cfcFactions:SaveUser(id)

end

--Loading Users from mysql_db
function cfcFactions:LoadUsers()

end

function cfcFactions:LoadUser(id)

end




--Saveing factions to mysql_db
function cfcFactions:SaveFaction(factionid)

end

function cfcFactions:SaveFactions()

end

--Loading factions to mysql_db
function cfcFactions:LoadFaction(factionid)

end

function cfcFactions:LoadFactions()

end

function cfcFactions:LoadNews(path)
	if not file.Exists("news.txt",path ) then print("Unable to load news") return end
	local NewsFile = file.Read(path, "DATA" )

	net.Start("SendNews")
	net.WriteString(NewsFile)
	net.Send(v)

end




--Handles removing a faction(s) and its attached users properly
function cfcFactions:RemoveFaction(ply, id)

	local factioncollection = {}
	local oldid = ply:GetFactionID()
	if type(id) == "table" then 
		factioncollection = ids
	else
		table.insert(factioncollection, ids)
	end

	if #ids >= 1 then
		for k ,v in pairs(factioncollection) do
			sql_db:GetUsersByFactionID(v, function(data, onlineusers, offlineusers)

					for _, p in pairs(onlineusers) do

						--If the player's steamID64 exsist in data then we can proceed with deleting them
							if p:IsPlayer() then

								p:SetNWString("FactionID", 0)
								p:SetNWString("FactionRank","")

								--alert the user that their faction was disbanded
								net.Start("DisbandFactionClient")
								net.WriteBool(1)
								net.Send(p)
							end
					end
			end)

			sql_db:LogAction(ply,oldid, ply:SteamID64(), "DELETED")
			sql_db:DeleteFaction(v)

		end
	end
end
