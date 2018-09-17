cfcFactions.Addons = {}
cfcFactions.Users = cfcFactions.Users or {}
cfcFactions.Factions = cfcFactions.Factions or {}

--sh
include("cfcfactions/core/sh/sh_init.lua")

--sv
include("cfcfactions/config/sv_config.lua")
include("cfcfactions/core/sv/sv_netvars.lua")
include("cfcfactions/core/sv/sv_permsys.lua")
include("cfcfactions/core/sv/sv_mysql.lua")

include("cfcfactions/core/sv/sv_factions.lua")
include("cfcfactions/core/sv/sv_factionmanagment.lua")
include("cfcfactions/core/sv/sv_player_ext.lua")

--cl
AddCSLuaFile("cfcfactions/core/cl/cl_clientstartup.lua")
AddCSLuaFile("cfcfactions/config/cl_config.lua")
AddCSLuaFile("cfcfactions/core/sh/sh_init.lua")
AddCSLuaFile("cfcfactions/core/cl/cl_init.lua")
AddCSLuaFile("cfcfactions/core/cl/dermas/cl_mainderma.lua")
AddCSLuaFile("cfcfactions/core/cl/dermas/cl_factionsderma.lua")
AddCSLuaFile("cfcfactions/core/cl/dermas/cl_usersderma.lua")
AddCSLuaFile("cfcfactions/core/cl/dermas/minis/cl_alertbox.lua")
AddCSLuaFile("cfcfactions/core/cl/cl_utilities.lua")
AddCSLuaFile("cfcfactions/core/cl/dermas/cl_newsderma.lua")
AddCSLuaFile("cfcfactions/core/cl/dermas/cl_creditsderma.lua")
AddCSLuaFile("cfcfactions/core/cl/dermas/cl_alertsderma.lua")
AddCSLuaFile("cfcfactions/core/cl/dermas/cl_logsderma.lua")
resource.AddFile("resource/fonts/coolvetica.ttf")


function cfcFactions:LoadNews()
    if not file.Exists("cfcfactions/news.txt", "DATA" ) then print("Unable to load news") return end
    local NewsFile = file.Read("cfcfactions/news.txt", "DATA" )
    return NewsFile
end

--Core function to initilizeFactions
    --Handdles making sure SQL_DB is ran
function cfcFactions:InitializeFactions()
    if not SERVER then return end
    MsgN("Initializing cfcFactions")


    --Make sure tables exsist
    if sql_db == nil then   
        Error("Unable to initilize mysql data object. Make sure there are no errors in config.")

    end
    sql_db:initilize()

    --un needed but might as well
    if not file.IsDir('cfcFactions', 'DATA') then
        file.CreateDir('cfcFactions','DATA')
    end
    if not file.Exists("cfcfactions/news.txt", "DATA") then
        file.Write("cfcfactions/news.txt","")
    end
    --load news
    cfcFactions:LoadNews()

end
hook.Add("Initialize", "cfcInitializeFactions", cfcFactions:InitializeFactions())







--Player Say Hook
    --Handles if a player wishes to open the faction menu by typing the command
local function cfcPlayerSay(ply, msg)
    if string.len(cfcFactions.Config.CHAT_COMMAND) > 0 then
        local chatTrigger = cfcFactions.Config.CHAT_COMMAND
        if (string.sub(msg, 0, #chatTrigger) == chatTrigger) then
            --Handles both opening and closing
            ply:DisplayMenu()
            return ''
        end
    end
end
hook.Add('PlayerSay', 'cfcPlayerSay', cfcPlayerSay)



--InitialSpawn hook, fetches the data and properly sets it serverside
local function cfcOnPlayerInitialSpawn(ply)
    for k ,v in pairs(string.Explode("\n",cfcFactions:LoadNews())) do
        net.Start("CFC_Fac_SendNews")
        net.WriteString(v .. "\n")
        net.WriteString(ply:Nick())
        net.Send(ply)
    end
    --ply:FetchUserData()
end
hook.Add("PlayerInitialSpawn", "cfcPlayerInitialSpawn", cfcOnPlayerInitialSpawn)

--PlayerSpawn hook
    --handles loading the user and properly setting their faction upon entering the server
local function cfcPlayerSpawn(ply)
    if not IsValid(ply) then return end
    ply:FetchUserData()

end

hook.Add("PlayerSpawn", "cfcPlayerSpawn", cfcPlayerSpawn(ply))

