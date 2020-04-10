local PANEL = {}
local cfg = cfcFactions.Config.ColorSchemes
vgui.Register( "D_cfc_tab_factionslist", PANEL )

include( "cfcfactions/core/cl/dermas/minis/factionslist/cl_factionpanel.lua" )
include( "cfcfactions/core/cl/dermas/minis/factionslist/cl_faccreate.lua" )

function PANEL:Init()
    local this = self

    self.MainContainer = vgui.Create( "DPanel", self )
    self.MainContainer:Dock( FILL )
    self.MainContainer:InvalidateParent( true )
    self.MainContainer:SetBackgroundColor( cfg.Transparent )

    self.PropertySheet = vgui.Create( "DPropertySheetPretty", self.MainContainer )
    self.PropertySheet:Dock( FILL )

    self.ActiveFactionView = vgui.Create( "DScrollPanel" )
    self.ActiveFactionView:GetVBar():SetWide( 0 )
    self.ActiveFactionView:SetBackgroundColor( cfg.Transparent )
    self.ActiveFactionView:InvalidateParent( true )
    function self.ActiveFactionView:OnSelect()
        this:OnlineFactionsSetup()
    end
    self.PropertySheet:AddSheet( "Active Factions", self.ActiveFactionView )

    self.AllFactionView = vgui.Create( "DPanel" )
    self.AllFactionView:SetBackgroundColor( cfg.Transparent )
    self.AllFactionView:SetVisible( false )
    self.AllFactionView:SetMouseInputEnabled( true )
    function self.ActiveFactionView:OnSelect()
        this:AllFactionsSetup()
    end
    self.PropertySheet:AddSheet( "All Factions", self.AllFactionView )

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

function PANEL:OnShow()
    local panel = self.PropertySheet:GetSelectedPanel()
    if panel and panel.OnSelect then
        panel:OnSelect() 
    end
end

function PANEL:Paint( w, h ) end

function PANEL:Think() end

local function _SetAllFactionsPage( self, page )
    local success, data = await( cfcFactions.api.GetFactions( page ) )
    if not success then return end

    self:SetFactions( data )
end
PANEL.SetAllFactionsPage = async( _SetAllFactionsPage )

local function _OnlineFactionsSetup( self )
    local playerIDs = table.map( player.GetAll(), function( ply ) return ply:GetFactionsID() end )
    
    local success, data = await( cfcFactions.api.GetPlayer( playerIDs ) )
    if not success then return end

    local onlineFactionIDs = {}

    for k, plyData in pairs( data ) do
        if plyData.faction and plyData.faction.id then
            table.insert( onlineFactionIDs, plyData.faction.id )
        end
    end

    local success, data = await( cfcFactions.api.GetFaction( onlineFactionIDs ) )
    if not success then return end

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
