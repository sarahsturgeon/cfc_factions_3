local Panel = {}

function Panel:Init()
    self:SetSize( 500, 510 )
    self:Center()
    
    self.mainFrame = vgui.Create( "DFrame", self )
    self.mainFrame:Dock( FILL )
    self.mainFrame:SetTitle( "Create Faction" )
    self.mainFrame:MakePopup()

    self.miniPanel = vgui.Create( "DPanel", self.mainFrame )
    self.miniPanel:Dock( FILL )

    self.nameLabel = vgui.Create( "DLabel", self.miniPanel )
    self.nameLabel:SetText( "Faction name:" )
    self.nameLabel:SetTextColor( Color( 0, 0, 0 ) )
    self.nameLabel:Dock( TOP )
    self.nameLabel:DockMargin( 15, 5, 15, 0 )

    self.nameEntry = vgui.Create( "DTextEntry", self.miniPanel )
    self.nameEntry:Dock( TOP )
    self.nameEntry:DockMargin( 15, 5, 15, 0 )
    self.nameEntry:SetPlaceholderText( "Enter a faction name within 3-?? characters..." )

    self.inviteBool = vgui.Create( "DCheckBoxLabel", self.miniPanel )
    self.inviteBool:SetTextColor( Color( 0, 0, 0) )
    self.inviteBool:SetText( "Invite only?" )
    self.inviteBool:Dock( TOP )
    self.inviteBool:DockMargin( 15, 5, 15, 0 )
    self.inviteBool:SetValue( 0 )

    self.tempBool = vgui.Create( "DCheckBoxLabel", self.miniPanel )
    self.tempBool:SetTextColor( Color( 0, 0, 0) )
    self.tempBool:SetText( "Is temporary?" )
    self.tempBool:Dock( TOP )
    self.tempBool:DockMargin( 15, 5, 15, 0 )
    self.tempBool:SetValue( 0 )

    self.descLabel = vgui.Create( "DLabel", self.miniPanel )
    self.descLabel:SetText( "Faction description:" )
    self.descLabel:SetTextColor( Color( 0, 0, 0 ) )
    self.descLabel:Dock( TOP )
    self.descLabel:DockMargin( 15, 5, 15, 0 )

    self.descEntry = vgui.Create( "DTextEntry", self.miniPanel )
    self.descEntry:Dock( TOP )
    self.descEntry:DockMargin( 15, 5, 15, 0 )
    self.descEntry:SetHeight( 90 )
    self.descEntry:SetMultiline( true )
    self.descEntry:SetWrap( true )
    self.descEntry:SetPlaceholderText( "Enter a faction description... (Optional)" )

    self.colLabel = vgui.Create( "DLabel" , self.miniPanel )
    self.colLabel:SetText( "Faction color:" )
    self.colLabel:SetTextColor( Color( 0, 0, 0 ) )
    self.colLabel:Dock( TOP )
    self.colLabel:DockMargin( 15, 5, 15, 0 )

    self.colSelection = vgui.Create( "DColorMixer", self.miniPanel )
    self.colSelection:SetAlphaBar( false )
    self.colSelection:SetWangs( false )
    self.colSelection:SetPalette( false )
    self.colSelection:SetHeight( 150 )
    self.colSelection:Dock( TOP )
    self.colSelection:DockMargin( 15, 5, 15, 0 )
    local col = self.colSelection

    self.colOutput = vgui.Create( "DPanel", self.miniPanel )
    self.colOutput:Dock( TOP )
    self.colOutput:DockMargin( 15, 5, 15, 0 )

    function self.colOutput:Paint( w, h )
        surface.SetDrawColor( col:GetColor() )
        surface.DrawRect( 0, 0, w, h )
    end

    self.submit = vgui.Create( "DButton", self.miniPanel )
    self.submit:Dock( TOP )
    self.submit:DockMargin( 15, 25, 15, 0 )
    self.submit:SetText( "Submit" )

    self.submit.DoClick = function()
        net.Start("CFC_Fac_RequestFactionSubmit")
        net.WriteString(self.nameEntry:GetValue())
        net.WriteString(self.descEntry:GetValue())
        --[ERROR] addons/cfc_factions_3/lua/cfcfactions/core/sv/sv_factions.lua:246: attempt to call field 'ReadBoolean' (a nil value)
        net.WriteBool(self.inviteBool:GetChecked())
        net.WriteBool(self.tempBool:GetChecked())
        --[ERROR] lua/includes/extensions/net.lua:74: net.WriteColor: color expected, got table

        net.WriteColor(self.colSelection:GetTable())
        net.SendToServer()
        self.submit:SetEnabled(false)
    end
end

vgui.Register( "D_cfcfactioncreate", Panel )