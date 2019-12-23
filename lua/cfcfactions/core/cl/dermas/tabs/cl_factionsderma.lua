local PANEL = {}
vgui.Register( 'D_cfcfactionsderma', PANEL )

function PANEL:Init()
    self.Rows = nil

    --The number of factions to fetch, by default 1-10
    self.CurrentRequestAmountMin = 1
    self.CurrentRequestAmountMax = 10

    self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
    self.MainContainer = vgui.Create( "DPanel", self )
    self.MainContainer:Dock( FILL )

    self.MiddleContainer = vgui.Create( "DPanel", self.MainContainer )
    self.MiddleContainer:Dock( FILL )
    self.MiddleContainer:SetPaintBorderEnabled( true ) 

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
    self.FirstPage = vgui.Create( "DButton", self.ButtonsGridLeft )
    self.FirstPage:SetText( "<<" )
    self.FirstPage:Dock( LEFT )

    self.PreviousPage = vgui.Create( "DButton", self.ButtonsGridLeft )
    self.PreviousPage:SetText( "<" )
    self.PreviousPage:Dock( RIGHT )

    self.NextPage = vgui.Create( "DButton", self.ButtonsGridRight )
    self.NextPage:SetText( ">" )
    self.NextPage:Dock( LEFT )

    self.LastPage = vgui.Create( "DButton", self.ButtonsGridRight )
    self.LastPage:SetText( ">>" )
    self.LastPage:Dock( RIGHT )

    self.ButtonsGridLeft:SetWide( self.FirstPage:GetWide() + self.NextPage:GetWide() )
    self.ButtonsGridRight:SetWide( self.NextPage:GetWide() + self.LastPage:GetWide() )
    -- self.ButtonsContainer:SetWide( self.FirstPage:GetWide() + self.PreviousPage:GetWide() + self.NextPage:GetWide() + self.LastPage:GetWide() )
    --cfcFactions:ResizeParentFromChildren( self.ButtonsContainer )
    local Test = vgui.Create("D_factionpanel", self.MiddleContainer )
    Test:SetSize( self.MiddleContainer:GetWide(), 150)

end

function PANEL:Paint( w, h )

end

function PANEL:Think()

end


function PANEL:AddFactionRow( faction )
    self.Rows[faction] = vgui.Create( "" )
end



local function factionCreated( len, ply )

    local ClientsideFactionJsonified = net.ReadString()
    local FactionTable = util.JSONToTable( ClientsideFactionJsonified )
    cfcFactions.Factions[FactionTable.ID] = FactionTable

end

net.Receive( "CFC_Fac_SendFactionSubmit", factionCreated )

local function factionEdited()

end

local function FactionRefresh()
    local IncomingJSONVar = net.ReadString()
    local IncomingState = net.ReadString()

    local Faction = util.JSONToTable( IncomingJSONVar )

    if IncomingState == "DELETED" then
        cfcFactions.Factions[Faction.ID] = nil
    else
        if Faction ~= nil then
            cfcFactions.Factions[Faction.ID] = Faction
        end
    end
end

net.Receive( "CFC_Fac_FactionRefresh", FactionRefresh )

