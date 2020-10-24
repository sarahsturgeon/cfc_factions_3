require "cfclogger"
require "cfc_promises"

import match, StartWith from string

cfcFactions.Addons or= {}
cfcFactions.Users or= {}
cfcFactions.Factions or= {}

cfcFactions.logger = CFCLogger "CFC Factions 3"
logger = cfcFactions.logger

-- Logger callbacks
-- Make fatal trigger a cfc webhook
-- logger\on( "fatal" )

-- sv
include "cfcFactions/config/sv_config.lua"
include "cfcFactions/core/sv/sv_api.lua"
include "cfcFactions/core/sv/sv_net.lua"
include "cfcFactions/core/sv/sv_users.lua"
include "cfcFactions/core/sv/sv_factions.lua"
include "cfcFactions/core/sv/sv_permissions.lua"

-- sh
include "cfcfactions/core/sh/sh_init.lua"

-- add files
-- lua
isLuaFile = ( fileName ) -> match fileName, "^.+%.lua$"

addFiles = ( dir ) ->
    files, dirs = file.Find "#{dir}/*", "LUA"
    return unless files

    for filePath in *files
        continue unless isLuaFile filePath

        AddCSLuaFile "#{dir}/#{filePath}"

    for dirPath in *dirs
        addFiles "#{dir}/#{dirPath}"

addFiles "cfcfactions/core/cl"
addFiles "cfcfactions/core/sh"

AddCSLuaFile "cfcfactions/config/cl_config.lua"

-- resources
resource.AddFile "resource/fonts/coolvetica.ttf"
resource.AddFile "materials/icons/lock.png"
resource.AddFile "materials/icons/no_avatar.png"
resource.AddFile "materials/icons/spinner.png"

-- Core function to initializeFactions
initializeFactions = ->
    logger\info "Initializing cfcFactions"

hook.Add "Initialize", "cfc_InitializeFactions", initializeFactions

NP.net.receive "CFC_Fac_OpenMenu", ( ply ) ->
    return true
