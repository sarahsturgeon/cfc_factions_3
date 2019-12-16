local PANEL = {}
local cfg = ColorSchemes
vgui.Register( 'D_factionpanel', PANEL )
function PANEL:Init()
    self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 50, 0, ScrH() ) )
    self.Faction = nil

    self.MainPanel = vgui.Create( "DPanel", self )
    self.MainPanel:Dock( FILL )

    self.RightControls = vgui.Create( "DPanel", self.MainPanel )
    self.BottomControls = vgui.Create( "DPanel", self.MainPanel )


    self.FactionName = vgui.Create( "DLabel", self.MainPanel )
    self.FactionName:SetText( "My Faction" )
    self.FactionName:SetTextColor( cfg.NormalText )

    self.FactionID = vgui.Create( "DPanel", self.MainPanel )
    self.FactionID:SetText( "0" )
    self.FactionID:SetTextColor( cfg.NormalText )
end
--faction functions to set this panel up