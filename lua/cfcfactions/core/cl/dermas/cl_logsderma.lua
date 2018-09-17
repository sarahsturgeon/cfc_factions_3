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


--todo: tie in to the system
net.Receive("FetchAlerts", function()

end)


net.Receive("AddAlert", function()

end)

net.Receive("FetchAdminAlerts", function()

end)

net.Receive("AddAdminAlert", function()

end)