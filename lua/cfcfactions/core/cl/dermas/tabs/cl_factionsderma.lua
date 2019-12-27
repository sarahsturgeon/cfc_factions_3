local PANEL = {}
local cfg = ColorSchemes
vgui.Register( 'D_cfcfactionsderma', PANEL )

function PANEL:Init()
    self.Rows = nil
    self.Test = {}
    --The number of factions to fetch, by default 1-10
    self.CurrentRequestAmountMin = 1
    self.CurrentRequestAmountMax = 10

    self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )

    self.ChangeViewPanel = vgui.Create( "DPanel", self )
    self.ChangeViewPanel:Dock( TOP )
    self.ChangeViewPanel:SetWide( self:GetWide() )
    self.ChangeViewPanel:SetTall( 15 )
    self.ChangeViewPanel:SetBackgroundColor( cfg.InlinePanel )

    self.PrettyView = vgui.Create( "DCheckBoxLabel", self.ChangeViewPanel )
    self.PrettyView:SetText( "Clean View")
    self.PrettyView:SetValue( true )
    self.PrettyView:SizeToContents()
    self.PrettyView:Dock( LEFT )   
    --( number paddingLeft, number paddingTop, number paddingRight, number paddingBottom ) 
    self.PrettyView:DockPadding( 5, 0, 15, 5 )

    self.QuickView = vgui.Create( "DCheckBoxLabel", self.ChangeViewPanel )
    self.QuickView:SetText( "Quick View")
    self.QuickView:Dock( LEFT )
    self.QuickView:SizeToContents()
    self.QuickView:DockPadding( 15, 0, 10, 5 )

    self.MainContainer = vgui.Create( "DPanel", self )
    self.MainContainer:Dock( FILL )
    self.MainContainer:SetWide( self:GetWide() )
    self.MainContainer:DockPadding( 0, 0, 0, 5 )

    self.MiddleContainer = vgui.Create( "DPanel", self.MainContainer )
    self.MiddleContainer:Dock( FILL )
    self.MiddleContainer:SetPaintBorderEnabled( true ) 
    self.MiddleContainer:SetWide( self.MainContainer:GetWide() )
    self.MiddleContainer:SetBackgroundColor( cfg.BackgroundPanel )


    self.SplitPanelLeft = vgui.Create( "DPanel", self.MainContainer )
    self.SplitPanelLeft:SetSize( self.MainContainer:GetWide() / 2, self.MainContainer:GetTall() )
    self.SplitPanelLeft:Dock( LEFT )
    self.SplitPanelLeft:SetBackgroundColor( cfg.BackgroundPanel )

    self.SplitPanelRight = vgui.Create( "DPanel", self.MainContainer )
    self.SplitPanelRight:SetSize( self.MainContainer:GetWide() / 2, self.MainContainer:GetTall() )
    self.SplitPanelRight:Dock( RIGHT )
    self.SplitPanelRight:SetBackgroundColor( cfg.BackgroundPanel )

    self.BottomGrid = vgui.Create( "DPanel", self.MainContainer )
    self.BottomGrid:Dock( BOTTOM )
    self.BottomGrid:SetWide( self:GetWide() )
    self.BottomGrid:SetTall( 50 )
    self.BottomGrid:InvalidateParent( true )

    self.BottomContainerTop = vgui.Create( "DPanel", self.BottomGrid )
    self.BottomContainerTop:Dock( TOP )

    self.BottomContainerBottom = vgui.Create( "DPanel", self.BottomGrid )
    self.BottomContainerBottom:Dock( BOTTOM )

    -- Bottom PANEL - Contains buttons to interact with factions
    self.BottomButtonsControlGrid = vgui.Create( "DPanel", self.BottomContainerBottom )
    self.BottomButtonsControlGrid:Dock( BOTTOM )

    -- Factions View buttons ( Changing pages )
    self.ButtonsContainer = vgui.Create( "DPanel", self.BottomContainerTop )
    self.ButtonsContainer:Dock( RIGHT )
    self.ButtonsContainer:InvalidateParent( true )

    -- self.ButtonsContainer:SetWide( 210 )

    self.ButtonsGridLeft = vgui.Create( "DPanel", self.ButtonsContainer )
    self.ButtonsGridLeft:Dock( LEFT )
    self.ButtonsGridLeft:InvalidateParent( true )
    
    self.ButtonsGridRight = vgui.Create( "DPanel", self.ButtonsContainer )
    self.ButtonsGridRight:Dock( RIGHT )
    self.ButtonsGridRight:InvalidateParent( true )

    -- Create, Edit, Delete, View
    self.CreateFaction = vgui.Create( "DButton", self.BottomButtonsControlGrid )
    self.CreateFaction:SetText( "Create Faction" )
    self.CreateFaction:Dock( LEFT )
    self.CreateFaction.DoClick = function()
        -- create cl_faccreate.lua, process, submit to server
        local CreateFactionMiniPANEL = vgui.Create( "D_cfcfactioncreate", self.MainContainer )
    end

    self.EditFaction = vgui.Create( "DButton", self.BottomButtonsControlGrid )
    self.EditFaction:SetText( "Edit Faction" )
    self.EditFaction:Dock( LEFT )
    self.DeleteFaction = vgui.Create( "DButton", self.BottomButtonsControlGrid )
    self.DeleteFaction:SetText( "Delete Faction" )
    self.DeleteFaction:Dock( LEFT )
    self.ViewFaction = vgui.Create( "DButton", self.BottomButtonsControlGrid )
    self.ViewFaction:SetText( "View Faction" )
    self.ViewFaction:Dock( LEFT )

    -- First Page, Previous Page, Next Page, Last Page
    self.PreviousPage = vgui.Create( "DButton", self.ButtonsGridLeft )
    self.PreviousPage:SetText( "Previous Page" )
    self.PreviousPage:Dock( LEFT )

    self.NextPage = vgui.Create( "DButton", self.ButtonsGridRight )
    self.NextPage:SetText( "Next Page" )
    self.NextPage:Dock( RIGHT )


    -- self.ButtonsContainer:SetWide( self.FirstPage:GetWide() + self.PreviousPage:GetWide() + self.NextPage:GetWide() + self.LastPage:GetWide() )
    --cfcFactions:ResizeParentFromChildren( self.ButtonsContainer )


    for K=1, 12 do
        self:DebugAddFaction( K )  
    end
end

function PANEL:Paint( w, h )

end

function PANEL:Think()

end
function PANEL:DebugAddFaction( id )
    local name 
        local T = ""
    for N=1, 256 do
        T = T .. "V"
    end
    name = T
    if self.Test[id] then return end
    local CurrentNumberOfFactions = #self.Test
    local PanelToAttach = self.SplitPanelLeft
    self.Test[id] = {}
    if CurrentNumberOfFactions >= 6 and CurrentNumberOfFactions < 12 then
        PanelToAttach = self.SplitPanelRight
        self.Test[id].SIDE = "RIGHT"
    elseif CurrentNumberOfFactions >= 0 and CurrentNumberOfFactions <= 6 then
        PanelToAttach = self.SplitPanelLeft
        self.Test[id].SIDE = "LEFT"
    else
        return
    end
    self.Test[id] = vgui.Create("D_factionpanel", PanelToAttach)
    self.Test[id]:SetSize( PanelToAttach:GetWide(), 100 )
    self.Test[id]:SetFactionName( name )
    self.Test[id]:SetFactionID( id )
    self.Test[id]:SetFactionDescription( "This is a test faction." )
    self.Test[id]:Dock( TOP )
    self.Test[id]:SetFactionOwner( LocalPlayer():Nick() )
    self.Test[id]:SetPaintBorderEnabled( true )
end
function PANEL:AddFactionRow( faction )
    self.Rows[faction] = vgui.Create( "" )

    local Test = vgui.Create("D_factionpanel", self.MiddleContainer )
    Test:SetSize( 355, 100 )
    Test:SetFactionName( "A test faction")
    --Test:Dock( TOP )
    Test:SetPaintBorderEnabled( true )

end


