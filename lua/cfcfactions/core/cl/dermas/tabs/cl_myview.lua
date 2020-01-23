local PANEL = {}
local cfg = ColorSchemes
vgui.Register( 'D_myview', PANEL )
function PANEL:Init()
    self.PlayerGroups = {}
    self.GroupContainers = {}

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
--Handles drawing the vgui panels for Group and Players
--A single container should contain a Panel, Panel, Group Name Label, Panel, Player panel for each player
--[[

    Panel
    {
        Panel
        {
            [GroupName]
                Panel
                {
                    [Player 1] { Panel }
                    [Player 2] { Panel }
                    [Player 3] { Panel }
                    [Player 4] { Panel }
                }
        },
        Panel
        {
            [GroupName 2]
                Panel
                {
                    [Player 1] { Panel }
                    [Player 2] { Panel }
                    [Player 3] { Panel }
                    [Player 4] { Panel }
                }
        }        

    }

]]--
function PANEL:DrawGroupContainer()
    for Indx, Groups in self.PlayerGroups do
        if table.Count( Groups ) > 0 then
            self.GroupContainers[Groups] = vgui.Create( "DPanel", self.BottomPanel )
            self.GroupContainers[Groups]:Dock( LEFT )
        end
    end
end
function PANEL:AddPlayer( ply, group )

    --[[
        Structure of self.PlayerGroups

        ["Group_Name"] = { Players }

        ["Owner"] = {"STEAMID9829381"},
        ["Meatshields"] = {"STEAM90388111", "STEAM783091982"}

    ]]--
    for Indx, Groups in self.PlayerGroups do
        if table.HasValue( Groups, ply ) then
            if Groups ~= group then
                --If the user exists already but the group is different than their current group, change their group and remove the old entry
                self.PlayerGroups[group].ply = nil
                table.Insert( self.PlayerGroups[group], ply )
            end
        end
    end
end