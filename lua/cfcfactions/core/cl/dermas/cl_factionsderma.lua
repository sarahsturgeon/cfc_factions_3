if not CLIENT then return end

cfcFactions.FactionsView = nil
cfcFactions.Factions = cfcFactions.Factions or {}
cfcFactions.FactionsListView = nil
local Panel = {}
local cfg = cfcFactions.Config.Client
local MinQuery = 1
local MaxQuery = 15

cfcFactions:RegisterDermaMenu( "View Factions", Panel, 1 )



function Panel:Init()
    cfcFactions.FactionsView=1
    self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
    self.MainContainer = vgui.Create( "DPanel", self )
    self.MainContainer:Dock( FILL )

    cfcFactions.FactionsListView = vgui.Create( "DListView", self.MainContainer )
    cfcFactions.FactionsListView:Dock( FILL )

    self.BottomPanel = vgui.Create( "DPanel", self.MainContainer )
    self.BottomPanel:Dock( BOTTOM )
    self.BottomPanel:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
    self.BottomPanel:SetWide( self:GetWide() )
    self.BottomPanel:SetTall( 50 )
    self.BottomPanel:InvalidateParent( true )
    self.BottomPanel:SetBackgroundColor( ColorAlpha( cfg.ColorSchemes.BackgroundPanel, 255 ) )

    self.BottomContainerTop = vgui.Create( "DPanel", self.BottomPanel )
    self.BottomContainerTop:Dock( TOP )
    self.BottomContainerTop:SetBackgroundColor( ColorAlpha( cfg.ColorSchemes.BackgroundPanel, 255 ) )

    self.BottomContainerBottom = vgui.Create( "DPanel", self.BottomPanel )
    self.BottomContainerBottom:Dock( BOTTOM )
    self.BottomContainerBottom:SetBackgroundColor( ColorAlpha( cfg.ColorSchemes.BackgroundPanel, 255 ) )

    --Bottom Panel - Contains buttons to interact with factions
    self.BottomButtonsControlPanel = vgui.Create( "DPanel", self.BottomContainerBottom )
    self.BottomButtonsControlPanel:SetBackgroundColor( ColorAlpha( cfg.ColorSchemes.BackgroundPanel, 255 ) )
    self.BottomButtonsControlPanel:Dock( BOTTOM )

    --Factions View buttons ( Changing pages )
    self.ButtonsContainer = vgui.Create( "DPanel", self.BottomContainerTop )
    self.ButtonsContainer:Dock( RIGHT )
    self.ButtonsContainer:InvalidateParent( true )
    self.ButtonsContainer:SetBackgroundColor( ColorAlpha( cfg.ColorSchemes.BackgroundPanel, 255 ) )

    -- self.ButtonsContainer:SetWide( 210 )

    self.ButtonsPanelLeft = vgui.Create( "DPanel", self.ButtonsContainer )
    self.ButtonsPanelLeft:Dock( LEFT )
    self.ButtonsPanelLeft:InvalidateParent( true )
    self.ButtonsPanelLeft:SetBackgroundColor( ColorAlpha( cfg.ColorSchemes.BackgroundPanel, 255 ) )
    self.ButtonsPanelRight = vgui.Create( "DPanel", self.ButtonsContainer )
    self.ButtonsPanelRight:Dock( RIGHT )
    self.ButtonsPanelRight:InvalidateParent( true )
    self.ButtonsPanelRight:SetBackgroundColor( ColorAlpha( cfg.ColorSchemes.BackgroundPanel, 255 ) )

    --Create, Edit, Delete, View
    self.CreateFaction = vgui.Create( "DButton", self.BottomButtonsControlPanel )
    self.CreateFaction:SetText( "Create Faction" )
    self.CreateFaction:Dock( LEFT )
    self.CreateFaction.DoClick = function()
        --create cl_faccreate.lua, process, submit to server
        local CreateFactionMiniPanel = vgui.Create( "D_cfcfactioncreate", self.MainContainer )
        CreateFactionMiniPanel:Center()
        --Make sure we delete the FactionMiniPanel when finished
    end

    self.EditFaction = vgui.Create( "DButton", self.BottomButtonsControlPanel )
    self.EditFaction:SetText( "Edit Faction" )
    self.EditFaction:Dock( LEFT )
    self.DeleteFaction = vgui.Create( "DButton", self.BottomButtonsControlPanel )
    self.DeleteFaction:SetText( "Delete Faction" )
    self.DeleteFaction:Dock( LEFT )
    self.ViewFaction = vgui.Create( "DButton", self.BottomButtonsControlPanel )
    self.ViewFaction:SetText( "View Faction" )
    self.ViewFaction:Dock( LEFT )
    cfcFactions:ResizeParentFromChildren( self.BottomButtonsControlPanel )
    cfcFactions:ResizeChildrenEqually( self.BottomButtonsControlPanel, 6 )

    --First Page, Previous Page, Next Page, Last Page
    self.FirstPage = vgui.Create( "DButton", self.ButtonsPanelLeft )
    self.FirstPage:SetText( "<<" )
    self.FirstPage:Dock( LEFT )

    self.PreviousPage = vgui.Create( "DButton", self.ButtonsPanelLeft )
    self.PreviousPage:SetText( "<" )
    self.PreviousPage:Dock( RIGHT )

    self.NextPage = vgui.Create( "DButton", self.ButtonsPanelRight )
    self.NextPage:SetText( ">" )
    self.NextPage:Dock( LEFT )

    self.LastPage = vgui.Create( "DButton", self.ButtonsPanelRight ) 
    self.LastPage:SetText( ">>" )
    self.LastPage:Dock( RIGHT )

    self.ButtonsPanelLeft:SetWide( self.FirstPage:GetWide() + self.NextPage:GetWide() )
    self.ButtonsPanelRight:SetWide( self.NextPage:GetWide() + self.LastPage:GetWide() )
    --self.ButtonsContainer:SetWide( self.FirstPage:GetWide() + self.PreviousPage:GetWide() + self.NextPage:GetWide() + self.LastPage:GetWide() )
    cfcFactions:ResizeParentFromChildren( self.ButtonsContainer )

    --[[
        --Container [  Container[Name] Container[Description] -... ]
    ]]--

    --id  - name - description - owner - InviteOnly - kills - deaths

    self.privcol = cfcFactions.FactionsListView:AddColumn( "Private", 1 )
    self.namecol = cfcFactions.FactionsListView:AddColumn( "Name", 2)
    self.desccol = cfcFactions.FactionsListView:AddColumn( "Description", 3 )
    self.owncol = cfcFactions.FactionsListView:AddColumn( "owner", 4 )
    self.killcol = cfcFactions.FactionsListView:AddColumn( "K/D", 5 )
    self.idcol = cfcFactions.FactionsListView:AddColumn( "ID", 6 )

    --sizing
    self.privcol:SetWide( 5 )
    self.killcol:SetWide( 5 )
    self.idcol:SetWide( 20 )

end

function Panel:Paint( w, h )

end

function Panel:Think()

end

local function RefreshFactionViewingTable()
    cfcFactions.FactionsListView:Clear()
    if table.HasValue(cfcFactions.Factions) then 
        for KEY, Faction in cfcFactions.Factions do
            addFaction( Faction )
        end
    end
end

--TODO: FactionRemoved

--TODO:  tie into being actually used
local function addFaction( tbl )
    
    if not tbl then return end
    
    local Faction = tbl
    local tmpLock = Faction.Invite and "L" or ""
    local PrettyOwnerName = player.GetBySteamID64( Faction.Owner ):Nick()
    --Add faction to clientside table
    cfcFactions.FactionsListView:AddLine( tmpLock, Faction.Name, Faction.Description, PrettyOwnerName, ( Faction.Kills .. "/"..Faction.Deaths ), Faction.ID )
    cfcFactions.FactionsListView:DataLayout()

end

local function factionCreated( len, ply )

    local ClientsideFactionJsonified = net.ReadString()
    local FactionTable = util.JSONToTable( ClientsideFactionJsonified )
    cfcFactions.Factions[FactionTable.ID] = FactionTable

    RefreshFactionViewingTable()

end

net.Receive( "CFC_Fac_SendFactionSubmit", factionCreated )



local function FactionRefresh()
    local IncomingJSONVar = net.ReadString()
    local Faction = util.JSONToTable(IncomingJSONVar)
    cfcFactions.Factions[Faction.ID] = Faction
    RefreshFactionViewingTable()
end

net.Receive( "CFC_Fac_FactionRefresh", FactionRefresh )



vgui.Register( 'D_cfcfactionsderma', Panel )