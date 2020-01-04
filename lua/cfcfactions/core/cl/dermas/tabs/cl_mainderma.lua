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

local PANEL = {}
local cfg = ColorSchemes
vgui.Register( 'D_cfcmainderma', PANEL )

function PANEL:Init()
    --Magic numbers to subtly adjust the panel's size
    local ButtonTextWidthModifier = 7
    local ButtonTextTallModifier = 0.5

    self:Dock(FILL)

    -- window buttons
    self.CloseButton = vgui.Create( 'DButton', self )
    self.CloseButton:SetFont( 'CFC_Normal' )
    self.CloseButton:SetText( '[X]' )
    self.CloseButton.Paint = function() end
    self.CloseButton:SetColor( Color( 255, 255, 255 ) )
    self.CloseButton:SetSize( 32, 32 )
    self.CloseButton:SetPos( self:GetWide() - 45, 5 )
    function self:PerformLayout(w, h)
        self.CloseButton:SetPos( self:GetWide() - 45, 5 )
    end

    self.CloseButton.DoClick = function()
        cfcFactions:DisplayMenu()
    end

    self.MenuBar = vgui.Create( "DPanel", self )
    self.MenuBar:DockMargin( 0, 45, 0, 0 )
    self.MenuBar:Dock( TOP )
    self.MenuBar:SetSize( self:GetWide() - 0.1, self:GetTall() - 745 )
    self.MenuBar:SetBackgroundColor( cfg.BackgroundPanel )

    

    --Used to manage MenuBar buttons
    self.ButtonState = {}
    self.LastPressed = nil

   --Handles what happens when a button is clicked
    self.ButtonState.HandlePressedEvent = function( button )
        -- if not self.LastPressed == nil then
        --     local LastPressedReversedState = not self.LastPressed:GetEnabled() 
        --     self.LastPressed:SetEnabled( LastPressedReversedState )
        -- end
        -- local ReverseState = not button:IsEnabled() 
        -- button:SetEnabled( ReverseState )
        -- self.LastPressed = button
    end

    --
    --Where new menu buttons are added to
    --

    --View Factions  - Where the magic is made to create, edit, and delete
    self.MenuItemFactions = vgui.Create("DButton", self.MenuBar)
    self.MenuItemFactions:Dock( LEFT )
    self.MenuItemFactions:SetText( "View Factions" )
    self.MenuItemFactions:SetTall( self.MenuBar:GetTall() + ButtonTextTallModifier )
    self.MenuItemFactions:SetWide( #self.MenuItemFactions:GetText() * ButtonTextWidthModifier )
    self.MenuItemFactions:DockMargin( 25, 0, 0, 0 )
    self.MenuItemFactions.DoClick = function()
        --local ItemFactioneers = vgui.Create("D_cfcfactionsderma", self.MainView)  
        self:AddToMainView( "D_cfcfactionsderma", "Viewing Factions" )
        self.ButtonState.HandlePressedEvent( self.MenuItemFactions ) 
    end
    self.MenuItemFactions.Paint = nil
    self.MenuItemFactions:SetColor( cfg.ButtonText  )

    --Users Derma
    self.MenuItemUsers = vgui.Create( "DButton", self.MenuBar )
    self.MenuItemUsers:SetTall( self.MenuBar:GetTall() + ButtonTextTallModifier )
    self.MenuItemUsers:Dock( LEFT )
    self.MenuItemUsers:SetText("View Users" )
    self.MenuItemUsers:SetWide( #self.MenuItemFactions:GetText() * ButtonTextWidthModifier )
    self.MenuItemUsers.DoClick = function()
        --local ItemFactioneers = vgui.Create("D_cfcuserssderma", self.MainView)
        self:AddToMainView( "D_cfcuserssderma", "Viewing Users" )  
        self.ButtonState.HandlePressedEvent( self.MenuItemUsers )  
    end
    self.MenuItemUsers.Paint = nil
    self.MenuItemUsers:SetColor( cfg.ButtonText  )

    --News Derma
    self.MenuItemNews = vgui.Create( "DButton", self.MenuBar )
    self.MenuItemNews:SetTall( self.MenuBar:GetTall() + ButtonTextTallModifier )
    self.MenuItemNews:Dock( LEFT )
    self.MenuItemNews:SetText( "View News" )
    self.MenuItemNews:SetWide( #self.MenuItemFactions:GetText() * ButtonTextWidthModifier )
    self.MenuItemNews.DoClick = function()
        --local ItemNews = vgui.Create("D_cfcnewsderma", self.MainView)
        self:AddToMainView( "D_cfcnewsderma", "Viewing News" )    
        self.ButtonState.HandlePressedEvent( self.MenuItemNews ) 
    end
    self.MenuItemNews.Paint = nil
    self.MenuItemNews:SetColor( cfg.ButtonText  )

    --Alerts Derma
    self.MenuItemAlerts = vgui.Create( "DButton", self.MenuBar )
    self.MenuItemAlerts:SetTall( self.MenuBar:GetTall() + ButtonTextTallModifier )
    self.MenuItemAlerts:Dock( LEFT )
    self.MenuItemAlerts:SetText( "View Logs" )
    self.MenuItemAlerts:SetWide( #self.MenuItemFactions:GetText() * ButtonTextWidthModifier )
    self.MenuItemAlerts.DoClick = function()
    self.MenuItemAlerts:SetEnabled( false )
        --local ItemAlerts = vgui.Create("D_cfcalertsderma", self.MainView)   
        self:AddToMainView( "D_cfcalertsderma", "Viewing Alerts" )  
        self.ButtonState.HandlePressedEvent( self.MenuItemAlerts ) 
    end
    self.MenuItemAlerts.Paint = nil
    self.MenuItemAlerts:SetColor( cfg.ButtonText  )

    --Credits Derma
    self.MenuItemCredits = vgui.Create( "DButton", self.MenuBar )
    self.MenuItemCredits:SetTall( self.MenuBar:GetTall() + ButtonTextTallModifier )
    self.MenuItemCredits:Dock( LEFT )
    self.MenuItemCredits:SetText( "View Logs" )
    self.MenuItemCredits:SetWide( #self.MenuItemFactions:GetText() * ButtonTextWidthModifier )
    self.MenuItemCredits.DoClick = function()
        --local ItemCredits = vgui.Create("D_cfcnewsderma", self.MainView) 
        self:AddToMainView( "D_cfcnewsderma", "Viewing News" ) 
        self.ButtonState.HandlePressedEvent( self.MenuItemCredits )     
    end
    self.MenuItemCredits.Paint = nil
    self.MenuItemCredits:SetColor( cfg.ButtonText  )

    self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
    self:SetPos( ( ( ScrW() / 2 ) - ( self:GetWide() / 2 ) ), ( ( ScrH() / 2 ) - ( self:GetTall() / 2 ) ) )

    -- Main self.Container
    self.Container = vgui.Create( "DPanel", self )
    self.Container:DockMargin( 0, 0, 0, 0 )
    self.Container:Dock( FILL )
    self.Container:SetSize( self:GetWide() - 20, self:GetTall() - 150 )
    --self.Container:SetPos( ( self:GetWide() / 2 ) - ( self.Container:GetWide() / 2 ), 120 )
    self.Container:SetBackgroundColor( cfg.BackgroundDerma )

    -- sub_self.Container
    self.MainView = vgui.Create( "DPanel", self.Container )
    self.MainView:DockMargin( 0, 5, 0, 0 )
    self.MainView:Dock( FILL )
    self.MainView:SetSize( self.Container:GetWide() - 20, self.Container:GetTall() - 230 )
    self.MainView:SetPos( ( self:GetWide() / 2 ) - ( self.MainView:GetWide() / 2 ), 120 )
    self.MainView:SetBackgroundColor( cfg.BackgroundPanel )

    --Set our default viewing experience to view factions.
    self:AddToMainView( "D_cfcfactionsderma", "Viewing Factions" )
end

--Which PANEL to display in the main view, along with the state to report back.
--IE: D_cfcnewsderma, "Viewing News"
function PANEL:AddToMainView( panel, state )
    if self.MainView:IsValid() then
        --Clear any PANELs currently in the main view
        self.MainView:Clear()
        self.SubMainViewPanel = vgui.Create( panel, self.MainView )   
        self.SubMainViewPanel:SetSize( self.MainView:GetWide(), self.MainView:GetTall() )
        self.SubMainViewPanel:Dock( FILL )
    end

end

function PANEL:Paint( w, h )
        Derma_DrawBackgroundBlur( self )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 55, 55, 55, 220 ) )
        surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.SimpleText( string.format( DermaHeaderTitle, LocalPlayer():Nick() ), "CFC_Special", 5, 10, ColorSchemes.HeaderText )
end

function PANEL:Think()

end


