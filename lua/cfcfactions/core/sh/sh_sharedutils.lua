--[[]
File Name: sh_sharedutils.lua

Purpose: Shared functions that contain various useful tables and functions used across cfcFactions

Global Tables: cfcFactions.Dermas,cfcFactions.Alerts, cfcFactions.ErrorMessages

]]--



local net = net
local string = string
local table = table



--Sends a notifaction msg:string, mtype:number, player:entity


cfcFactions.ErrorMessages = {
    "generalError"          = "An unknown error occured",
    "invalidPlyType"        = "Not a valid PlayerType",
    "invalidStringType"     = "Not a valid StringType",
    "invalidTableType"      = "Not a valid TableType",
    "invalidIntType"        = "Not a valid IntType",
    "isInFaction"           = "Already in a faction",
    "factionUnavailability" = "Unable to create a faction right now",
    "databaseConnectFail"   = "Unable to connect to database.",
    "kickFactionFail"       = "Cannot kick player not of same faction.",
    "kickPermFail"          = "Cannot kick player, incorrect permissions",
    "editPermFail"          = "Cannot edit faction, you do not have this required permission. \"%s\"",
    "globalPvpEnable"       = "Cannot enable global pvp for this faction.",
    "globalPvpDisable"      = "Cannot disable global pvp for this faction.",
    "404Faction"            = "This faction does not exsist",
    "404Ply"                = "This player does not exsist",
    "factionCreateFail"     = "You cannot create any more factions",
    "inviteIsInFaction"     = "Player is already in a faction",
    "inviteIsPending"       = "Player already has a pending invite from this faction",
    "isAdmin"               = "Player is an admin",
    "isUser"                = "Player is a user",
    "isDeveloper"           = "Player is a developer",
    "isTester"              = "Player is a tester",
    "isGay"                 = "Cannot kick Phatso. The fuck?",
    "depreciatedKey"        = "Deprecated key permission. Removing",
    "factionBan"            = "Unable to create a faction. Banned from creating faction.",
    "contractBarred"        = "Barred from creating contracts! Request an admin.",
    "insufficientFunds"     = "You lack the required funds to allow this contract.",
    "excessiveKills"        = "Too many kills requested. Set a lower number.",
    "contractAcceptFail"    = "Unable to accept contract",
    "duplicateName"         = "Unable to create faction, duplicate name or too similar to exsisting faction name.",
    "testString"            = "Test String, please ignore.",
    "contractBan"           = "Unable to create contract. Barred from creating contracts"
}





function cfcFactions:TimeStamp()
	return os.date( "%H:%M:%S - %d/%m/%Y" , os.time())
end

function cfcFactions:UUID()
    local template ='xxxxxxxxxxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 9) or math.random(0, 9)
        return string.format('%x', v)
    end)
end

--TODO: add "respond" option, enabled SendNotifcation to tell the user to respond to whatever alert is showing. 
function cfcFactions:SendNotifcation(msg, mtype, player)
	if type(msg) == "number" then msg = cfcFactions.ErrorMessages
[msg] and cfcFactions.ErrorMessages
[msg] or "" end
	print(string.format("Sending notifcation for %s, msg=%s, type=%s",(player:Nick() and player:Nick() or "InvalidPlayer"),msg,mtype))
	
	--only 4 types of error types. 
	if mtype == nil then mtype = 1 end
	if mtype > 4 then mtype = 1 end
	if mtype < 1 then mytype = 1 end

	if CLIENT then
		
		if #msg <= 256 then
			if not player:IsPlayer() then
				MsgN(msg, mtype)
				return
			end
			net.Start("CFC_Fac_SendTextAlert")
			net.WriteString(msg)
			net.WriteInt(mtype,4)
			if player:IsPlayer() then
				net.WriteEntity(player)
			else
				net.WriteEntity(nil)
			end
			net.SendToServer()
		end
	end

	if SERVER then
		
		if #msg <= 256 then
			if player:IsPlayer() and IsValid(player) then
				net.Start("CFC_Fac_SendServerTextAlert")
				net.WriteString(msg)
				net.WriteInt(mtype,4)
				net.WriteEntity(player)
				net.Send(player)
			else
				MsgN(msg)
			end
		end


	end
end


-- function cfcFactions.includeFile( filename, state )
--     if state == frile.STATE_SHARED or filename:find( "sh_" ) then
--         if SERVER then AddCSLuaFile( filename ) end
--         include( filename )
--     elseif state == frile.STATE_SERVER or SERVER and filename:find( "sv_" ) then
--         include( filename )
--     elseif state == frile.STATE_CLIENT or filename:find( "cl_" ) then
--         if SERVER then AddCSLuaFile( filename )
--         else include( filename ) end
--     end
-- end

-- function cfcFactions.includeFolder( currentFolder, ignoreFilesInFolder, ignoreFoldersInFolder )
--     if file.Exists( currentFolder .. "sh_frile.lua", "LUA" ) then
--         frile.includeFile( currentFolder .. "sh_frile.lua" )

--         return
--     end

--     local files, folders = file.Find( currentFolder .. "*", "LUA" )

--     if not ignoreFilesInFolder then
--         for _, File in ipairs( files ) do
--             frile.includeFile( currentFolder .. File )
--         end
--     end

--     if not ignoreFoldersInFolder then
--         for _, folder in ipairs( folders ) do
--             frile.includeFolder( currentFolder .. folder .. "/" )
--         end
--     end
-- end
