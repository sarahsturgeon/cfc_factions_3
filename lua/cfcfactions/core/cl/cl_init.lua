require( "cfc_promises" )
cfcFactions = cfcFactions or {}

surface.CreateFont( "CFC_Normal",
    {
        font = "Default",
        size = 18,
        weight = 500
    }
)

surface.CreateFont( "CFC_Special",
    {
        font = "coolvetica",
        size = 25,
        weight = 500
    }
)

surface.CreateFont( "CFC_Alert",
    {
        font = "Arial",
        size = 45,
        weight = 100
    }
)

surface.CreateFont( "CFC_Alert_Small",
    {
        font = "Arial",
        size = 20,
        weight = 100
    }
)

surface.CreateFont( "CFC_Normal_Bold",
    {
        font = "arial",
        size = 17,
        weight = 800
    }
)
surface.CreateFont( "CFC_Normal_Bold18",
    {
        font = "arial",
        size = 18,
        weight = 800
    }
)

include( "cfcFactions/config/cl_config.lua" )
include( "cfcFactions/config/sh_config.lua" )
-- TODO: Move this
include( "cfcFactions/constants/constants.lua" )
include( "cfcfactions/core/cl/cl_clientstartup.lua" )
include( "cfcfactions/core/cl/cl_utilities.lua" )
include( "cfcfactions/core/sh/sh_init.lua" )
include( "cfcfactions/core/cl/dermas/cl_main.lua" )

include( "cfcfactions/core/cl/dermas/minis/cl_factionpanel.lua" )
include( "cfcfactions/core/cl/dermas/minis/cl_playerpanel.lua" )
include( "cfcfactions/core/cl/dermas/minis/cl_alertbox.lua" )
include( "cfcfactions/core/cl/dermas/minis/cl_faccreate.lua" )
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
