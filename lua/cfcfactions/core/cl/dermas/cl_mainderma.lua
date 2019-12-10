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
local cfg = cfcFactions.Config.Client

function Panel:Init()
    -- self.MainMenu:SetTitle(string.format(cfg.DermaHeaderTitle, LocalPlayer():Nick() ) )
    -- self.MainMenu:SetKeyboardInputEnabled(false)
    -- self.MainMenu:MakePopup()
    -- self.MainMenu:SetDraggable(true)

    --self.MainMenu:Center()



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

    self.Menubar = vgui.Create( "DPanel", self )
    self.Menubar:DockMargin( 0, 45, 0, 0 )
    self.Menubar:Dock( TOP )
    self.Menubar:SetSize( self:GetWide() - 0.1, self:GetTall() - 745 )
    self.Menubar:SetBackgroundColor( cfg.ColorSchemes.BackgroundPanel )


    --Where new menu buttons are added to
    self.MenuItemFactions = vgui.Create("DButton", self.MenuBar)
    self.MenuItemUsers = vgui.Create("DButton", self.MenuBar)
    self.MenuItemAlerts = vgui.Create("DButton", self.MenuBar)
    self.MenuItemNews = vgui.Create("DButton", self.MenuBar)
    self.MenuItemOptions = vgui.Create("DButton", self.MenuBar)
    self.MenuItemCredits = vgui.Create("DButton", self.MenuBar)
    --pretty paint overrides for menubar

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
    self.Mainview = vgui.Create( "DPanel", self.Container )
    self.Mainview:DockMargin( 15, 15, 15, 15 )
    self.Mainview:Dock( TOP )
    self.Mainview:SetSize( self:GetWide() - 20, self:GetTall() - 230 )
    self.Mainview:SetPos( ( self:GetWide() / 2 ) - ( self.Mainview:GetWide() / 2 ), 120 )
    self.Mainview:SetBackgroundColor( Color( 0, 0, 0, 0 ) )

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
        draw.SimpleText( string.format( cfg.DermaHeaderTitle, LocalPlayer():Nick() ), "CFC_Special", 5, 5, cfg.ColorSchemes.HeaderText )
end

function Panel:Think()

end

function Panel:ClearAlerts()
    if self.AlertPanel == nil then return end
    if #self.AlertPanel:GetChildren() == 0 then return end

    for _, panel in pairs( self.AlertPanel:GetChildren() ) do
        panel:Remove()
    end
end

function Panel:SetMainview( panel )
    -- fetch children first
    for k, v in pairs( self.Mainview:GetChildren() ) do
        v:Clear()
    end

    local mview = vgui.CreateFromTable( panel, self.Mainview, nil )
    mview:SetSize( self.Mainview:GetWide(), self.Mainview:GetTall() )
end

function Panel:OnMousePressed( key )
    if key == MOUSE_RIGHT then
        self:CreateAlert( "Test Alert was created", cfg.MsgType[2] )
    end
end

function Panel:CreateAlert( msg, type )
    if self.AlertPanel == nil then return end
    if #self.AlertPanel:GetChildren() > 0 then self:ClearAlerts() end

    local Alert = vgui.Create( "D_cfcalertboxpanel", self.AlertPanel )
    Alert:SetWide( self.AlertPanel:GetWide() )
    Alert:SetTall( self.AlertPanel:GetTall() )
    Alert.ErrMsg:SetText( msg )

    if #msg >= 25 then
        Alert.ErrMsg:SetFont( "CFC_Alert_Small" )
    else
        Alert.ErrMsg:SetFont( "CFC_Alert" )
    end

    Alert.ErrMsg:SetColor( cfg.MsgType[type] )
    Alert.ErrMsg:SetSize( Alert:GetWide(), Alert:GetTall() )
    Alert:Dock( FILL )
    surface.PlaySound( "buttons/button15.wav" )
end

vgui.Register( 'D_cfcmainderma', Panel )
