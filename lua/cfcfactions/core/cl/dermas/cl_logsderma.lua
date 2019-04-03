local Panel = {}
cfcFactions:RegisterDermaMenu("View Logs", Panel, 1)

local LocalPanelView = 1 --1 is Normal logs, 2 is admin logs

function Panel:Init()
    --Switch between 2 views
    --Regular Logs, Admin Logs (Sees ALL logs)
end

function Panel:Paint(w, h)

end

function Panel:Think()

end

vgui.Register('D_logsdermasderma', Panel)

--TODO: tie in to the system

local function fetchAlerts()
    
end

net.Receive("FetchAlerts", fetchAlerts)

local function addAlert()
    
end

net.Receive("AddAlert", addAlert)

local function fetchAdminAlerts()
    
end

net.Receive("FetchAdminAlerts", fetchAdminAlerts)

local function addAdminAlert()
    
end

net.Receive("AddAdminAlert", addAdminAlert)
