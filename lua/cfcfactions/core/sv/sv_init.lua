cfcFactions.Addons = {}
cfcFactions.Users = cfcFactions.Users or {}
cfcFactions.Factions = cfcFactions.Factions or {}

cfcFactions.logger = CFCLogger( "CFC Factions 3" )
local logger = cfcFactions.logger

-- Logger callbacks
logger:on( "error" ):call( ErrorNoHalt )
logger:on( "fatal" ):call( error )

-- sh
include( "cfcfactions/core/sh/sh_init.lua" )

-- sv
include( "cfcfactions/config/sv_config.lua" )
include( "cfcfactions/core/sv/sv_netvars.lua" )
include( "cfcfactions/core/sv/sv_users.lua" )
include( "cfcfactions/core/sv/sv_permsys.lua" )
include( "cfcfactions/core/sv/sv_mysql.lua" )

include( "cfcfactions/core/sv/sv_factions.lua" )
include( "cfcfactions/core/sv/sv_factionmanagment.lua" )
include( "cfcfactions/core/sv/sv_player_ext.lua" )

-- cl
AddCSLuaFile( "cfcfactions/config/cl_config.lua" )
AddCSLuaFile( "cfcfactions/core/cl/cl_clientstartup.lua" )
AddCSLuaFile( "cfcfactions/core/sh/sh_init.lua" )
AddCSLuaFile( "cfcfactions/core/cl/cl_init.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/tabs/cl_mainderma.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/tabs/cl_factionsderma.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/minis/cl_factionpanel.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/tabs/cl_factioneersderma.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/minis/cl_playerpanel.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/minis/cl_alertbox.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/minis/cl_faccreate.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/minis/cl_editfac.lua" )
AddCSLuaFile( "cfcfactions/core/cl/cl_utilities.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/tabs/cl_newsderma.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/tabs/cl_creditsderma.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/tabs/cl_alertsderma.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/tabs/cl_logsderma.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/util/d_imagecircle.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/util/d_listviewpretty.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/util/d_paginationbar.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/util/d_buttonpretty.lua" )
AddCSLuaFile( "cfcfactions/core/cl/dermas/util/d_cfcfactionbutton.lua" )
resource.AddFile( "resource/fonts/coolvetica.ttf" )
resource.AddFile( "resource/icons/lock.png" )
resource.AddFile( "resource/icons/no_avatar.png" )

-- Core function to initializeFactions
-- Handdles making sure SQL_DB is ran
function cfcFactions:InitializeFactions()
    if not SERVER then return end

    logger:info( "Initializing cfcFactions" )
end
hook.Add( "Initialize", "cfcInitializeFactions", cfcFactions:InitializeFactions() )

-- Player Say Hook
-- Handles if a player wishes to open the faction menu by typing the command
local function cfcPlayerSay( ply, msg )
    if string.len( cfcFactions.Config.CHAT_COMMAND or "" ) > 0 then
        local chatTrigger = cfcFactions.Config.CHAT_COMMAND
        if string.sub( msg, 0, #chatTrigger ) == chatTrigger then
            -- Handles both opening and closing
            ply:DisplayMenu()
            return ""
        end
    end
end
hook.Add( "PlayerSay", "cfcPlayerSay", cfcPlayerSay )

-- InitialSpawn hook, fetches the data and properly sets it serverside
local function cfcOnPlayerInitialSpawn( ply )

    -- Always load a user as if never exsisted. Afterwards, load their proper data from source
    -- TODO: Instead of RegisteringUser, we load them from sql, if they're not found, THEN, we register them
    cfcFactions.Users:registerUser( ply )
end
hook.Add( "PlayerInitialSpawn", "cfcPlayerInitialSpawn", cfcOnPlayerInitialSpawn )