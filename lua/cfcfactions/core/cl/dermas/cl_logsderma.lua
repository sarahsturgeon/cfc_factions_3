local Panel = {}
cfcFactions:RegisterDermaMenu( "View Logs", Panel, 1 )

local LocalPanelView = 1 --1 is Normal logs, 2 is admin logs

function Panel:Init()
    --Switch between 2 views
    --Regular Logs, Admin Logs ( Sees ALL logs )
end

function Panel:Paint( w, h )

end

function Panel:Think()

end

vgui.Register( 'D_logsdermasderma', Panel )

--TODO: tie in to the system

local function fetchFactionAlerts()
    
end

net.Receive( "CFC_Fac_FetchAlerts", fetchFactionAlerts )

local function addFactionAlert()
    
end

net.Receive( "CFC_Fac_AddAlert", addFactionAlert )

local function fetchAdminFactionAlerts()
    
end

net.Receive( "CFC_Fac_FetchAdminAlerts", fetchAdminFactionAlerts )

local function addAdminFactionAlert()
    
end

net.Receive( "CFC_Fac_AddAdminAlert", addAdminFactionAlert )
