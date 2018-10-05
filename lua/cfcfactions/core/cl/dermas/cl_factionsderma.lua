if not CLIENT then return end

cfcFactions.FactionsView = nil

local Panel = {}
local cfg = cfcFactions.Config.Client
local MinQuery = 1
local MaxQuery = 15

local createDPanel = cfcFactions.createDPanel
local createDListView = cfcFactions.createDListView
local createDButton = cfcFactions.createDButton


cfcFactions:RegisterDermaMenu( "View Factions", Panel, 1 )

local function addFactions(panel, locked, name, description, owner, kd, id)
    --no need to constantly add to the view if factions remains the same
    local tmpLock
    
    if locked == 1 then
        --tmpLock = vgui.Create("DImage", panel)
        tmpLock = "L"
    else 
        tmpLock = ""
    end

    panel.Factionsview:AddLine( tmpLock, name, description, owner, kd, id )
    panel.Factionsview:DataLayout()
end


local Black = Color( 0, 0, 0, 0 )
local BasePanelWidth  = 1024
local BasePanelHeight = 800
function Panel:Init()
    --[[
    Structing of a faction's view and internal panel layout
    
        Panel
        {
            MainContainer
            {
                Factionsview 
                {
    

                }
                BottomPanel 
                {
                    BottomContainerTop{
                        BottomButtonsControlPanel
                        {
        
                        }

                    }
                    BottomContainerBottom 
                    {
                        BottomsContainer
                        {
                                                    {LEFT | RIGHT}
                        }       
                    }                   
                }
            }
        }   


    ]]--

    local bgColor = ColorAlpha( cfc.ColorSchemes.BackgroundPanel, 255 )

    cfcFactions.FactionsView = 1

    local curScreenWidth  = ScrW()
    local curScreenHeight = ScrH()

    local panelWidth  = math.Clamp( BasePanelWidth,  0, curScreenWidth )
    local panelHeight = math.Clamp( BasePanelHeight, 0, curScreenHeight )
    
    self:SetSize( panelWidth, panelHeight )

    self.MainContainer = createDPanel( nil, {dock = FILL} )
    self.Factionsview  = createDermaItem( "DListView", self.MainContainer, {dock = FILL} )
    
    -- BottomPanel, BottomContainer
    self.BottomPanel = createDPanel( self.MainContainer, {dock = BOTTOM, color = bgColor, inval = true} )
    self.BottomPanel:SetWide( self:GetWide() )
    self.BottomPanel:SetTall( 50 )

    self.BottomContainerTop    = createDPanel( self.BottomPanel, {dock = TOP, color = bgColor} )
    self.BottomContainerBottom = createDPanel( self.BottomPanel, {dock = BOTTOM, color = bgColor} )

    self.BottomButtonsControlPanel = createDPanel( self.BottomContainerBottom, {dock = BOTTOM, color = bgColor} )
    -- END: BottomPanel, BottomContainer

    -- Factions View buttons (Changing pages)

    self.ButtonsContainer = createDPanel( self.BottomContainerTop, {dock = RIGHT, color = bgColor, inval = true} )
    -- END: Factions View Buttons

    -- self.ButtonsContainer:SetWide(210)

    -- ButtonsPanel
    self.ButtonsPanelLeft  = createDPanel( self.ButtonsContainer, {dock = LEFT,  inval = true, color = bgColor} )
    self.ButtonsPanelRight = createDPanel( self.ButtonsContainer, {dock = RIGHT, inval = true, color = bgColor} )
    
    -- END: ButtonsPanel

    -- Create, Edit, Delete, View
    self.CreateFaction = createDButton( self.BottomButtonsControlPanel, {text = "Create Faction", dock = LEFT} )
    self.EditFaction   = createDButton( self.BottomButtonsControlPanel, {text = "Edit Faction",   dock = LEFT} )
    self.DeleteFaction = createDButton( self.BottomButtonsControlPanel, {text = "Delete Faction", dock = LEFT} )
    self.ViewFaction   = createDButton( self.BottomButtonsControlPanel, {text = "View Faction",   dock = LEFT} )


    cfcFactions:ResizeParentFromChildren(self.BottomButtonsControlPanel)
    cfcFactions:ResizeChildrenEqually(self.BottomButtonsControlPanel,6)
    -- END: Create, Edit, Delete, View

    -- First Page, Previous Page, Next Page, Last Page
    self.FirstPage    = createDButton( self.ButtonsPanelLeft,  {text = "<<", dock = LEFT} )
    self.PreviousPage = createDButton( self.ButtonsPanelLeft,  {text = "<",  dock = RIGHT} )
    self.NextPage     = createDButton( self.ButtonsPanelRight, {text = ">",  dock = LEFT} )
    self.LastPage     = createDButton( self.ButtonsPanelRight, {text = ">>", dock = RIGHT} )


    self.ButtonsPanelLeft:SetWide(self.FirstPage:GetWide() + self.NextPage:GetWide())
    self.ButtonsPanelRight:SetWide(self.NextPage:GetWide() + self.LastPage:GetWide())

    cfcFactions:ResizeParentFromChildren(self.ButtonsContainer)
    -- END: First Page, Previous Page, Next Page, Last Page

    --[[
        --Container [  Container[Name] Container[Description] -... ]
    ]]--

    --id  - name - description - owner - InviteOnly - kills - deaths
    self.privcol = self.Factionsview:AddColumn(" ", 1)
    self.namecol = self.Factionsview:AddColumn("Name", 2)
    self.desccol = self.Factionsview:AddColumn("Description", 3)
    self.owncol = self.Factionsview:AddColumn("owner", 4)
    self.killcol = self.Factionsview:AddColumn("K/D", 5)
    self.idcol = self.Factionsview:AddColumn("ID", 6)

    --sizing
    self.privcol:SetWide(5)
    self.killcol:SetWide(5)
    self.idcol:SetWide(20)

    --debug code to sample how factions is displayed
    for k=1, 10 do
        local ID = cfcFactions:UUID()
        local name = "MyTestFaction"
        addFactions(self, math.random(0,1), (name .. ID), string.reverse(string.lower(name)),"Test User", (math.random(0,100) .. "/"..math.random(0,100)), cfcFactions:UUID())
    end
end

function Panel:Paint(w, h)

end

function Panel:Think()

end

vgui.Register('D_cfcfactionsderma', Panel)

--TODO: FactionRemoved

--TODO:  tie into being actually used
net.Receive("FactionCreated", function()

end)

net.Receive("FactionEdited", function()

end)

net.Receive("FactionFetchQuery", function()

end)

net.Receive("FactionDeleted", function()

end)
