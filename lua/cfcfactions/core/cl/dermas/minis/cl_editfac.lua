local PANEL = {}

function PANEL:Init()
    self:SetSize( 500, 510 )
    self:Center()

    self.MainFrame = vgui.Create( "DFrame", self )
    self.MainFrame:Dock( FILL )
    self.MainFrame:SetTitle( "Edit Faction" )
    self.MainFrame:MakePopup()

    self.MiniPanel = vgui.Create( "DPanel", self.MainFrame )
    self.MiniPanel:Dock( FILL )

    self.NameLabel = vgui.Create( "DLabel", self.MiniPanel )
    self.NameLabel:SetText( "Faction name:" )
    self.NameLabel:SetTextColor( Color( 0, 0, 0 ) )
    self.NameLabel:Dock( TOP )
    self.NameLabel:DockMargin( 15, 5, 15, 0 )

    self.NameEntry = vgui.Create( "DTextEntry", self.MiniPanel )
    self.NameEntry:Dock( TOP )
    self.NameEntry:DockMargin( 15, 5, 15, 0 )
    self.NameEntry:SetPlaceholderText( "Edit your faction name" )

    self.InviteBool = vgui.Create( "DCheckBoxLabel", self.MiniPanel )
    self.InviteBool:SetTextColor( Color( 0, 0, 0 ) )
    self.InviteBool:SetText( "Invite only?" )
    self.InviteBool:Dock( TOP )
    self.InviteBool:DockMargin( 15, 5, 15, 0 )
    self.InviteBool:SetValue( 0 )

    self.TempBool = vgui.Create( "DCheckBoxLabel", self.MiniPanel )
    self.TempBool:SetTextColor( Color( 0, 0, 0 ) )
    self.TempBool:SetText( "Is temporary?" )
    self.TempBool:Dock( TOP )
    self.TempBool:DockMargin( 15, 5, 15, 0 )
    self.TempBool:SetValue( 0 )

    self.DescLabel = vgui.Create( "DLabel", self.MiniPanel )
    self.DescLabel:SetText( "Edit your faction description:" )
    self.DescLabel:SetTextColor( Color( 0, 0, 0 ) )
    self.DescLabel:Dock( TOP )
    self.DescLabel:DockMargin( 15, 5, 15, 0 )

    self.DescEntry = vgui.Create( "DTextEntry", self.MiniPanel )
    self.DescEntry:Dock( TOP )
    self.DescEntry:DockMargin( 15, 5, 15, 0 )
    self.DescEntry:SetHeight( 90 )
    self.DescEntry:SetMultiline( true )
    self.DescEntry:SetWrap( true )
    self.DescEntry:SetPlaceholderText( "Edit your faction description... ( Optional )" )

    self.ColLabel = vgui.Create( "DLabel", self.MiniPanel )
    self.ColLabel:SetText( "Faction color:" )
    self.ColLabel:SetTextColor( Color( 0, 0, 0 ) )
    self.ColLabel:Dock( TOP )
    self.ColLabel:DockMargin( 15, 5, 15, 0 )

    self.ColSelection = vgui.Create( "DColorMixer", self.MiniPanel )
    self.ColSelection:SetAlphaBar( false )
    self.ColSelection:SetWangs( false )
    self.ColSelection:SetPalette( false )
    self.ColSelection:SetHeight( 150 )
    self.ColSelection:Dock( TOP )
    self.ColSelection:DockMargin( 15, 5, 15, 0 )
    local col = self.ColSelection

    self.ColOutput = vgui.Create( "DPanel", self.MiniPanel )
    self.ColOutput:Dock( TOP )
    self.ColOutput:DockMargin( 15, 5, 15, 0 )

    function self.ColOutput:Paint( w, h )
        surface.SetDrawColor( col:GetColor() )
        surface.DrawRect( 0, 0, w, h )
    end

    self.Submit = vgui.Create( "DButton", self.MiniPanel )
    self.Submit:Dock( TOP )
    self.Submit:DockMargin( 15, 25, 15, 0 )
    self.Submit:SetText( "Submit" )

    self.Submit.DoClick = function()
        -- stuff
    end
end

vgui.Register( "D_cfcfactionedit", PANEL )