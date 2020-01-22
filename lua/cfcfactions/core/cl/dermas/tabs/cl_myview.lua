local PANEL = {}
local cfg = ColorSchemes
vgui.Register( 'D_myview', PANEL )
function PANEL:Init()
    self.MainPanelView = vgui.Create( "DPanel" , self )
    self.MainPanelView:Dock( FILL )
    self.MainPanelView:SetBackgroundColor( cfg.InlinePanel )

    self.TopPanel = vgui.Create( "DPanel", self )
    self.TopPanel:Dock( TOP )
    self.TopPanel:SetWide( self:GetWide() )
    self.TopPanel:SetTall( 25 )
    self.TopPanel:SetBackgroundColor( cfg.InlinePanel )


    self.TopPanelSplitLeft = vgui.Create( "DPanel", self.TopPanel )
    self.TopPanelSplitLeft:Dock( LEFT )

    self.TopPanelSplitRight = vgui.Create( "DPanel", self.TopPanel )
    self.TopPanelSplitRight:Dock( RIGHT )

    self.FactionNameContainer = vgui.Create( "DPanel", self.TopPanelSplitLeft )
    self.EditNameField = vgui.Create( "DLabelEditable", self.FactionNameContainer )
    self.EditNameIcon = vgui.Create( "DImage", self.FactionNameContainer)

    self.FactionDescContainer = vgui.Create( "DPanel", self.TopPanelSplitLeft )
    self.EditDescField = vgui.Create( "DLabelEditable", self.FactionDescContainer )
    self.EditDescField:SetText( "Description:" )
    self.EditDescIcon = vgui.Create( "DImage", self.FactionDescContainer)


    self.FactionIDLabel = vgui.Create( "DLabel", self.TopPanelSplitRight )
    self.FactionIDLabel:Dock( TOP )

    self.FactionOwnerLabel = vgui.Create( "DLabel", self.TopPanelSplitRight )
    self.FactionOwnerLabel:SetText( "Owner: Unknown" )

    self.KillsDeathsLabel = vgui.Create( "DLabel", self.TopPanelSplitRight )
    self.KillsDeathsLabel:SetText( "Kills: 0 Deaths: 0" )

    self.BottomPanel = vgui.Create( "DPanel", self )
    self.BottomPanel:Dock( BOTTOM )
    self.BottomPanel:SetWide( self:GetWide() )
    self.BottomPanel:SetBackgroundColor( cfg.InlinePanel )

    --Todo fill out bottom panel to include member groups / members in each group. see picture of viewfactionderma
end