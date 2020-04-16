include( "cfcfactions/core/cl/dermas/tabs/cl_tab_factionslist.lua" )
include( "cfcfactions/core/cl/dermas/tabs/cl_tab_faction.lua" )
-- These will be uncommented when they're change to the new tab format
--      PANEL:AddMenuTab( tabName, tabPanel )
-- include( "cfcfactions/core/cl/dermas/tabs/cl_factioneersderma.lua" )
-- include( "cfcfactions/core/cl/dermas/tabs/cl_creditsderma.lua" )
-- include( "cfcfactions/core/cl/dermas/tabs/cl_alertsderma.lua" )
-- include( "cfcfactions/core/cl/dermas/tabs/cl_logsderma.lua" )

local PANEL = {}
local cfg = cfcFactions.Config.ColorSchemes
vgui.Register( "D_cfcmainderma", PANEL )

function PANEL:Init()
    self.tabs = {}

    self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )

    self:Dock( FILL )

    -- window buttons
    self.CloseButton = vgui.Create( "DButton", self )
    self.CloseButton:SetFont( "CFC_Normal" )
    self.CloseButton:SetText( "[X]" )
    self.CloseButton.Paint = function() end
    self.CloseButton:SetColor( Color( 255, 255, 255 ) )
    self.CloseButton:SetSize( 32, 32 )
    self.CloseButton:SetPos( self:GetWide() - 45, 5 )
    function self:PerformLayout( w, h )
        self.CloseButton:SetPos( self:GetWide() - 45, 5 )
    end

    self.CloseButton.DoClick = function()
        cfcFactions:HideMenu()
    end

    self.MenuBar = vgui.Create( "DPanel", self )
    self.MenuBar:DockMargin( 0, 45, 0, 0 )
    self.MenuBar:DockPadding( 15, 0, 0, 0 )
    self.MenuBar:Dock( TOP )
    self.MenuBar:SetSize( self:GetWide() - 0.1, 30 )
    self.MenuBar:SetBackgroundColor( cfg.BackgroundPanel )

    --
    -- Where new menu buttons are added to
    --

    -- Main self.Container
    self.Container = vgui.Create( "DPanel", self )
    self.Container:DockMargin( 0, 0, 0, 0 )
    self.Container:Dock( FILL )
    self.Container:SetSize( self:GetWide() - 20, self:GetTall() - 150 )
    self.Container:SetBackgroundColor( cfg.BackgroundDerma )

    -- sub_self.Container
    self.MainView = vgui.Create( "DPanel", self.Container )
    self.MainView:DockMargin( 0, 0, 0, 0 )
    self.MainView:Dock( FILL )
    self.MainView:SetSize( self.Container:GetWide() - 20, self.Container:GetTall() - 230 )
    self.MainView:SetPos( ( self:GetWide() / 2 ) - ( self.MainView:GetWide() / 2 ), 120 )
    self.MainView:SetBackgroundColor( cfg.InlineHeaderPanel )

    -- This is the part where we need localUserData, can't happen before the await
    self.tabsToAdd = {}
    hook.Run( "cfc_Fac_AddMenuTabs", self )
    self:AddTabs()
end

function PANEL:AddMenuTab( tabName, panel, noButton, position )
    table.insert( self.tabsToAdd, {
        name = tabName,
        panel = panel,
        noButton = noButton,
        position = position
    } )
end

function PANEL:AddTabs()
    table.SortByMember( self.tabsToAdd, "position", true )
    for k, tab in pairs( self.tabsToAdd ) do
        self:_AddMenuTab( tab.name, tab.panel, tab.noButton )
    end
end

function PANEL:_AddMenuTab( tabName, panel, noButton )
    local this = self

    panel:SetParent( self.MainView )
    panel:Dock( FILL )
    panel:Hide()

    local btn
    if not noButton then
        btn = vgui.Create( "DButtonPretty", self.MenuBar )
        btn:SetText( tabName )
        btn:Dock( LEFT )
        btn:SetWide( self:GetWide() * 0.1 )
        function btn:DoClick()
            this:SelectTab( tabName )
        end
    end

    table.insert( self.tabs, { panel = panel, name = tabName, button = btn } )

    if not self.selectedTab then
        self:SelectTab( tabName, true )
    end
end

function PANEL:SelectTab( tabName, skipButtonAnim, ... )
    local found = false
    for k, data in pairs( self.tabs ) do
        data.panel:SetVisible( data.name == tabName )
        if data.button then
            data.button:SetForceHovered( data.name == tabName, skipButtonAnim )
        end

        if data.name == tabName then
            found = true
            if data.panel.OnShow then
                data.panel:OnShow( ... )
            end
        end
    end
    if not found then error( "Unknown tab " .. tabName ) end
    self.selectedTab = tabName
end

function PANEL:GetSelectedPanel()
    for k, data in pairs( self.tabs ) do
        if data.name == self.selectedTab then
            return data.panel
        end
    end
end

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self )
    draw.RoundedBox( 0, 0, 0, w, h, Color( 55, 55, 55, 220 ) )
    surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
    surface.DrawOutlinedRect( 0, 0, w, h )
    draw.SimpleText( string.format( cfcFactions.Config.DermaHeaderTitle, LocalPlayer():Nick() ), "CFC_Special", 5, 10, cfg.HeaderText )
end

function PANEL:Think()

end
