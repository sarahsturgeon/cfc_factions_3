if not CLIENT then return end

local PANEL = {}

function PANEL:Init()
    self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
    self.MainContainer = vgui.Create( "DPanel", self )
    self.MainContainer:Dock( FILL )

    self.NewsBox = vgui.Create( "DTextEntry", self.MainContainer )
    self.NewsBox:Dock( FILL )
    self.NewsBox:SetEditable( false )
    self.NewsBox:SetMultiline( true )

    self.NewsBox:SetText( cfcFactions.News )
    string.Replace( self.NewsBox:GetText(), "%s", LocalPlayer():Nick() )
    net.Start( "CFC_Fac_RequestNews" )
end

vgui.Register( 'D_cfcnewsderma', PANEL )

local function sendFactionNews( len, ply )
    local netIN = net.ReadString()
    local netName = net.ReadString()
    cfcFactions.News = cfcFactions.News .. string.Replace( netIN, "%s", netName )
end

net.Receive( "CFC_Fac_SendNews", sendFactionNews )
