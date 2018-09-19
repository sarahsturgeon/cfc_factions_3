--[[]
File Name: sv_dbhandler.lua

Purpose: Core database handler to save/load from ether mysql or sql (external/internal)

Global Tables: cfcFactions.DB
]]--

cfcFactions.DB = cfcFactions or {}
cfcFactions.DB.LastSaved = nil
local DB = cfcFactions.DB

function DB:Init()
    if cfcFactions.Config.Server.DB_Stance == "MySQL" then
        sql_db:initilize()
    elseif DB_Stance == "SQL" then

    else
        --sql
    end
end

--[[
    [Users DB Functions]
]]--

--Saving Users to mysql_db
function DB:SaveUsers()

end

function DB:SaveUser(id)

end

--Loading Users from mysql_db
function DB:LoadUsers()

end

--id can be player, steamid, steamid64, or unqui
function DB:LoadUser(id)

end
--[[
    [Factions DB Functions]
]]--

--Saveing factions to mysql_db
function DB:SaveFaction(factionid)

end

function DB:SaveFactions()

end

--Loading factions to mysql_db
function DB:LoadFaction(factionid)

end

function DB:LoadFactions()

end

--[[
    [Permissions DB Functions]
]]--

--[[
    [MISC DB Functions]
]]--

--Global function to refresh both users, factions, and everything in between
function DB:Refresh()

end
