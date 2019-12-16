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

function PANEL:Init()

    --Magic numbers to subtly adjust the panel's size
    local ButtonTextWidthModifier = 7
    local ButtonTextTallModifier = 0.5

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
    self.MenuBar:SetBackgroundColor( ColorSchemes.BackgroundPANEL )

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
    end
    self.MenuItemFactions.Paint = nil
    self.MenuItemFactions:SetColor( ColorSchemes.ButtonText  )

    --Users Derma
    self.MenuItemUsers = vgui.Create("DButton", self.MenuBar)
    self.MenuItemUsers:SetTall( self.MenuBar:GetTall() + ButtonTextTallModifier )
    self.MenuItemUsers:Dock( LEFT )
    self.MenuItemUsers:SetText("View Users" )
    self.MenuItemUsers:SetWide( #self.MenuItemFactions:GetText() * ButtonTextWidthModifier )
    self.MenuItemUsers.DoClick = function()
        --self.MainView:Clear()
        --local ItemFactioneers = vgui.Create("D_cfcuserssderma", self.MainView)
        self:AddToMainView( "D_cfcuserssderma", "Viewing Users" )   
    end
    self.MenuItemUsers.Paint = nil
    self.MenuItemUsers:SetColor( ColorSchemes.ButtonText  )

    --Alerts Derma
    self.MenuItemAlerts = vgui.Create("DButton", self.MenuBar)
    self.MenuItemAlerts:SetTall( self.MenuBar:GetTall() + ButtonTextTallModifier )
    self.MenuItemAlerts:Dock( LEFT )
    self.MenuItemAlerts:SetText( "View Logs" )
    self.MenuItemAlerts:SetWide( #self.MenuItemFactions:GetText() * ButtonTextWidthModifier )
    self.MenuItemAlerts.DoClick = function()
    self.MenuItemAlerts:SetEnabled( false )
        --self.MainView:Clear()
        --local ItemAlerts = vgui.Create("D_cfcalertsderma", self.MainView)   
        self:AddToMainView( "D_cfcalertsderma", "Viewing Alerts" )  
    end
    self.MenuItemAlerts.Paint = nil
    self.MenuItemAlerts:SetColor( ColorSchemes.ButtonText  )

    --News Derma
    self.MenuItemNews = vgui.Create("DButton", self.MenuBar)
    self.MenuItemNews:SetTall( self.MenuBar:GetTall() + ButtonTextTallModifier )
    self.MenuItemNews:Dock( LEFT )
    self.MenuItemNews:SetText( "View News" )
    self.MenuItemNews:SetWide( #self.MenuItemFactions:GetText() * ButtonTextWidthModifier )
    self.MenuItemNews.DoClick = function()
        --self.MainView:Clear()
        --local ItemNews = vgui.Create("D_cfcnewsderma", self.MainView)
        self:AddToMainView( "D_cfcnewsderma", "Viewing News" )    
    end
    self.MenuItemNews.Paint = nil
    self.MenuItemNews:SetColor( ColorSchemes.ButtonText  )

    --Credits Derma
    self.MenuItemCredits = vgui.Create("DButton", self.MenuBar)
    self.MenuItemCredits:SetTall( self.MenuBar:GetTall() + ButtonTextTallModifier )
    self.MenuItemCredits:Dock( LEFT )
    self.MenuItemCredits:SetText( "View Logs" )
    self.MenuItemCredits:SetWide( #self.MenuItemFactions:GetText() * ButtonTextWidthModifier )
    self.MenuItemCredits.DoClick = function()
        --self.MainView:Clear()
        --local ItemCredits = vgui.Create("D_cfcnewsderma", self.MainView) 
        --self:AddToMainView( "D_cfcnewsderma", "Viewing News" )     
    end
    self.MenuItemCredits.Paint = nil
    self.MenuItemCredits:SetColor( ColorSchemes.ButtonText  )

    -- Main self.Container
    self.Container = vgui.Create( "DPanel", self )
    self.Container:DockMargin( 0, 0, 0, 0 )
    self.Container:Dock( TOP )
    self.Container:SetSize( self:GetWide() - 20, self:GetTall() - 150 )
    self.Container:SetPos( ( self:GetWide() / 2 ) - ( self.Container:GetWide() / 2 ), 120 )
    self.Container:SetBackgroundColor( ColorSchemes.ButtonText )

    -- Status Bar
    self.Statusbar = vgui.Create( "DPanel", self )
    self.Statusbar:DockMargin( 0, 0, 0, 0 )
    self.Statusbar:Dock( BOTTOM )
    self.Statusbar:SetSize( self:GetWide(), self:GetTall()-750 )
    self.Statusbar:SetBackgroundColor( ColorSchemes.ButtonText )

    -- alertbox
    if self.AlertPANEL == nil then
        self.AlertPANEL = vgui.Create( 'DPanel', self.Container )
        self.AlertPANEL:Dock( TOP )
        self.AlertPANEL:SetSize( self.Container:GetWide(), 55 )
        self.AlertPANEL:SetBackgroundColor( ColorSchemes.ButtonText )
    end

    -- sub_self.Container
    self.MainView = vgui.Create( "DPanel", self.Container )
    self.MainView:DockMargin( 15, 15, 15, 15 )
    self.MainView:Dock( TOP )
    self.MainView:SetSize( self:GetWide() - 20, self:GetTall() - 230 )
    self.MainView:SetPos( ( self:GetWide() / 2 ) - ( self.MainView:GetWide() / 2 ), 120 )
    --TODO Eventually change this background color to a ColorScheme defined color
    self.MainView:SetBackgroundColor( Color( 0, 0, 0, 0 ) )

    -- Debug Status
    self.StatusLabel = vgui.Create( "DLabel", self.Statusbar )
    self.StatusLabel:Dock( RIGHT )
    self:ChangeSatus( "Rocking and Rolling" )
end

--Changes the Main Menu status label. 
--This is not timed, it is permanent 
function PANEL:ChangeSatus( text )
    self.StatusLabel:SetText( text )
end    

--Which PANEL to display in the main view, along with the state to report back.
--IE: D_cfcnewsderma, "Viewing News"
function PANEL:AddToMainView( panel, state )
    --Clear any PANELs currently in the main view
    self.MainView:Clear()
    --The actual PANEL to display
    self.SubMainViewPANEL = vgui.Create( panel, self.MainView)   

end

function PANEL:Paint( w, h )
        Derma_DrawBackgroundBlur( self )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 55, 55, 55, 220 ) )
        surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )

        -- surface.DrawOutlinedRect( 0, 0, w, h )
        draw.SimpleText( string.format( DermaHeaderTitle, LocalPlayer():Nick() ), "CFC_Special", 5, 5, ColorSchemes.HeaderText )
end

function PANEL:Think()

end

vgui.Register( 'D_cfcmainderma', PANEL )
