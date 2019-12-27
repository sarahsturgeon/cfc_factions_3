local PANEL = {}
local cfg = ColorSchemes

vgui.Register( 'D_factionpanel', PANEL )

function PANEL:Init()
    self.Faction = nil
    self:SetSize( 255, 100 )

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
    self.MainPanel:SetBackgroundColor( cfg.BackgroundDerma )
    self.MainPanel:SetSize( 355, 100 )

    --Locked icon       Faction Name        Faction ID
    self.TopBar = vgui.Create( "DPanel" , self.MainPanel )
    self.TopBar:Dock( TOP ) 
    self.TopBar:DockPadding( 0, 0, 0, 0 )
    self.TopBar:SetBackgroundColor( self.MainColor )

    self.TopBarLeft = vgui.Create( "DPanel" , self.TopBar )
    self.TopBarLeft:Dock( LEFT ) 
    self.TopBarLeft:DockPadding( 5, 0, 0, 0 )
    self.TopBarLeft:SetBackgroundColor( self.MainColor )
    self.TopBarLeft:SetWide( 25 )

    self.TopBarMiddle = vgui.Create( "DPanel" , self.TopBar )
    self.TopBarMiddle:Dock( LEFT ) 
    self.TopBarMiddle:DockPadding( 0, 0, 0, 0 )
    self.TopBarMiddle:SetBackgroundColor( self.MainColor )
    self.TopBarMiddle:SetWide( 400 )

    self.TopBarRight = vgui.Create( "DPanel" , self.TopBar )
    self.TopBarRight:Dock( LEFT ) 
    self.TopBarRight:DockPadding( 100, 0, 0, 0 )
    self.TopBarRight:SetWide( 150 )
    --self.TopBarRight:SetBackgroundColor( self.MainColor )
    self.TopBarRight:SetBackgroundColor( self.MainColor )

    self.MiddlePanel = vgui.Create( "DPanel" , self.MainPanel )
    self.MiddlePanel:Dock( FILL )
    self.MiddlePanel:SetBackgroundColor( cfg.BackgroundPanel )

    self.BottomPanel = vgui.Create ( "DPanel" , self.MainPanel )
    self.BottomPanel:SetBackgroundColor( cfg.BackgroundPanel )

    self.FactionPrivateIcon = vgui.Create( "DImage", self.TopBarLeft )
    self.FactionPrivateIcon:SetImage( "resource/icons/lock_icon/lock_locked.png" )
    self.FactionPrivateIcon:SetSize( 16, 16 )
    self.FactionPrivateIcon:Dock( LEFT )
    self.FactionPrivateIcon:DockPadding(2, 0, 2, 0, 0)

    self.FactionNameLabel = vgui.Create( "DLabel", self.TopBarMiddle )
    self.FactionNameLabel:SetText( self.FactionName )
    self.FactionNameLabel:SetTextColor( Color(255, 255, 255, 255 ) )
    self.FactionNameLabel:Dock( LEFT )
    -- number paddingLeft, number paddingTop, number paddingRight, number paddingBottom
    self.FactionNameLabel:DockPadding( 15, 0, 0, 0, 0)
    self.FactionNameLabel:SetWide( self.TopBarMiddle:GetWide() )

    self.FactionIDLabel = vgui.Create( "DLabel", self.TopBarRight )
    self.FactionIDLabel:SetText( self.FactionID )
    self.FactionIDLabel:SetTextColor( cfg.NormalText )
    self.FactionIDLabel:Dock( LEFT )
    self.FactionIDLabel:DockPadding( 0, 0, 0, 0 )

    self.LeftInnerPanel = vgui.Create ( "DPanel" , self.MiddlePanel )
    self.LeftInnerPanel:Dock( LEFT )
    self.LeftInnerPanel:SetBackgroundColor( cfg.BackgroundPanel )
    self.LeftInnerPanel:SizeToContents()

    self.MiddleInnerPanel = vgui.Create ( "DPanel" , self.MiddlePanel )
    self.MiddleInnerPanel:Dock( LEFT )
    self.MiddleInnerPanel:SetBackgroundColor( cfg.BackgroundPanel )
    self.MiddleInnerPanel:SizeToContents()

    self.RightInnerPanel = vgui.Create ( "DPanel" , self.MiddlePanel )
    self.RightInnerPanel:Dock( LEFT )
    self.RightInnerPanel:SetBackgroundColor( cfg.BackgroundPanel )
    self.RightInnerPanel:SizeToContents() 

    self.DescriptionLabel = vgui.Create( "DLabel", self.LeftInnerPanel )
    self.DescriptionLabel:SetWide( self.LeftInnerPanel:GetWide() )
    self.DescriptionLabel:Dock( LEFT )
    self.DescriptionLabel:SizeToContents()

    self.AvatarImage = vgui.Create( "DImage", self.MiddleInnerPanel )
    self.AvatarImage:Dock( TOP )
    self.OwnerLabel = vgui.Create( "DLabel" , self.RightInnerPanel )
    self.OwnerLabel:SetText( self.Owner )
    self.OwnerLabel:Dock( TOP )
    self.MembersLabel = vgui.Create( "DLabel" , self.RightInnerPanel )
    self.MembersLabel:SetText( ( self.Members .. "/" .. self.MaxMembers ) )
    self.MembersLabel:Dock( TOP )
    self.KillsDeathsLabel = vgui.Create( "DLabel" , self.RightInnerPanel )
    self.KillsDeathsLabel:SetText( ("Kills: " .. self.Kills .. "/" .. "Deaths: " .. self.Deaths ) )
    self.KillsDeathsLabel:Dock( TOP )

    self:SetFactionName( "Uninitialized Faction" )
    self:SetFactionDescription(nil)

end
--faction functions to set this panel up
function PANEL:SetFactionName( name )
    local Name = ""
    if Name == nil or #Name == 0 then
        Name = "Uninitialized Faction"
    else
        Name = string.Trim( name )
        if #Name >= 256 then
            Name = string.Sub( Name, 1, 255 )
        end
    end
    self.FactionName = Name
    self.FactionNameLabel:SetText( self.FactionName )
end
function PANEL:SetFactionPrivate( isprivate )
    self.FactionLocked = isprivate
    if self.FactionLocked then
        self.FactionPrivateIcon:SetImage( "resource/icons/lock_icon/lock_locked.png" )
    else
        self.FactionPrivateIcon:SetImage( "resource/icons/lock_icon/lock_unlocked.png" )
    end
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
    self.KillsDeathsLabel:SetText( ("Kills: " .. self.Kills .. "/" .. "Deaths: " .. self.Deaths ) )
end
function PANEL:SetFactionDeaths( deaths )
    self.KillsDeathsLabel:SetText( ("Kills: " .. self.Kills .. "/" .. "Deaths: " .. self.Deaths ) )
end
function PANEL:SetFactionKD( kills, deaths )
    self:SetFactionKills( kills )
    self:SetFactionDeaths( deaths )
end
function PANEL:SetFactionDescription( description )
    local Text = description
    if Text == nil then 
        Text = "No description provided."
    else
       Text = string.Trim( Text )
    end
    self.Description = Text
    self.DescriptionLabel:SetText( 'Description: ' .. self.Description )
    self.LeftInnerPanel:SizeToContents()
end
function PANEL:GetFactionID()
    local ReturnID = self.FactionID and self.FactionID > 0 or nil 
    return ReturnID 
end

function PANEL:OnMousePressed( keyCode ) 
    if keyCode == MOUSE_FIRST then
        self:SetPaintBorderEnabled( true ) 
    end
 end