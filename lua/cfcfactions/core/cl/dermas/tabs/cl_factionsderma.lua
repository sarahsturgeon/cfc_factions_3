local PANEL = {}
local cfg = ColorSchemes
vgui.Register( 'D_cfcfactionsderma', PANEL )

surface.CreateFont("CFC_Normal_Bold", 
    {
        font = "arial",
        size = 17,
        weight = 800
    }
)

function PANEL:Init()
    self.Rows = nil
    self.Test = {}
    --The number of factions to fetch, by default 1-10
    self.CurrentRequestAmountMin = 1
    self.CurrentRequestAmountMax = 10

    self.IsPrettyView = true

    self.ChangeViewPanel = vgui.Create( "DPanel", self )
    self.ChangeViewPanel:Dock( TOP )
    self.ChangeViewPanel:SetWide( self:GetWide() )
    self.ChangeViewPanel:SetTall( 25 )
    self.ChangeViewPanel:SetBackgroundColor( cfg.InlinePanel )

    self.PrettyView = vgui.Create( "DCheckBoxLabel", self.ChangeViewPanel )
    self.PrettyView:SetText( "Clean View")
    self.PrettyView:SetValue( true )
    self.PrettyView:SizeToContents()
    self.PrettyView:Dock( LEFT )   
    self.PrettyView:DockMargin( 5, 0, 0, 0 )
    self.PrettyView.Label:Dock( RIGHT ) -- Label is badly styled in vgui
    local factionsDerma = self
    function self.PrettyView:OnChange(state)
        factionsDerma:SetIsPrettyView( true )
    end


    self.QuickView = vgui.Create( "DCheckBoxLabel", self.ChangeViewPanel )
    self.QuickView:SetText( "Quick View")
    self.QuickView:SizeToContents()
    self.QuickView:Dock( LEFT )
    self.QuickView:DockMargin( 15, 0, 0, 0 )
    self.QuickView.Label:Dock( RIGHT )
    function self.QuickView:OnChange(state)
        factionsDerma:SetIsPrettyView( false )
    end


    self.MainContainer = vgui.Create( "DPanel", self )
    self.MainContainer:Dock( FILL )
    self.MainContainer:DockPadding( 0, 0, 0, 5 )
    self.MainContainer:InvalidateParent( true )

    self.MiddleContainer = vgui.Create( "DPanel", self.MainContainer )
    self.MiddleContainer:Dock( FILL )
    self.MiddleContainer:SetPaintBorderEnabled( true ) 
    self.MiddleContainer:SetBackgroundColor( cfg.InlinePanel )
    self.MiddleContainer:InvalidateParent( true )

    self.SplitPanelLeft = vgui.Create( "DScrollPanel", self.MiddleContainer )
    --self.SplitPanelLeft:SetSize( self.MiddleContainer:GetWide() / 2, self.MiddleContainer:GetTall() )
    self.SplitPanelLeft:Dock(FILL)
    self.SplitPanelLeft:GetVBar():SetWide(0)
    self.SplitPanelLeft:SetBackgroundColor( cfg.Transparent )
    self.SplitPanelLeft:InvalidateParent( true )

    -- self.SplitPanelRight = vgui.Create( "DPanel", self.MiddleContainer )
    -- self.SplitPanelRight:SetSize( self.MiddleContainer:GetWide() / 2, self.MiddleContainer:GetTall() )
    -- self.SplitPanelRight:AlignRight()
    -- self.SplitPanelRight:SetBackgroundColor( cfg.Transparent )
    -- self.SplitPanelRight:InvalidateParent( true )

    self.BottomGrid = vgui.Create( "DPanel", self.MainContainer )
    self.BottomGrid:Dock( BOTTOM )
    self.BottomGrid:SetWide( self:GetWide() )
    self.BottomGrid:SetTall( 50 )
    --self.BottomGrid:InvalidateParent( true )

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

    for K=1, 5 do
        self:DebugAddFaction( K )  
    end
end

-- Fixes weird issue with one of the panels being larger than its parent
function PANEL:PerformLayout(w, h)
    if self.MiddleContainer then
        --self.SplitPanelLeft:SetSize( self.MiddleContainer:GetWide() / 2, self.MiddleContainer:GetTall() )
        --self.SplitPanelLeft:AlignLeft()
        --self.SplitPanelRight:SetSize( self.MiddleContainer:GetWide() / 2, self.MiddleContainer:GetTall() )
        --self.SplitPanelRight:AlignRight()
        local h = self.MiddleContainer:GetTall() / 4
        for k, v in pairs(self.Test) do
            v:SetSize( v:GetWide(), h )
        end
    end
end

function PANEL:Paint( w, h )

end

function PANEL:Think()

end

function PANEL:SetIsPrettyView( state )
    self.PrettyView:SetChecked( state )
    self.QuickView:SetChecked( not state )
    self.IsPrettyView = state
end

function PANEL:DebugAddFaction( id )
    local name = string.rep("A", 31)
    if self.Test[id] then 
        self.Test[id]:Remove()
    end

    local PanelToAttach = self.SplitPanelLeft
    self.Test[id] = {}
    if id >= 1 and id <= 5 then
        PanelToAttach = self.SplitPanelLeft
    elseif id >= 6 and id <= 10 then
        PanelToAttach = self.SplitPanelRight
    else
        return
    end

    self.Test[id] = vgui.Create("D_factionpanel", PanelToAttach)
    self.Test[id]:SetSize( PanelToAttach:GetWide(), 100 )
    self.Test[id]:SetFactionName( name )
    self.Test[id]:SetFactionID( id )
    self.Test[id]:SetFactionDescription( "This is a test faction. It has a really long description lol, sure do hope it doesn't break anything :)" )
    self.Test[id]:Dock( TOP )
    self.Test[id]:DockMargin( 100, 10, 100, 10 )
    self.Test[id]:SetFactionPrivate(math.random() > 0.5)
    self.Test[id]:SetFactionOwner( LocalPlayer():Nick() )
    self.Test[id]:SetPaintBorderEnabled( true )
    self.Test[id]:SetFactionKD(10, 2)
end
function PANEL:AddFactionRow( faction )
    self.Rows[faction] = vgui.Create( "" )

    local Test = vgui.Create("D_factionpanel", self.MiddleContainer )
    Test:SetSize( 355, 100 )
    Test:SetFactionName( "A test faction")
    --Test:Dock( TOP )
    Test:SetPaintBorderEnabled( true )

end


