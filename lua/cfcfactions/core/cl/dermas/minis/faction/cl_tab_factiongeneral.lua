local PANEL = {}
local cfg = cfcFactions.Config.ColorSchemes
vgui.Register( "D_cfc_faction_general", PANEL )

function PANEL:Init()
end

local function getLeaderSteamID( leader )
    return leader.steam_id
end

local function _Initialize( self )
    self:MakeHeader()

    local getSteamID = FindMetaTable( "Player" ).SteamID64
    local onlinePlayerIDs = table.map( player.GetAll(), getSteamID )

    local leaderPlayerIDs = table.map( self.faction.leaders_summary, getLeaderSteamID )

    local steamIDs = table.Add( onlinePlayerIDs, leaderPlayerIDs )

    local success, playerData = awaitSpinner( self, cfcFactions.api.GetPlayerBySteamID64( steamIDs ) )

    if not success then return end

end
PANEL.Initialize = async( _Initialize )

function PANEL:MakeHeader()
    local fontHeight = 30
    local this = self
    -- Header bar
    local header = vgui.Create( "DPanel", self )
    header:Dock( TOP )
    header:SetBackgroundColor( cfg.BackgroundDerma )
    header.Paint = cfcFactions.solidBgPaint
    function header:PerformLayout( w, h )
        local parentW, parentH = self:GetParent():GetSize()
        self:SetTall( parentH * 0.3 )
    end
    self.header = header

    -- Faction icon
    local icon = vgui.Create( "DImageCircle", header )
    icon:CenterHorizontal()
    icon:SetDrawOutline( true )
    icon:SetOutlineColor( self.faction.color )
    icon:SetImage( "resource/icons/no_avatar.png" )
    function icon:PerformLayout( w, h )
        local parentW, parentH = self:GetParent():GetSize()
        self:SetSize( parentH * 0.8, parentH * 0.8 )
        local offset = parentH * 0.1
        self:SetPos( offset, offset )
    end
    header.icon = icon

    -- Horizontal line
    local hLine = vgui.Create( "DShape", header )
    hLine:SetType( "Rect" )
    hLine:SetColor( color_white )
    function hLine:PerformLayout( w, h )
        local parentW, parentH = self:GetParent():GetSize()
        local x = parentH
        local y = parentH * 0.5
        self:SetPos( x, y )
        self:SetSize( parentW - parentH * 2, 1 )
    end

    -- Private icon
    if self.faction.private then
        local lockIcon = vgui.Create( "DImage", header )
        lockIcon:SetImage( "resource/icons/lock.png" )
        lockIcon:SetSize( 32, 32 )
        function lockIcon:PerformLayout( w, h )
            local parentW, parentH = self:GetParent():GetSize()
            self:SetPos( parentH + 4, parentH * 0.5 - 37 )
        end
    end

    -- Faction name label
    local name = vgui.Create( "DLabel", header )
    name:SetText( self.faction.name )
    name:SetFont( "CFC_Special" )
    function name:PerformLayout( w, h )
        local parentW, parentH = self:GetParent():GetSize()
        local leftPad = this.faction.private and 28 or 0

        self:SetPos( parentH + 10 + leftPad, parentH * 0.5 - fontHeight )
        self:SetSize( parentW - ( parentH * 2 ) - 20 - leftPad, fontHeight )
    end

    -- Faction description label
    local description = vgui.Create( "DLabel", header )
    description:SetText( self.faction.description )
    description:SetFont( "CFC_Special" )
    function description:PerformLayout( w, h )
        local parentW, parentH = self:GetParent():GetSize()

        self:SetPos( parentH + 10, parentH * 0.5 + 5 )
        self:SetSize( parentW - ( parentH * 2 ) - 20, fontHeight )
    end

    -- Bottom line
    local bLine = vgui.Create( "DShape", header )
    bLine:SetType( "Rect" )
    bLine:SetColor( color_white )
    function bLine:PerformLayout( w, h )
        local parentW, parentH = self:GetParent():GetSize()
        self:SetPos( 0, parentH - 1 )
        self:SetSize( parentW, 1 )
    end

end

function PANEL:SetFactionData( data )
    self.faction = data
    self:Initialize()
end

hook.Add( "cfc_Fac_AddFactionSubTabs", "cfc_Fac_AddGeneralFactionSubTab", function( factionPanel, factionData )
    local panel = vgui.Create( "D_cfc_faction_general" )
    panel:SetFactionData( factionData )
    factionPanel:AddSubTab( "General", panel )
end )
