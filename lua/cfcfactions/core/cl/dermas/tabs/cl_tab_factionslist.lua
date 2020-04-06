local PANEL = {}
local cfg = cfcFactions.Config.ColorSchemes
local constants = cfcFactions.constants
vgui.Register( "D_cfc_tab_factionslist", PANEL )

-- Little recursive function for repeating args, rep( "hi", 3 ) -> "hi", "hi", "hi"
local function rep( x, n )
    if n == 0 then return nil end
    if n == 1 then return x end
    return x, rep( x, n-1 )
end

function PANEL:Init()
    local this = self
    self.Rows = nil
    self.Test = {}
    -- The number of factions to fetch, by default 1-10
    self.CurrentRequestAmountMin = 1
    self.CurrentRequestAmountMax = 10

    self.IsAllView = false

    self.ChangeViewPanel = vgui.Create( "DPanel", self )
    self.ChangeViewPanel:Dock( TOP )
    self.ChangeViewPanel:SetWide( self:GetWide() )
    self.ChangeViewPanel:SetTall( 30 )
    self.ChangeViewPanel:SetBackgroundColor( cfg.InlineHeaderPanel )
    self.ChangeViewPanel.lineProg = 0
    function self.ChangeViewPanel:Paint( w, h )
        surface.SetDrawColor( self:GetBackgroundColor() )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( cfg.InlinePanelSeparater )
        surface.DrawRect( w / 2, 5, 1, h - 9 )

        surface.SetDrawColor( cfg.MiniPanelHeader )
        local offset = 6 + self.lineProg * ( w / 2 )
        surface.DrawRect( offset, h - 5, ( w / 2 ) - 12, 2 )

        -- Hide the middle part of the line
        surface.SetDrawColor( self:GetBackgroundColor() )
        surface.DrawRect( ( w / 2 ) - 6, h - 5, 12, 2 )
    end
    local fderma = self
    function self.ChangeViewPanel:Think()
        if not self.lastThink then
            self.lastThink = SysTime()
            return
        end
        local changeBy = ( SysTime() - self.lastThink ) * 5
        self.lastThink = SysTime()

        if fderma.IsAllView and self.lineProg < 1 then
            self.lineProg = math.Clamp( self.lineProg + changeBy, 0, 1 )
        elseif not fderma.IsAllView and self.lineProg > 0 then
            self.lineProg = math.Clamp( self.lineProg - changeBy, 0, 1 )
        end
    end

    self.ActiveFactionsButton = vgui.Create( "DButton", self.ChangeViewPanel )
    self.ActiveFactionsButton:Dock( LEFT )
    self.ActiveFactionsButton:SetWide( self.ChangeViewPanel:GetWide() / 2 )
    self.ActiveFactionsButton:SetText( "Active Factions" )
    self.ActiveFactionsButton:SetTextColor( cfg.NormalText )
    self.ActiveFactionsButton:SetFont( "CFC_Normal_Bold18" )
    self.ActiveFactionsButton.Paint = nil
    function self.ActiveFactionsButton:PerformLayout( w, h )
        self:SetWide( self:GetParent():GetWide() / 2 )
    end
    function self.ActiveFactionsButton:DoClick()
        fderma:SetIsAllView( false )
    end

    self.AllFactionsButton = vgui.Create( "DButton", self.ChangeViewPanel )
    self.AllFactionsButton:Dock( RIGHT )
    self.AllFactionsButton:SetWide( self.ChangeViewPanel:GetWide() / 2 )
    self.AllFactionsButton:SetText( "All Factions" )
    self.AllFactionsButton:SetTextColor( cfg.NormalText )
    self.AllFactionsButton:SetFont( "CFC_Normal_Bold18" )
    self.AllFactionsButton.Paint = nil
    function self.AllFactionsButton:PerformLayout( w, h )
        self:SetWide( self:GetParent():GetWide() / 2 )
    end
    function self.AllFactionsButton:DoClick()
        fderma:SetIsAllView( true )
    end


    self.MainContainer = vgui.Create( "DPanel", self )
    self.MainContainer:Dock( FILL )
    self.MainContainer:InvalidateParent( true )
    self.MainContainer:SetBackgroundColor( cfg.Transparent )

    self.MiddleContainer = vgui.Create( "DPanel", self.MainContainer )
    self.MiddleContainer:Dock( FILL )
    self.MiddleContainer:SetPaintBorderEnabled( true )
    self.MiddleContainer:SetBackgroundColor( cfg.InlinePanel )
    self.MiddleContainer:InvalidateParent( true )
    self.MiddleContainer.Paint = cfcFactions.solidBgPaint

    self.ActiveFactionView = vgui.Create( "DScrollPanel", self.MiddleContainer )
    self.ActiveFactionView:Dock( FILL )
    self.ActiveFactionView:GetVBar():SetWide( 0 )
    self.ActiveFactionView:SetBackgroundColor( cfg.Transparent )
    self.ActiveFactionView:InvalidateParent( true )

    self.AllFactionView = vgui.Create( "DPanel", self.MiddleContainer )
    self.AllFactionView:Dock( FILL )
    self.AllFactionView:DockMargin( 0, 0, 0, 0 )
    self.AllFactionView:SetBackgroundColor( cfg.Transparent )
    self.AllFactionView:SetVisible( false )
    self.AllFactionView:SetMouseInputEnabled( true )

    self.AllFactionList = vgui.Create( "DListViewPretty", self.AllFactionView )
    self.AllFactionList:Dock( FILL )
    self.AllFactionList:DockMargin( 100, 10, 100, 0 )
    self.AllFactionList.VBar:SetVisible( false )
    self.AllFactionList:InvalidateParent( true )
    self.AllFactionList:SetMultiSelect( false )
    function self.AllFactionList:OnRowSelected( idx, line )
        -- TODO: go to faction
    end

    -- Columns:
    local columns = { "Name", "Owner", "Kills", "Deaths", "Online", "Total", "Public" }
    local columnSizes = { false, false, 60, 60, 40, 40, 40 }
    self.AllFactionList:AddColumns( columns, columnSizes )

    -- First Page, Previous Page, Next Page, Last Page
    self.PaginationBar = vgui.Create( "DPaginationBar", self.AllFactionView )
    self.PaginationBar:Dock( BOTTOM )
    self.PaginationBar:DockMargin( 140, 10, 140, 10 )
    self.PaginationBar:SetTall( 30 )
    self.PaginationBar:SetPageCount( 1 )
    function self.PaginationBar:OnPageChange( oldPage, newPage )
        this:SetAllFactionsPage( newPage )
    end

    self.BottomGrid = vgui.Create( "DPanel", self.MainContainer )
    self.BottomGrid:Dock( BOTTOM )
    self.BottomGrid:SetTall( 40 )
    self.BottomGrid:SetBackgroundColor( cfg.BackgroundPanel )
    local lineHeight = 2
    function self.BottomGrid:Paint( w, h )
        surface.SetDrawColor( self:GetBackgroundColor() )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( cfg.MiniPanelHeader )
        surface.DrawRect( 0, 0, w, lineHeight )
    end

    self.CreateFaction = cfcFactions.addFactionButton( self, "Create Faction", lineHeight )
end

function PANEL:Setup()
    if self.IsAllView then
        self:AllFactionsSetup()
    else
        self:OnlineFactionsSetup()
    end
end

function PANEL:OnShow()
    self:Setup()
end

function PANEL:Paint( w, h ) end

function PANEL:Think() end

local function _SetAllFactionsPage( self, page )
    local url = constants.BACKEND_ROOT .. constants.FACTIONS_ENDPOINT
    -- TODO: Page stuff
    local success, dataStr = await( NP.http.fetch( url ) )

    if not success then
        return
    end

    local data = util.JSONToTable( dataStr )

    self:SetFactions( data.data )
end
PANEL.SetAllFactionsPage = async( _SetAllFactionsPage )

local function _OnlineFactionsSetup( self )
    local playerIDs = table.map( player.GetAll(), function( ply ) return ply:GetNWInt( "CFC_DatabaseID" ) end )
    
    local url = constants.BACKEND_ROOT .. constants.PLAYERS_ENDPOINT .. "/" .. table.concat( playerIDs, "," )
    local success, dataStr = await( NP.http.request( "GET", url ) )
    if not success then return end

    local data = util.JSONToTable( dataStr )

    local factionIDmap = {}

    for k, plyData in pairs( data ) do
        if plyData.faction and plyData.faction.id then
            factionIDmap[plyData.faction.id] = true
        end
    end
    local factionIDs = table.GetKeys( factionIDmap )

    local url = constants.BACKEND_ROOT .. constants.FACTIONS_ENDPOINT .. "/" .. table.concat( factionIDs, "," )
    local success, dataStr = await( NP.http.fetch( url ) )
    if not success then return end

    local data = util.JSONToTable( dataStr )

    for k, faction in pairs( data ) do
        faction.color = string.ToColor( string.Replace( faction.color, ",", " " ) .. " 255" )
    end

    self:SetOnlineFactions( data )
end
PANEL.OnlineFactionsSetup = async( _OnlineFactionsSetup )

local function _AllFactionsSetup( self )
    -- TODO: Work out how many pages we need
    self.PaginationBar:SetPageCount( 1 )
    self:SetAllFactionsPage( 1 )
end
PANEL.AllFactionsSetup = async( _AllFactionsSetup )

function PANEL:SetIsAllView( state )
    if state ~= self.IsAllView then

        self.IsAllView = state
        self.ActiveFactionView:Show()
        self.AllFactionView:Show()
        if state then
            self.ActiveFactionView:SetAlpha( 255 )
            self.AllFactionView:SetAlpha( 0 )
            self.ActiveFactionView:AlphaTo( 0, 0.2 )
            self.AllFactionView:AlphaTo( 255, 0.2 )
            timer.Simple( 0.2, function()
                self.ActiveFactionView:Hide()
                self.AllFactionView:Show()
                self.AllFactionView:SetAlpha( 255 )
            end )
            self:AllFactionsSetup()
        else
            self.ActiveFactionView:SetAlpha( 0 )
            self.AllFactionView:SetAlpha( 255 )
            self.ActiveFactionView:AlphaTo( 255, 0.2 )
            self.AllFactionView:AlphaTo( 0, 0.2 )
            timer.Simple( 0.2, function()
                self.AllFactionView:Hide()
                self.ActiveFactionView:Show()
                self.ActiveFactionView:SetAlpha( 255 )
            end )
            self:OnlineFactionsSetup()
        end
    end
end

function PANEL:SetOnlineFactions( factions )
    if self.ActiveFactionPanels then
        for k, v in pairs( self.ActiveFactionPanels ) do
            v:Remove()
        end
    end
    self.ActiveFactionPanels = {}

    self.onlineFactions = factions

    local this = self

    for k, v in pairs( factions ) do
        -- Perhaps show: #v.onlineMembers .. "/" .. #v.members .. " online"
        local activePanel = vgui.Create( "D_factionpanel", self.ActiveFactionView )
        activePanel:SetSize( self.ActiveFactionView:GetWide(), 140 )
        activePanel:SetFactionName( v.name )
        activePanel:SetFactionID( v.id )
        activePanel:SetFactionDescription( v.description )
        activePanel:Dock( TOP )
        activePanel:DockMargin( 100, 10, 100, 10 )
        activePanel:SetFactionPrivate( v.private )
        activePanel:SetFactionOwner( "someone" )
        activePanel:SetFactionKD( v.kills or 1, v.deaths or 1 )
        activePanel:SetMouseInputEnabled( true )
        activePanel:SetFactionColor( v.color or Color( 255, 255, 255 ) )
        table.insert( self.ActiveFactionPanels, activePanel )
    end

end

function PANEL:SetFactions( factions )
    self.factions = factions
    self.AllFactionList:Clear()
    for k, v in pairs( factions ) do
        local line = self.AllFactionList:AddLine( v.name, "no",
            v.kills, v.deaths,
            0, 0,
            v.private and "✕" or "✓" )

        line.factionID = v.id
    end
end

hook.Add( "cfc_Fac_AddMenuTabs", "cfc_Fac_AddFactionsList", function( panel )
    panel:AddMenuTab( "View Factions", vgui.Create( "D_cfc_tab_factionslist" ) )
end )
