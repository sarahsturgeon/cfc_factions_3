surface.CreateFont( "CFC_Normal",
    {
        font = "arial",
        size = 18,
        weight = 500
    }
)

surface.CreateFont( "CFC_Special",
    {
        font = "coolvetica",
        size = 25,
        weight = 500
    }
)

surface.CreateFont( "CFC_Alert",
    {
        font = "Arial",
        size = 45,
        weight = 100
    }
)

surface.CreateFont( "CFC_Alert_Small",
    {
        font = "Arial",
        size = 20,
        weight = 100
    }
)

local Panel = {}

function Panel:Init()

    self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
    self:SetPos( ( ( ScrW() / 2 ) - ( self:GetWide() / 2 ) ), ( ( ScrH() / 2 ) - ( self:GetTall() / 2 ) ) )

    -- window buttons
    self.CloseButton = vgui.Create( 'DButton', self )
    self.CloseButton:SetFont( 'CFC_Normal' )
    self.CloseButton:SetText( '[X]' )
    self.CloseButton.Paint = function() end
    self.CloseButton:SetColor( Color( 255, 255, 255 ) )
    self.CloseButton:SetSize( 32, 32 )
    self.CloseButton:SetPos( self:GetWide() - 35, 5 )

    self.CloseButton.DoClick = function()
        cfcFactions:DisplayMenu()
    end

    self.MenuBar = vgui.Create( "DPanel", self )
    self.MenuBar:DockMargin( 0, 45, 0, 0 )
    self.MenuBar:Dock( TOP )
    self.MenuBar:SetSize( self:GetWide() - 0.1, self:GetTall() - 745 )
    self.MenuBar:SetBackgroundColor( ColorSchemes.BackgroundPanel )

    --
    --Where new menu buttons are added to
    --

    --View Factions  - Where the magic is made to create, edit, and delete
    self.MenuItemFactions = vgui.Create("DButton", self.MenuBar)
    self.MenuItemFactions.DoClick = function()
        self.MainView:Clear()
        local ItemFactions = vgui.Create("D_cfcfactionsderma", self.MainView)
    end
    self.MenuItemFactions:Dock( LEFT )
    self.MenuItemFactions:SetText( "View Factions" )
    self.MenuItemFactions:SetTall( self.MenuBar:GetTall() + 0.5 )
    self.MenuItemFactions:SetWide( #self.MenuItemFactions:GetText() * 7 )
    self.MenuItemFactions:DockMargin( 25, 0, 0, 0 )


    -- self.MenuItemFactions.Paint = function()

    -- end )



     self.MenuItemUsers = vgui.Create("DButton", self.MenuBar)
     self.MenuItemUsers.DoClick = function()
        self.MainView:Clear()
        local ItemFactions = vgui.Create("D_cfcfactionsderma", self.MainView)   
     end
    -- self.MenuItemAlerts = vgui.Create("DButton", self.MenuBar)
    -- self.MenuItemAlerts.DoClick = function()

    -- end
    -- self.MenuItemNews = vgui.Create("DButton", self.MenuBar)
    -- self.MenuItemNews.DoClick = function()

    -- end
    -- self.MenuItemOptions = vgui.Create("DButton", self.MenuBar)
    -- self.MenuItemOptions.DoClick = function()

    -- end
    -- self.MenuItemCredits = vgui.Create("DButton", self.MenuBar)
    -- self.MenuItemCredits.DoClick = function()

    -- end
    --pretty paint overrides for MenuBar

    -- 

    -- Main self.Container
    self.Container = vgui.Create( "DPanel", self )
    self.Container:DockMargin( 0, 0, 0, 0 )
    self.Container:Dock( TOP )
    self.Container:SetSize( self:GetWide() - 20, self:GetTall() - 150 )
    self.Container:SetPos( ( self:GetWide() / 2 ) - ( self.Container:GetWide() / 2 ), 120 )
    self.Container:SetBackgroundColor( Color( 0, 0, 0, 0 ) )

    -- Status Bar
    self.Statusbar = vgui.Create( "DPanel", self )
    self.Statusbar:DockMargin( 0, 0, 0, 0 )
    self.Statusbar:Dock( BOTTOM )
    self.Statusbar:SetSize( self:GetWide(), self:GetTall()-750 )
    self.Statusbar:SetBackgroundColor( Color( 0, 0, 0, 0 ) )

    -- alertbox
    if self.AlertPanel == nil then
        self.AlertPanel = vgui.Create( 'DPanel', self.Container )
        self.AlertPanel:Dock( TOP )
        self.AlertPanel:SetSize( self.Container:GetWide(), 55 )
        self.AlertPanel:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
    end

    -- sub_self.Container
    self.MainView = vgui.Create( "DPanel", self.Container )
    self.MainView:DockMargin( 15, 15, 15, 15 )
    self.MainView:Dock( TOP )
    self.MainView:SetSize( self:GetWide() - 20, self:GetTall() - 230 )
    self.MainView:SetPos( ( self:GetWide() / 2 ) - ( self.MainView:GetWide() / 2 ), 120 )
    self.MainView:SetBackgroundColor( Color( 0, 0, 0, 0 ) )

    -- Debug Status
    self.StatusLabel = vgui.Create( "DLabel", self.Statusbar )
    self.StatusLabel:Dock( RIGHT )
    self.StatusLabel:SetText( "Online" )
end

function Panel:Paint( w, h )
        Derma_DrawBackgroundBlur( self )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 55, 55, 55, 220 ) )
        surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )

        -- surface.DrawOutlinedRect( 0, 0, w, h )
        draw.SimpleText( string.format( DermaHeaderTitle, LocalPlayer():Nick() ), "CFC_Special", 5, 5, ColorSchemes.HeaderText )
end

function Panel:Think()

end

vgui.Register( 'D_cfcmainderma', Panel )
