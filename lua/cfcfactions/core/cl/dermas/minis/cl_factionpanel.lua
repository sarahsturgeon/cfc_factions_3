local PANEL = {}
local cfg = ColorSchemes

vgui.Register( 'D_factionpanel', PANEL )

function PANEL:Init()
    
    self.Faction = nil

    self.MainPanel = vgui.Create( "DPanel", self )
    self.MainPanel:Dock( FILL )

    --Locked icon       Faction Name        Faction ID
    self.TopBar = vgui.Create( "DPanel" , self.MainPanel )
    self.TopBar:Dock( TOP ) 

    self.MiddlePanel = vgui.Create( "DPanel" , self.MainPanel )
    self.MiddlePanel:Dock( FILL )

    self.BottomPanel = vgui.Create ( "DPanel" , self.MainPanel )


    --Panel Faction Stats
    --Top Panel
    self.FactionLocked = false
    self.FactionName = "Uninitialized Faction"
    self.FactionID = 0
    --Middle Panel
    self.Description = ""
    self.Avatar = ""
    self.Owner = "<no owner>"
    self.Members = 0
    self.MaxMembers = 1
    self.Kills = 0
    self.Deaths = 0
    --Bottom Panel

    self.FactionPrivateIcon = vgui.Create( "DImage", self.TopBar )
    self.FactionPrivateIcon:SetImage( "resource/icons/lock_icon/lock_locked.png" )

    self.FactionNameLabel = vgui.Create( "DLabel", self.TopBar )
    self.FactionNameLabel:SetText( self.FactionName )
    self.FactionNameLabel:SetTextColor( cfg.NormalText )

    self.FactionIDLabel = vgui.Create( "DLabel", self.TopBar )
    self.FactionIDLabel:SetText( self.FactionID )
    self.FactionIDLabel:SetTextColor( cfg.NormalText )

    self.LeftInnerPanel = vgui.Create ( "DPanel" , self.MiddlePanel )
    self.LeftInnerPanel:Dock( LEFT )
    self.MiddleInnerPanel = vgui.Create ( "DPanel" , self.MiddlePanel )
    self.MiddleInnerPanel:Dock( LEFT )
    self.RightInnerPanel = vgui.Create ( "DPanel" , self.MiddlePanel )
    self.RightInnerPanel:Dock( RIGHT )

    self.DescriptionLabel = vgui.Create( "DTextEntry", self.LeftInnerPanel )
    self.DescriptionLabel:SetText( self.Description )
    self.AvatarImage = vgui.Create( "DImage", self.MiddleInnerPanel )
    self.OwnerLabel = vgui.Create( "DLabel" , self.RightInnerPanel )
    self.OwnerLabel:SetText( self.Owner )
    self.MembersLabel = vgui.Create( "DLabel" , self.RightInnerPanel )
    self.MembersLabel:SetText( ( self.Members .. "/" .. self.MaxMembers ) )
    self.KillsDeathsLabel = vgui.Create( "DLabel" , self.RightInnerPanel )
    self.KillsDeathsLabel:SetText( ("Kills: " .. self.Kills .. "/" .. "Deaths: " .. self.Deaths ) )

end
--faction functions to set this panel up
function PANEL:SetFactionName( name )
    self.FactionName = name
    self.FactionName:SetText( self.FactionName )
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
    self.Description = description
    self.DescriptionLabel:setText( self.Description )
end
function PANEL:GetFactionID()
    local ReturnID = self.FactionID and self.FactionID > 0 or nil 
    return ReturnID 
end