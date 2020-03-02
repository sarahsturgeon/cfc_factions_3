local cfg = ColorSchemes

function cfcFactions.addFactionButton( self, text, lineHeight )
    local btn = vgui.Create( "DButtonPretty", self.BottomGrid )
    btn:SetText( text )
    btn:Dock( LEFT )
    btn:DockMargin( 0, 5 + lineHeight, 5, 5 )
    btn:SetBackgroundColor( cfg.MiniPanelHeader )
    btn:SetSize( 100, 0 )
    return btn
end