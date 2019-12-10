local Panel = {}

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

end

function Panel:Think()

end

function cfcFactions:AddAlert( msg, mtype )

    hook.Call( "CFC_FAC_AlertAdded", _, msg, mtype )
end

vgui.Register( 'D_cfcalertsderma', Panel )

local function sendFactionMessage( len, ply )

end

net.Receive( 'CFC_Fac_SendMessage', sendFactionMessage )

function Panel:CreateAlert( msg, type )
    -- if self.AlertPanel == nil then return end
    -- if #self.AlertPanel:GetChildren() > 0 then self:ClearAlerts() end

    -- local Alert = vgui.Create( "D_cfcalertboxpanel", self.AlertPanel )
    -- Alert:SetWide( self.AlertPanel:GetWide() )
    -- Alert:SetTall( self.AlertPanel:GetTall() )
    -- Alert.ErrMsg:SetText( msg )

    -- if #msg >= 25 then
    --     Alert.ErrMsg:SetFont( "CFC_Alert_Small" )
    -- else
    --     Alert.ErrMsg:SetFont( "CFC_Alert" )
    -- end

    -- Alert.ErrMsg:SetColor( MsgType[type] )
    -- Alert.ErrMsg:SetSize( Alert:GetWide(), Alert:GetTall() )
    -- Alert:Dock( FILL )
    -- surface.PlaySound( "buttons/button15.wav" )
end

--net.Receive( 'CFC_Fac_SendServerTextAlert', sendServerTextAlert )