if not CLIENT then return end

local Panel = {}
local lastCount = -1
cfcFactions:RegisterDermaMenu("My Alerts",Panel,3)


--converts message type to a pretty string for the user
local function printyprint(number)
    if number == 1 then
        return "Message"
    elseif number == 2 then
        return "Alert"
    elseif number == 3 then
        return "Debug"
    elseif number == 4 then
        return "Error"
    else
        return"Message"
    end
end
local function drawAlertsTable(main_panel)
    
    if lastCount == -1 then
        MsgN("Current number of alerts: #" .. #cfcFactions.Alerts)
    end
    if (#cfcFactions.Alerts ~= lastCount) or (lastCount == -1) then
        main_panel.logview:Clear()
        for k, logs in pairs(cfcFactions.Alerts) do
            main_panel.logview:AddLine(logs.Time, logs.Message,printyprint(logs.Type))
            
        end
        lastCount = #cfcFactions.Alerts

    end
end



function Panel:Init()
    --self:SetSize(self:GetWide(), 25)
    self.subpanel = vgui.Create("DPanel", self)
    self.subpanel:Dock(FILL)



    self.logview = vgui.Create("DListView", self.subpanel)
    self.logview:Dock(FILL)


    self.column_time = self.logview:AddColumn("Time", _, 1)

    self.column_message = self.logview:AddColumn("Message", _, 2)
    self.column_message:SetTextAlign(5)

    self.column_type = self.logview:AddColumn("Type", _, 3)



end
function Panel:Paint(w, h)
    --TODO: let off some processing time here and only check if the #alerts has changed
    drawAlertsTable(self)

end
function Panel:Think()

end

vgui.Register('D_cfcalertsderma', Panel)