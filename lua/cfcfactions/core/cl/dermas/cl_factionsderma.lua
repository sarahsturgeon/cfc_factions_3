if not CLIENT then return end

cfcFactions.FactionsView = nil



local Panel = {}
local cfg = cfcFactions.Config.Client
local MinQuery = 1
local MaxQuery = 15

cfcFactions:RegisterDermaMenu("View Factions", Panel, 1)


local function addFactions(panel, locked, name, description, owner, kd, id)
    --no need to constantly add to the view if factions remains the same
    local tmpLock
    if locked == 1 then
        --tmpLock = vgui.Create("DImage", panel)
        tmpLock = "L"
    else 
        tmpLock = ""
    end

    panel.Factionsview:AddLine(tmpLock, name, description, owner, kd, id)
    panel.Factionsview:DataLayout()
end

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




    cfcFactions.FactionsView=1
    self:SetSize(math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ))
    self.MainContainer = vgui.Create("DPanel",self)
    self.MainContainer:Dock(FILL)




    self.Factionsview = vgui.Create("DListView", self.MainContainer)
    self.Factionsview:Dock(FILL)
    --self.Factionsview:SetTall(5)
    
    self.BottomPanel = vgui.Create("DPanel",self.MainContainer)
    self.BottomPanel:Dock(BOTTOM)
    self.BottomPanel:SetBackgroundColor(Color(0,0,0,0))
    self.BottomPanel:SetWide(self:GetWide())
    self.BottomPanel:SetTall(50)
    self.BottomPanel:InvalidateParent(true)
    self.BottomPanel:SetBackgroundColor(ColorAlpha(cfg.ColorSchemes.BackgroundPanel,255))

    self.BottomContainerTop = vgui.Create("DPanel", self.BottomPanel)
    self.BottomContainerTop:Dock(TOP)
    self.BottomContainerTop:SetBackgroundColor(ColorAlpha(cfg.ColorSchemes.BackgroundPanel,255))

    self.BottomContainerBottom = vgui.Create("DPanel", self.BottomPanel)
    self.BottomContainerBottom:Dock(BOTTOM)
    self.BottomContainerBottom:SetBackgroundColor(ColorAlpha(cfg.ColorSchemes.BackgroundPanel,255))

--
    --Bottom Panel - Contains buttons to interact with factions
    self.BottomButtonsControlPanel = vgui.Create("DPanel", self.BottomContainerBottom)
    self.BottomButtonsControlPanel:SetBackgroundColor(ColorAlpha(cfg.ColorSchemes.BackgroundPanel,255))
    self.BottomButtonsControlPanel:Dock(BOTTOM)

    --Factions View buttons (Changing pages)
    self.ButtonsContainer = vgui.Create("DPanel", self.BottomContainerTop)
    self.ButtonsContainer:Dock(RIGHT)
    self.ButtonsContainer:InvalidateParent(true)
    self.ButtonsContainer:SetBackgroundColor(ColorAlpha(cfg.ColorSchemes.BackgroundPanel,255))


    -- self.ButtonsContainer:SetWide(210)

    self.ButtonsPanelLeft = vgui.Create("DPanel", self.ButtonsContainer)
    self.ButtonsPanelLeft:Dock(LEFT)
    self.ButtonsPanelLeft:InvalidateParent(true)
    self.ButtonsPanelLeft:SetBackgroundColor(ColorAlpha(cfg.ColorSchemes.BackgroundPanel,255))
    self.ButtonsPanelRight = vgui.Create("DPanel", self.ButtonsContainer)
    self.ButtonsPanelRight:Dock(RIGHT)
    self.ButtonsPanelRight:InvalidateParent(true)
    self.ButtonsPanelRight:SetBackgroundColor(ColorAlpha(cfg.ColorSchemes.BackgroundPanel,255))

    --Create, Edit, Delete, View
    self.CreateFaction = vgui.Create("DButton", self.BottomButtonsControlPanel)
    self.CreateFaction:SetText("Create Faction")
    self.CreateFaction:Dock(LEFT)
    self.EditFaction = vgui.Create("DButton", self.BottomButtonsControlPanel)
    self.EditFaction:SetText("Edit Faction")
    self.EditFaction:Dock(LEFT)
    self.DeleteFaction = vgui.Create("DButton", self.BottomButtonsControlPanel)
    self.DeleteFaction:SetText("Delete Faction")
    self.DeleteFaction:Dock(LEFT)
    self.ViewFaction = vgui.Create("DButton", self.BottomButtonsControlPanel)
    self.ViewFaction:SetText("View Faction")
    self.ViewFaction:Dock(LEFT)
    cfcFactions:ResizeParentFromChildren(self.BottomButtonsControlPanel)
    cfcFactions:ResizeChildrenEqually(self.BottomButtonsControlPanel,6)
--First Page, Previous Page, Next Page, Last Page
    self.FirstPage = vgui.Create("DButton", self.ButtonsPanelLeft)
    self.FirstPage:SetText("<<")
    self.FirstPage:Dock(LEFT)

    self.PreviousPage = vgui.Create("DButton", self.ButtonsPanelLeft)
    self.PreviousPage:SetText("<")
    self.PreviousPage:Dock(RIGHT)

    self.NextPage = vgui.Create("DButton", self.ButtonsPanelRight)
    self.NextPage:SetText(">")
    self.NextPage:Dock(LEFT)

    self.LastPage = vgui.Create("DButton", self.ButtonsPanelRight) 
    self.LastPage:SetText(">>")
    self.LastPage:Dock(RIGHT)

    self.ButtonsPanelLeft:SetWide(self.FirstPage:GetWide() + self.NextPage:GetWide())
    self.ButtonsPanelRight:SetWide(self.NextPage:GetWide() + self.LastPage:GetWide())
    --self.ButtonsContainer:SetWide(self.FirstPage:GetWide() + self.PreviousPage:GetWide() + self.NextPage:GetWide() + self.LastPage:GetWide())
    cfcFactions:ResizeParentFromChildren(self.ButtonsContainer)

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

--todo: FactionRemoved



--todo:  tie into being actually used
net.Receive("FactionCreated", function()

end)

net.Receive("FactionEdited", function()

end)

net.Receive("FactionFetchQuery", function()

end)

net.Receive("FactionDeleted", function()

end)