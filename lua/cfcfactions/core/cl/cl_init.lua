require( "cfc_promises" )

cfcFactions = cfcFactions or {}
include( "cfcFactions/config/cl_config.lua" )
include( "cfcFactions/config/sh_config.lua" )
-- TODO: Move this
include( "cfcFactions/constants/constants.lua" )
include( "cfcfactions/core/cl/cl_clientstartup.lua" )
include( "cfcfactions/core/sh/sh_init.lua" )
include( "cfcfactions/core/cl/dermas/tabs/cl_mainderma.lua" )
include( "cfcfactions/core/cl/dermas/tabs/cl_factionsderma.lua" )
include( "cfcfactions/core/cl/dermas/minis/cl_factionpanel.lua" )
include( "cfcfactions/core/cl/dermas/tabs/cl_factioneersderma.lua" )
include( "cfcfactions/core/cl/dermas/minis/cl_playerpanel.lua" )
include( "cfcfactions/core/cl/dermas/tabs/cl_newsderma.lua" )
include( "cfcfactions/core/cl/dermas/minis/cl_alertbox.lua" )
include( "cfcfactions/core/cl/dermas/minis/cl_faccreate.lua" )
include( "cfcfactions/core/cl/cl_utilities.lua" )
include( "cfcfactions/core/cl/dermas/tabs/cl_creditsderma.lua" )
include( "cfcfactions/core/cl/dermas/tabs/cl_alertsderma.lua" )
include( "cfcfactions/core/cl/dermas/tabs/cl_logsderma.lua" )
include( "cfcfactions/core/cl/dermas/util/d_imagecircle.lua" )
include( "cfcfactions/core/cl/dermas/util/d_listviewpretty.lua" )
include( "cfcfactions/core/cl/dermas/util/d_paginationbar.lua" )
include( "cfcfactions/core/cl/dermas/util/d_buttonpretty.lua" )
include( "cfcfactions/core/cl/dermas/util/d_cfcfactionbutton.lua" )

-- TODO remove for deployment
concommand.Add( "cfc_factions_reload", function()
    cfcFactions.MainFrame = nil
    print( "Reloading factions..." )
    include( "cfcfactions/core/cl/cl_init.lua" )
end )
