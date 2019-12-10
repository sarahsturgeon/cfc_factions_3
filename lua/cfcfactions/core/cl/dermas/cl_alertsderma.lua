if not CLIENT then return end

local Panel = {}
local cfcFactions.Client.Alerts = cfcFactions.Client.Alerts or {}


-- converts message type to a pretty string for the user
local function printyprint( number )
    local alertStruct = {
        1 = "Message",
        2 = "Alert", 
        3 = "Debug" 
    }
    return alertStruct[number] and alertStruct[number] or 1
end

local function drawAlertsTable( main_panel )
    if lastCount == -1 then
        MsgN( "Current number of alerts: #" .. #cfcFactions.Alerts )
    end
    if ( #cfcFactions.Alerts ~= lastCount ) or ( lastCount == -1 ) then
        main_panel.logview:Clear()
        for k, logs in pairs( cfcFactions.Alerts ) do
            main_panel.logview:AddLine( logs.Time, logs.Message, printyprint( logs.Type ) )

        end
        lastCount = #cfcFactions.Alerts

    end
end

function Panel:Init()
    -- self:SetSize( self:GetWide(), 25 )
    self.subpanel = vgui.Create( "DPanel", self )
    self.subpanel:Dock( FILL )

    self.logview = vgui.Create( "DListView", self.subpanel )
    self.logview:Dock( FILL )

    self.column_time = self.logview:AddColumn( "Time", _, 1 )

    self.column_message = self.logview:AddColumn( "Message", _, 2 )
    self.column_message:SetTextAlign( 5 )

    self.column_type = self.logview:AddColumn( "Type", _, 3 )
end

function Panel:Paint( w, h )
    -- TODO: let off some processing time here and only check if the #alerts has changed
    drawAlertsTable( self )
end

function Panel:Think()

end

function cfcFactions:AddAlert( msg, mtype )
    if mtype == nil then mtype = MsgType.Msg end
    table.insert( cfcFactions.Alerts, {["Message"] = msg, ["Type"] = mtype, ["Time"] = os.date( "%T ", os.time() )} )
    cfcFactions:AddToAlertPanel( msg, mtype )
    hook.Call( "CFC_FAC_AlertAdded", _, msg, mtype )
end

vgui.Register( 'D_cfcalertsderma', Panel )

local function sendFactionMessage( len, ply )

end

net.Receive( 'CFC_Fac_SendMessage', sendFactionMessage )

local function sendServerTextAlert( len, ply )
    local msg = net.ReadString()
    local mtype = net.ReadInt( 4 )
    local ment = net.ReadEntity()

    if cfcFactions.MainDerma ~= nil then
        cfcFactions.MainDerma:CreateAlert( msg, mtype )
    end
end

--net.Receive( 'CFC_Fac_SendServerTextAlert', sendServerTextAlert )