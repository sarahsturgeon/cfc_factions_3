local PANEL = {}
local cfg = cfcFactions.Config.ColorSchemes
vgui.Register( "D_cfc_tab_faction", PANEL )

function PANEL:Init()
    self.header = vgui.Create( "DPanel", self )
    self.header:Dock( TOP )
    self:InitHeader( self.header )
end

function PANEL:InitHeader( header )
    header:SetBackgroundColor( cfg.BackgroundPanel )
    header.Paint = cfcFactions.solidBgPaint
end

function PANEL:PerformLayout( w, h )
    self.header:SetTall( h / 5 )
end

hook.Add( "cfc_Fac_AddMenuTabs", "cfc_Fac_AddFaction", function( panel )
    panel:AddMenuTab( "My Faction", vgui.Create( "D_cfc_tab_faction" ) )
end )
