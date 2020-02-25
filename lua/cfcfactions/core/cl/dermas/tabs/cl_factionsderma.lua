local PANEL = {}
local cfg = ColorSchemes
vgui.Register( 'D_cfcfactionsderma', PANEL )

function table.filter(tab, f)
    local out = {}
    for k, v in pairs(tab) do
        local doAdd = f(v)
        if doAdd then table.insert(out, v) end
    end
    return out
end

function table.mapFilter(tab, f)
    local out = {}
    for k, v in pairs(tab) do
        local newV = f(v)
        if newV then table.insert(out, newV) end
    end
    return out
end

-- Little recursive function for repeating args, rep("hi", 3) -> "hi", "hi", "hi" 
local function rep(x, n)
    if n == 0 then return nil end
    if n == 1 then return x end
    return x, rep(x, n-1)
end

-- Force a solid background on panels, rather than rounded darkened edges
local function solidBgPaint(self, w, h)
    surface.SetDrawColor( self:GetBackgroundColor() )
    surface.DrawRect( 0, 0, w, h )
end

surface.CreateFont("CFC_Normal_Bold", 
    {
        font = "arial",
        size = 17,
        weight = 800
    }
)
surface.CreateFont("CFC_Normal_Bold18", 
    {
        font = "arial",
        size = 18,
        weight = 800
    }
)

function PANEL:Init()
    local this = self
    self.Rows = nil
    self.Test = {}
    --The number of factions to fetch, by default 1-10
    self.CurrentRequestAmountMin = 1
    self.CurrentRequestAmountMax = 10

    self.IsAllView = false
    self.CurrentlySelectedFaction = nil

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
        local changeBy = (SysTime() - self.lastThink) * 5
        self.lastThink = SysTime()

        if fderma.IsAllView and self.lineProg < 1 then
            self.lineProg = math.Clamp(self.lineProg + changeBy, 0, 1)
        elseif not fderma.IsAllView and self.lineProg > 0 then
            self.lineProg = math.Clamp(self.lineProg - changeBy, 0, 1)
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
    self.MiddleContainer.Paint = solidBgPaint

    self.ActiveFactionView = vgui.Create( "DScrollPanel", self.MiddleContainer )
    self.ActiveFactionView:Dock( FILL )
    self.ActiveFactionView:GetVBar():SetWide(0)
    self.ActiveFactionView:SetBackgroundColor( cfg.Transparent )
    self.ActiveFactionView:InvalidateParent( true )
    function self.ActiveFactionView:OnMousePressed( key )
        if key == MOUSE_LEFT then
            this:ClearFactionSelection()
        end
    end

    self.AllFactionView = vgui.Create( "DPanel", self.MiddleContainer )
    self.AllFactionView:Dock( FILL )
    self.AllFactionView:DockMargin(0, 0, 0, 0)
    self.AllFactionView:SetBackgroundColor( cfg.Transparent )
    self.AllFactionView:SetVisible( false )
    self.AllFactionView:SetMouseInputEnabled( true )
    function self.AllFactionView:OnMousePressed( key )
        if key == MOUSE_LEFT then
            this.AllFactionList:ClearSelection()
        end
    end

    self.AllFactionList = vgui.Create( "DListViewPretty", self.AllFactionView )
    self.AllFactionList:Dock( FILL )
    self.AllFactionList:DockMargin(100, 10, 100, 0)
    self.AllFactionList.VBar:SetVisible( false )
    self.AllFactionList:InvalidateParent( true )
    self.AllFactionList:SetMultiSelect( false )
    function self.AllFactionList:OnRowSelected( idx, line )
        if line then
            this:SetSelectedFaction(line.factionID)
        else
            this:SetSelectedFaction()
        end
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
    -- TODO Get page count from api, record count / 50
    self.PaginationBar:SetPageCount(30)
    function self.PaginationBar:OnPageChange(oldPage, newPage)
        this:ClearFactionSelection()
        -- TODO
        -- This should call api to get factions
        -- Get records 
        -- (newPage - 1) * 50
        -- to 
        -- newPage * 50
        -- then call self:SetFactions( factions )

        this:GetFactionsPage( newPage, function( factions )
            this:SetFactions( factions )
        end )
    end

    self.BottomGrid = vgui.Create( "DPanel", self.MainContainer )
    self.BottomGrid:Dock( BOTTOM )
    self.BottomGrid:SetTall( 40 )
    self.BottomGrid:SetBackgroundColor( cfg.BackgroundPanel )
    local lineHeight = 2
    function self.BottomGrid:Paint(w, h)
        surface.SetDrawColor(self:GetBackgroundColor())
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(cfg.MiniPanelHeader)
        surface.DrawRect(0,0,w,lineHeight)
    end

    -- Create, Edit, Delete, View
    if LocalPlayer().isInFaction then
        self.ViewFaction = cfcFactions.addFactionButton( self, "View Faction", lineHeight )
        self.CreateFaction = cfcFactions.addFactionButton( self, "Create Faction", lineHeight )
        self.CreateFaction:SetDisabled( true )
    else
        self.CreateFaction = cfcFactions.addFactionButton( self, "Create Faction", lineHeight )
        self.ViewFaction = cfcFactions.addFactionButton( self, "View Faction", lineHeight )
    end

    self.ViewFaction:SetDisabled( true )
    self.CreateFaction.DoClick = function()
        -- create cl_faccreate.lua, process, submit to server
        --local CreateFactionMiniPANEL = vgui.Create( "D_cfcfactioncreate", self.MainContainer )
    end

    self.EditFaction = cfcFactions.addFactionButton( self, "Edit Faction", lineHeight )
    self.EditFaction:SetDisabled( true )
    self.EditFaction.OnMouseReleased = function( keyCode )
        if keyCode == MOUSE_LEFT then
            if self.CurrentlySelectedFaction ~= nil then
                local EditingFactionPanel
            end
        end
    end
    self.DeleteFaction = cfcFactions.addFactionButton( self, "Delete Faction", lineHeight )
    self.DeleteFaction:SetDisabled( true )

    self:GetFactionsPage( 1, function( factions )
        self:SetFactions( factions )
        self:SetOnlineFactions( factions )
    end )
    
end

function PANEL:Paint( w, h )

end

function PANEL:Think()

end

function PANEL:SetIsAllView( state )
    if state ~= self.IsAllView then

        self:ClearFactionSelection()

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
        end
    end
end

function PANEL:UpdateOnlineFactions()
    local factionIDs = {}
    for k, ply in pairs(player.GetAll()) do
        table.insert(factionIDS, ply.factionID)
    end
    -- Do some kind of API call with factionIDs to get factions
    local factions

    self:SetOnlineFactions( factions )
end

function PANEL:GetFactionsPage( pageNo, cb )
    -- Replace this with the api call to get factions for page, call cb with result (for async) (can we get Promises in glua??)
    local f = {}
    for k = 1, 10 do
        table.insert(f, {
            id = k,
            name = "Faction " .. k,
            description = "This is like a faction and stuff",
            private = k > 2,
            kills = k * 3,
            deaths = 2,
            owner = "Ur mom",
            members = { LocalPlayer():SteamID(), rep("xd", k)}
        })
    end

    cb(f)
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

    for k, v in pairs(factions) do
        -- Perhaps show: #v.onlineMembers .. "/" .. #v.members .. " online"
        local activePanel = vgui.Create( "D_factionpanel", self.ActiveFactionView )
        activePanel:SetSize( self.ActiveFactionView:GetWide(), 140 )
        activePanel:SetFactionName( v.name )
        activePanel:SetFactionID( v.id )
        activePanel:SetFactionDescription( v.description )
        activePanel:Dock( TOP )
        activePanel:DockMargin( 100, 10, 100, 10 )
        activePanel:SetFactionPrivate( v.private )
        activePanel:SetFactionOwner( v.owner )
        activePanel:SetFactionKD( v.kills, v.deaths )
        activePanel:SetMouseInputEnabled( true )
        function activePanel:OnMouseReleased() 
            this:SetSelectedFaction( self:GetFactionID() )
            if this.ActiveFactionView.selected then
                this.ActiveFactionView.selected:SetSelected( false )
            end
            self:SetSelected( true )
            this.ActiveFactionView.selected = self
            -- show the panel is selected somehow
        end
        table.insert( self.ActiveFactionPanels, activePanel )
    end

end

function PANEL:SetFactions( factions )
    self.factions = factions
    self.AllFactionList:Clear()
    for k, v in pairs( factions ) do
        local line = self.AllFactionList:AddLine( v.name, v.owner,
            v.kills, v.deaths, 
            #(v.onlineMembers or {}), #v.members,
            v.private and "✕" or "✓" )

        line.factionID = v.id
    end
end

function PANEL:ClearFactionSelection()
    self:SetSelectedFaction()
    if self.ActiveFactionView.selected then
        self.ActiveFactionView.selected:SetSelected( false )
    end
    self.AllFactionList:ClearSelection()
end

function PANEL:SetSelectedFaction( id )
    -- Doesn't really do anything yet, not sure how to indicate a selected faction
    local somethingSelected = not not id

    self.EditFaction:SetDisabled( not somethingSelected )
    self.DeleteFaction:SetDisabled( not somethingSelected )
    self.ViewFaction:SetDisabled( not somethingSelected )

    self.CurrentlySelectedFaction = id
end

