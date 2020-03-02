-- Alert box to display realtime alerts/messages to users apart of cfcfactions

-- Someone should take a look at this file, doesn't seem correct
local cfg = cfcFactions.Config.Client

local PANEL = {}

local AlertInc = 0

function PANEL:Init()
    self:SetSize( 250, 50 )
    if type( msgtype ) ~= "table" then msgtype = cfg.MsgType.Msg end

    self.MiniPANEL = vgui.Create( "DPanel", self )
    self.MiniPANEL:SetSize( self:GetWide(), self:GetTall() )
    self.MiniPANEL:Dock( FILL )
    self.MiniPANEL:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
    self.err_icon = vgui.Create( "DImage", self.MiniPANEL )   -- Add image to Frame
    self.err_icon:SetPos( 10, 35 )  -- Move it into frame
    self.err_icon:SetSize( 555, 150 )
    self.err_icon:Dock( LEFT )

    self.ErrMsg = vgui.Create( "DLabel", self.MiniPANEL )
    self.ErrMsg:Dock( RIGHT )
    self.ErrMsg:SetColor( msgtype and msgtype ~= nil or Color( 255, 0, 0 ) )
    self.ErrMsg:SetText( msg and msg ~= nil or cfcFactions.ErrorMessages["general-error"] )

    self.CreationTime = CurTime()
    self.MiniPANEL:SetWide( #self.ErrMsg:GetText() * 6 )
end

function PANEL:Paint()
    local isOngoing = CurTime() < self.CreationTime + 5
    if isOngoing then return end

    self.CreationTime = CurTime()
    self:Remove()

    AlertInc = AlertInc + 1
end

-- ui/chat_display_text.wav
vgui.Register( "D_cfcalertboxpanel", PANEL )
