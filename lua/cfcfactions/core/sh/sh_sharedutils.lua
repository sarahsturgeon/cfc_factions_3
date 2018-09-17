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
    "general-error"         = "An unknown error occured",
    "invalid-ply-type"      = "Not a valid PlayerType",
    "invalid-string-type"   = "Not a valid StringType",
    "invalid-table-type"    = "Not a valid TableType",
    "invalid-int-type"      = "Not a valid IntType",
    "is-in-faction"         = "Already in a faction",
    "factions-unavailable"  = "Unable to create a faction right now",
    "database-connect-fail" = "Unable to connect to database.",
    "kick-faction-fail"     = "Cannot kick player not of same faction.",
    "kick-perm-fail"        = "Cannot kick player, incorrect permissions",
    "edit-perm-fail"        = "Cannot edit faction, you do not have this required permission. \"%s\"",
    "global-pvp-enable"     = "Cannot enable global pvp for this faction.",
    "global-pvp-disable"    = "Cannot disable global pvp for this faction.",
    "404-faction"           = "This faction does not exsist",
    "404-ply"               = "This player does not exsist",
    "faction-create-fail"   = "You cannot create any more factions",
    "invite-is-in-faction"  = "Player is already in a faction",
    "invite-is-pending"     = "Player already has a pending invite from this faction",
    "is-admin"              = "Player is an admin",
    "is-user"               = "Player is a user",
    "is-developer"          = "Player is a developer",
    "is-tester"             = "Player is a tester",
    "is-gay"                = "Cannot kick Phatso. The fuck?",
    "depreciated-key"       = "Deprecated key permission. Removing",
    "faction-ban"           = "Unable to create a faction. Banned from creating faction.",
    "contract-barred"       = "Barred from creating contracts! Request an admin.",
    "insufficient-funds"    = "You lack the required funds to allow this contract.",
    "excessive-kills"       = "Too many kills requested. Set a lower number.",
    "contract-accept-fail"  = "Unable to accept contract",
    "duplicate-name"        = "Unable to create faction, duplicate name or too similar to exsisting faction name.",
    "test-string"           = "Test String, please ignore.",
    "contract-ban"          = "Unable to create contract. Barred from creating contracts"
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
