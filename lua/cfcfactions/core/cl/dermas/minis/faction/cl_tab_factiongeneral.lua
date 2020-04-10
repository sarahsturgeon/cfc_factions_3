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

    local success, playerData = await( cfcFactions.api.GetPlayerBySteamID64( steamIDs ) )

    p( success, playerData )
    if not success then return end

end
PANEL.Initialize = async( _Initialize )

function PANEL:MakeHeader()
    local header = vgui.Create( "DPanel", self )
    header:Dock( TOP )
    header:SetBackgroundColor( color_white )
    header.Paint = cfcFactions.solidBgPaint
    function header:PerformLayout( w, h )
        local parentW, parentH = self:GetParent():GetSize()
        self:SetTall( parentH * 0.2 )
    end

    self.header = header
end

function PANEL:SetFactionData( data )
    self.faction = data
    self:Initialize()
end