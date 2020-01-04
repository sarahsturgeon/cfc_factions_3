local PANEL = {}
local cfg = ColorSchemes

vgui.Register( 'D_factionpanel', PANEL )

function PANEL:Init()
    local fPanel = self
    self:AddMouseEvent(self)
    self.Faction = nil

    --Panel Faction Stats
    --Top Panel
    self.FactionLocked = false
    self.FactionName = ""
    self.FactionID = 0

    --Middle Panel
    self.Description = ""
    self.Avatar = ""
    self.Owner = "<no owner>"
    self.Members = 0
    self.MaxMembers = 1
    self.Kills = 0
    self.Deaths = 0
    self.MainColor = ColorRand( false ) 
    --Bottom Panel

    self.MainPanel = vgui.Create( "DPanel", self )
    self.MainPanel:Dock( FILL )
    self.MainPanel:DockMargin( 4, 4, 4, 4 )
    self.MainPanel:SetBackgroundColor( cfg.BackgroundDerma )

    --Locked icon       Faction Name        Faction ID
    self.TopBar = vgui.Create( "DPanel" , self.MainPanel )
    self.TopBar:Dock( TOP ) 
    self.TopBar:DockPadding( 0, 0, 0, 0 )
    self.TopBar:SetTall( 26 )
    self:AddMouseEvent(self.TopBar)
    function self.TopBar:Paint(w, h)
        surface.SetDrawColor( Color(110, 136, 148) )
        local lineThickness = 2

        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( fPanel.MainColor )
        -- top line
        surface.DrawRect( 0, h - lineThickness, w, lineThickness )
        -- bottom line
        surface.DrawRect( 0, 0, w, lineThickness )

        surface.SetDrawColor( Color(0,0,0) )
        -- left bar
        surface.DrawRect( 100, h * 0.2, lineThickness - 1, h * 0.7 )
        -- right bar
        surface.DrawRect( w - 100, h * 0.2, lineThickness - 1, h * 0.7 )

    end

    self.TopBarLeft = vgui.Create( "DPanel" , self.TopBar )
    self.TopBarLeft:SetWide( 100 )
    self.TopBarLeft:Dock( LEFT ) 
    self.TopBarLeft:DockPadding( 5, 0, 0, 0 )
    self.TopBarLeft.Paint = nil

    -- Right before middle so that Dock Top positions itself correctly
    self.TopBarRight = vgui.Create( "DPanel" , self.TopBar )
    self.TopBarRight:SetWide( 100 )
    self.TopBarRight:Dock( RIGHT ) 
    self.TopBarRight:DockPadding( 0, 0, 5, 0 )
    self.TopBarRight:SetBackgroundColor( Color(64, 82, 100) )
    self.TopBarRight.Paint = nil

    self.TopBarMiddle = vgui.Create( "DPanel" , self.TopBar )
    self.TopBarMiddle:Dock( TOP ) 
    self.TopBarMiddle:DockPadding( 0, 0, 0, 0 )
    self.TopBarMiddle:SetBackgroundColor( self.MainColor )
    self.TopBarMiddle.Paint = nil

    self.MiddlePanel = vgui.Create( "DPanel" , self.MainPanel )
    self.MiddlePanel:Dock( FILL )
    self.MiddlePanel:SetBackgroundColor( cfg.BackgroundPanel )

    self.FactionPrivateIcon = vgui.Create( "DImage", self.TopBarLeft )
    self.FactionPrivateIcon:SetImage( "resource/icons/lock.png" )
    self.FactionPrivateIcon:SetSize( 16, 16 )
    self.FactionPrivateIcon:AlignLeft( 5 )
    self.FactionPrivateIcon:CenterVertical( 0.55 )

    self.FactionNameLabel = vgui.Create( "DLabel", self.TopBarMiddle )
    self.FactionNameLabel:SetFont( "CFC_Normal_Bold" )
    self.FactionNameLabel:SetText( self.FactionName )
    self.FactionNameLabel:SetTextColor( cfg.DarkText )
    self.FactionNameLabel:SetContentAlignment( 5 )
    self.FactionNameLabel:Dock( FILL )
    self.FactionNameLabel:DockPadding( 0, 0, 0, 0 )

    self.FactionIDLabel = vgui.Create( "DLabel", self.TopBarRight )
    self.FactionIDLabel:SetFont( "CFC_Normal_Bold" )
    self.FactionIDLabel:SetText( self.FactionID )
    self.FactionIDLabel:SetTextColor( cfg.DarkText )
    self.FactionIDLabel:Dock( FILL )
    self.FactionIDLabel:DockPadding( 0, 0, 0, 0 )
    self.FactionIDLabel:SetContentAlignment( 6 )

    self.LeftInnerPanel = vgui.Create ( "DPanel" , self.MiddlePanel )
    self.LeftInnerPanel:Dock( LEFT )
    self.LeftInnerPanel:SetBackgroundColor( cfg.BackgroundPanel )

    self.MiddleInnerPanel = vgui.Create ( "DPanel" , self.MiddlePanel )
    self.MiddleInnerPanel:Dock( FILL )
    self.MiddleInnerPanel:SetBackgroundColor( cfg.BackgroundPanel )
    self.MiddleInnerPanel:InvalidateLayout( true )

    self.RightInnerPanel = vgui.Create ( "DPanel" , self.MiddlePanel )
    self.RightInnerPanel:Dock( RIGHT )
    self.RightInnerPanel:SetBackgroundColor( cfg.BackgroundPanel )

    -- self.DescriptionTitleLabel = vgui.Create( "DLabel", self.LeftInnerPanel )
    -- self.DescriptionTitleLabel:Dock( TOP )
    -- self.DescriptionTitleLabel:DockMargin( 8, 5, 5, 0 )

    self.DescriptionLabel = vgui.Create( "DLabel", self.RightInnerPanel )
    self.DescriptionLabel:Dock( FILL )
    self.DescriptionLabel:DockMargin( 8, 0, 5, 5 )
    self.DescriptionLabel:SetWrap( true )
    self.DescriptionLabel:SetContentAlignment( 5 )
    --self.DescriptionLabel:SetTextColor( Color(180, 180, 180, 255) ) -- Faded text colour, should probably be in ColorSchemes?

    self.AvatarImage = vgui.Create( "DImageCircle", self.MiddleInnerPanel )
    self.AvatarImage:SetImage( "resource/icons/no_avatar.png" )
    -- Force the image to be square but max size it can be
    function self.AvatarImage:PerformLayout()
        local p = self:GetParent()
        local w, h = p:GetSize()
        local size = math.min(w, h) - 15
        self:SetSize(size, size)
        self:SetPos( (w-size) / 2, (h-size) / 2 )
    end

    self.OwnerLabel = vgui.Create( "DLabel" , self.LeftInnerPanel )
    self.OwnerLabel:SetText( "Owner: " .. self.Owner )
    self.OwnerLabel:SetContentAlignment( 5 )
    self.OwnerLabel:Dock( TOP )
    self.OwnerLabel:DockMargin( 5, 20, 5, 0 )

    self.MembersLabel = vgui.Create( "DLabel" , self.LeftInnerPanel )
    self.MembersLabel:SetText( "Members: " .. ( self.Members .. "/" .. self.MaxMembers ) )
    self.MembersLabel:SetContentAlignment( 5 )
    self.MembersLabel:Dock( FILL )
    self.MembersLabel:DockMargin( 5, 0, 5, 0 )

    self.KillsDeathsLabel = vgui.Create( "DLabel" , self.LeftInnerPanel )
    self.KillsDeathsLabel:SetText( ("Kills: " .. self.Kills .. "   Deaths: " .. self.Deaths ) )
    self.KillsDeathsLabel:SetContentAlignment( 5 )
    self.KillsDeathsLabel:Dock( BOTTOM )
    self.KillsDeathsLabel:DockMargin( 5, 0, 5, 20 )

    self:SetFactionName( "Uninitialized Faction" )
    self:SetFactionDescription(nil)
    self:SetFactionPrivate( false )

    -- Mouse event wasn't been captured so I put it on EVERYTHING.
    -- Calls the original, don't worry :)
    for k, v in pairs(self:GetTable()) do
        if type(v) == "Panel" then
            self:AddMouseEvent(v)
        end
    end

end

function PANEL:PerformLayout(w, h)
    self.LeftInnerPanel:SetWide(w * 0.35)
    self.RightInnerPanel:SetWide(w * 0.35)
end

--faction functions to set this panel up
function PANEL:SetFactionName( name )
    if name == nil or #name == 0 then
        name = "Uninitialized Faction"
    else
        name = string.Trim( name )
        if #name >= 256 then
            name = string.Sub( name, 1, 255 )
        end
    end
    self.FactionName = name
    if #name > 30 then
        name = string.sub(name, 1, 28) .. "..."
    end
    self.FactionNameLabel:SetText( name )
end
function PANEL:SetFactionPrivate( isprivate )
    self.FactionLocked = isprivate
    self.FactionPrivateIcon:SetVisible(self.FactionLocked)
end
function PANEL:SetFactionID( id )
    self.FactionID = id
    self.FactionIDLabel:SetText( self.FactionID )
end
function PANEL:SetFactionAvatar( imgpath )
    self.Avatar = imgpath
    self.AvatarImage:SetImage( self.Avatar )
end
function PANEL:SetFactionOwner( owner )
    self.Owner = owner
    self.OwnerLabel = "Owner: " .. self.Owner
end
function PANEL:SetFactionCurrentMembers( number )
    self.Members = number
    self.MembersLabel:SetText( ( self.Members .. "/" .. self.MaxMembers ) )
end
function PANEL:SetFactionMaxMembers( number )
    self.MaxMembers = number
    self.MembersLabel:SetText( ( self.Members .. "/" .. self.MaxMembers ) )
end
function PANEL:SetFactionKills( kills )
    self.Kills = kills
    self:UpdateKDLabel()
end
function PANEL:SetFactionDeaths( deaths )
    self.Deaths = deaths
    self:UpdateKDLabel()
end
function PANEL:SetFactionKD( kills, deaths )
    self:SetFactionKills( kills )
    self:SetFactionDeaths( deaths )
end
function PANEL:UpdateKDLabel()
    self.KillsDeathsLabel:SetText( ("Kills: " .. self.Kills .. "   Deaths: " .. self.Deaths .. "   KD: " .. (math.Round(self.Kills/self.Deaths, 2)) ) )
end
function PANEL:SetFactionDescription( description )
    if description == nil then
        --self.DescriptionTitleLabel:SetText("No description provided.")
        self.Description = ""
    else
        --self.DescriptionTitleLabel:SetText("Description:")
        self.Description = string.Trim( description )
    end
    self.DescriptionLabel:SetText( self.Description )
end

function PANEL:GetFactionID()
    local ReturnID = self.FactionID > 0 and self.FactionID or nil 
    return ReturnID 
end

function PANEL:AddMouseEvent(panel)
    panel:SetMouseInputEnabled( true )
    local fPanel = self
    local oldMousePressed = panel.OnMousePressed
    function panel:OnMousePressed( keyCode )
        if keyCode == MOUSE_RIGHT then
            local Menu = DermaMenu()
            Menu:AddOption( "Copy ID", function()
                SetClipboardText(tostring(fPanel:GetFactionID()))
            end)
            -- I imagine this will have to work out local player access rights, and a bunch of other shit, so lets out-source it
            hook.Run("CFC_FactionPanel_PopulateMenu", fPanel, Menu) -- Passes in menu to populate
            Menu:Open()
        end
        if oldMousePressed then
            oldMousePressed(self, keyCode)
        end
    end
 end

hook.Add("CFC_FactionPanel_PopulateMenu", "Example", function(panel, Menu)
    
    Menu:AddSpacer()
    Menu:AddOption( "Rename" )
    Menu:AddOption( "Delete" )
    -- etc.
end)