--Alert box to display realtime alerts/messages to users apart of cfcfactions
local cfg = cfcFactions.Config.Client

local Panel = {}

local ErrMsg = nil
local ErrType = nil
local AlertInc = 0

function Panel:Init()
    self:SetSize( 250, 50 )
    if not type( msgtype ) == "table" then msgtype = cfg.MsgType.Msg end

    self.MiniPanel = vgui.Create( "DPanel", self )
    self.MiniPanel:SetSize( self:GetWide(), self:GetTall() )
    self.MiniPanel:Dock( FILL )
    self.MiniPanel:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
    self.err_icon = vgui.Create( "DImage", self.MiniPanel )   -- Add image to Frame
    self.err_icon:SetPos( 10, 35 )  -- Move it into frame
    self.err_icon:SetSize( 555, 150 )   
    self.err_icon:Dock( LEFT )

    self.ErrMsg = vgui.Create( "DLabel", self.MiniPanel )
    self.ErrMsg:Dock( RIGHT )
    self.ErrMsg:SetColor( msgtype and msgtype ~= nil or Color( 255, 0, 0 ) )
    self.ErrMsg:SetText( msg and msg ~= nil or cfcFactions.ErrorMessages["general-error"] )

    self.CreationTime = CurTime()
    self.MiniPanel:SetWide( #self.ErrMsg:GetText()*6 )
end

function Panel:Paint()
    local isOngoing = CurTime() < self.CreationTime + 5
    if isOngoing then return end

    self.CreationTime = CurTime()
    self:Remove()

    AlertInc = AlertInc +1
end

--ui/chat_display_text.wav
vgui.Register( 'D_cfcalertboxpanel', Panel )
