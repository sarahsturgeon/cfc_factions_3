--[[]
File Name: sv_factionmanagment.lua

Purpose: server-side commands to manipulate cfcFactions
]]--
if not SERVER then return end
local table = table
local string = string
local os = os
local fpm = cfcFactions.fpm

--------------------------------------------------------------------------------------------------------------
--FACTIONS MANAGMENT COMMANDS
--------------------------------------------------------------------------------------------------------------
--player:player, name:string, color:table, description:string, inviteOnly:number
concommand.Add("fpvp_createfaction", function(ply,cmd, args)
    --TODO: create faction from here
    cfcFactions:CreateFaction(ply, "My Faction", {255,0,0,255}, "My Test Faction", 1)
    PrintTable(cfcFactions.Factions)
end)

--player:player, rank:string
concommand.Add("fpvp_setrank", function(ply, cmd, args)

end)

--player:player
concommand.Add("fpvp_inviteplayer", function(ply, cmd, args)

end)

--
concommand.Add("fpvp_checkinvites", function(ply, cmd, args)

end)

--player:player
concommand.Add("fpvp_kickplayer", function(ply, cmd, args)
    local tokick = args[1]
    if tokick:IsPlayer() and toKick:GetFactionRank() ~= "Leader" then

    end
end)

--invite_id:number
concommand.Add("fpvp_clearinvite", function(ply, cmd, args)

end)

--nil
concommand.Add("fpvp_clearallpending", function(ply, cmd, args)
    if not ply:IsPlayer() then return end
    ply:SetNWBool("invitePending", false)

end)

--------------------------------------------------------------------------------------------------------------
--Permission System : tester only
--------------------------------------------------------------------------------------------------------------
--player:player, permission:string
concommand.Add("fpvp_allowpermission", function(ply,cmd,args)
    if fpm:IsValidPermission(args[1]) then
        if fpm:hasPermission(ply,"IsDeveloper") then 
            if fpm:addPermission(ply, args[1]) == true then
                ply:ChatPrint(string.format("You have been granted access: %s",args[1]))
            end
        else
            ply:ChatPrint("You require developer level permissions for this command.")
        end
    else
        ply:ChatPrint("Unknown permission was not added.")
    end
end)

--player:player, permission:string
concommand.Add("fpvp_removepermission", function(ply,cmd,args)
    if fpm:IsValidPermission(args[1]) then
        if fpm:hasPermission(ply,"IsDeveloper") then 
            if fpm:revokePermission(ply, args[1]) then
                print(string.format("Success on removing permission %s",args[1]))
            end
        else
            ply:ChatPrint("You require developer level permissions for this command.")
        end
    else
        print(string.format("Failure on removing permission %s",args[1]))
    end
end)

--player:player permission:string
concommand.Add("fpvp_checkpermission", function(ply,cmd,args)
    if fpm:IsValidPermission(args[1]) then
        if fpm:hasPermission(ply, args[1]) then 
            print(string.format("Player has proper permission %s.",args[1]))
        else
            print(string.format("Player does not have proper permission %s.",args[1]))
        end
    else
        print(string.format("%s is not a valid permission.",args[1]))
    end
end)

--Prints a list of all possible inuse permissions. 
concommand.Add("fpvp_printpermissions", function(ply, cmd, args)
    for key, value in pairs(fpm:FetchMergedPermissions()) do
        ply:PrintMessage(HUD_PRINTCONSOLE,string.format("[%s]\n\t\tDescription: %s\n\t\tAlias:%s",key, value.Description,value.Alias))
    end
end)

concommand.Add("fpvp_revokeuser", function(ply, cmd, args)
    if fpm:hasPermission(ply,"IsDeveloper") then 
        fpm:revokeUser(ply)
    else
        ply:ChatPrint("You require developer level permissions for this command.")
    end
end)

--------------------------------------------------------------------------------------------------------------
--ADMIN COMMANDS : admin only
--------------------------------------------------------------------------------------------------------------
--player:player, faction_id:number
concommand.Add("fpvp_forcesetfaction", function(ply, cmd, args)
    local factionid = args[1]
    if factionid == nil then --err out
        return 
    end
end)

--player:player
concommand.Add("fpvp_forceremovefaction", function(ply,cmd,args)

end)

--nil
concommand.Add("fpvp_viewgloballogs", function(ply,cmd,args)

end)

--------------------------------------------------------------------------------------------------------------
--MERC COMMANDS
--------------------------------------------------------------------------------------------------------------

--player, string
concommand.Add("fpvp_hiremerc", function(ply,cmd,args)

end)
--player, string
concommand.Add("fpvp_firemerc", function(ply,cmd,args)

end)

--------------------------------------------------------------------------------------------------------------
--XP COMMANDS
--------------------------------------------------------------------------------------------------------------
--nil
-- concommand.Add("fpvp_spawnxporb", function(ply,cmd,args)

-- end)
-- --time:number
-- concommand.Add("fpvp_spawnglobalxporb", function(ply,cmd,args)

-- end)
-- --nil
-- concommand.Add("fpvp_removexporb", function(ply,cmd,args)

-- end)
-- --nil
-- concommand.Add("fpvp_removeglobalxporb", function(ply,cmd,args)

-- end)

--------------------------------------------------------------------------------------------------------------
--LOGGING COMMANDS : admin only
--------------------------------------------------------------------------------------------------------------

--nil
concommand.Add("fpvp_deletealladminlogs", function(ply, cmd,args)
    --change to false later
    if not ply:IsPlayer() then
        MsgN("Deleted all adminlogs in database!")
        sql_db:DeleteAllLogs()
    else
        MsgN("Only rcon can issue this command.")
    end
end)

--nil
concommand.Add("fpvp_deletefactionlogs", function(ply,cmd,args)

end)

--id:number
concommand.Add("fpvp_forcedeletefactionlogs", function(ply,cmd,args)

end)

--------------------------------------------------------------------------------------------------------------
--CLIENT MENU COMMANDS
--------------------------------------------------------------------------------------------------------------

--nil
concommand.Add("fpvp_factionmenu", function(ply, cmd, args)
    ply:CFCToggleMenu()
end)

--nil
concommand.Add("fpvp_checkcontract", function(ply,cmd,args)

end)

concommand.Add("fpvp_createcontract", function(ply, cmd,args)

end)
--------------------------------------------------------------------------------------------------------------
--DEBUGGING COMMANDS : superadmin only
--------------------------------------------------------------------------------------------------------------

--nil
concommand.Add("fpvp_showinternals", function(ply, cmd, args)
    if ply:IsPlayer() then return end
    if IsValid(ply) then return end
    PrintTable(cfcFactions)
end)

--nil
concommand.Add('fpvp_forceinitilize', function(ply, cmd, args)
    --only rcon
    if ply:IsPlayer() then
        MsgN("Forcing mysql initlizing")
        sql_db:initilize()
    end
end)

--nil
concommand.Add("fpvp_resetdb", function(ply,cmd,args)

end)

concommand.Add("fpvp_testpermsys", function(ply, cmd,args)
    --Revoke auth
    print("Revoking user")
    cfcFactions.fpm:revokeUser(ply)

    --auth
    print("Authing user")
    cfcFactions.fpm:authUser(ply)

    --allow
    print("Allowing permission to test")
    ply:ConCommand("fpvp_allowpermission TestPerm")

    --test for allow
    ply:ConCommand("fpvp_checkpermission TestPerm")

    --remove
    print("Removing perm")
    ply:ConCommand("fpvp_removepermission TestPerm")

    --test for remove
    ply:ConCommand("fpvp_checkpermission TestPerm")
end)

concommand.Add("fpvp_debugtest", function(ply, cmd, args)
    if fpm:IsDev(ply) then
         cfcFactions:RemoveFaction(ply, ply:GetFactionID())
         ply:concommand("fpvp_createfaction")
    end
end)

concommand.Add("fpvp_debugmsg", function(ply, cmd, args)
    local argstring = ""
    for k=1, #args do
        argstring = argstring .. args[k] .. " "
    end

    if fpm:IsDev(ply) then
         cfcFactions:SendNotifcation(argstring, 3, ply)
    end
end)

--------------------------------------------------------------------------------------------------------------
--HOOKS
--------------------------------------------------------------------------------------------------------------

hook.Add("PlayerInitialSpawn","CFC_FAC_PlayerInitialSpawn",function(player)
    cfcFactions.fpm:authUser(player)
end)
