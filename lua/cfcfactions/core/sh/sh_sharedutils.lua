--[[]
File Name: sh_sharedutils.lua

Purpose: Shared functions that contain various useful tables and functions used across cfcFactions

Global Tables: cfcFactions.Dermas,cfcFactions.Alerts, cfcFactions.ErrorTypes
]]--



local net = net
local string = string
local table = table



--Sends a notifaction msg:string, mtype:number, player:entity


cfcFactions.ErrorTypes = {
	[0] = "An unknown error occured",
	[1] = "Not a valid PlayerType",
	[2] = "Not a valid StringType",
	[3] = "Not a valid TableType",
	[4] = "Not a valid IntType",
	[5] = "Already in a faction",
	[6] = "Unable to create a faction right now",
	[7] = "Unable to connect to database.",
	[8] = "Cannot kick player not of same faction.",
	[9] = "Cannot kick player, incorrect permissions",
	[10] = "Cannot edit faction, you do not have this required permission.",
	[11] = "Cannot enable global pvp for this faction.",
	[12] = "Cannot disable global pvp for this faction.",
	[13] = "This faction does not exsist",
	[14] = "This player does not exsist",
	[15] = "You cannot create any more factions",
	[16] = "Player is already in a faction",
	[17] = "Player already has a pending invite from this faction",
	[18] = "Player is an admin",
	[19] = "Player is a user",
	[20] = "Cannot kick Phatso. The fuck?",
	[21] = "Deprecated key permission. Removing",
	[22] = "Unable to create a faction. Banned from creating faction.",
	[23] = "Barred from creating contracts! Request an admin.",
	[24] = "You lack the required funds to allow this contract.",
	[25] = "Too many kills requested. Set a lower number.",
	[26] = "Unable to accept contract",
	[27] = "Unable to create faction, duplicate name or too similar to exsisting faction name.",
	[28] = "Test String, please ignore."
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
	if type(msg) == "number" then msg = cfcFactions.ErrorTypes[msg] and cfcFactions.ErrorTypes[msg] or "" end
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
