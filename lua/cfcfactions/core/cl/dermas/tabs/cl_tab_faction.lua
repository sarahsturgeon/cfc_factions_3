local PANEL = {}
local cfg = cfcFactions.Config.ColorSchemes
vgui.Register( "D_cfc_tab_faction", PANEL )

include( "cfcfactions/core/cl/dermas/minis/faction/cl_tab_factiongeneral.lua" )

function PANEL:Init()
    self.pSheet = vgui.Create( "DPropertySheetPretty", self )
    self.pSheet:Dock( FILL )
end

local function _Initialize( self )
    self.pSheet:Clear()

    local success, factionData = awaitSpinner( self, cfcFactions.api.GetFaction( self.factionID ) )
    if not success then return end
    factionData = factionData[1]
    factionData.color = string.ToColor( string.Replace( factionData.color, ",", " " ) .. " 255" )

    self.general = vgui.Create( "D_cfc_faction_general" )
    self.general:SetFactionData( factionData )
    self.pSheet:AddSheet( "General", self.general )

end
PANEL.Initialize = async( _Initialize )

function PANEL:SetFactionID( id )
    self.factionID = id
    self:Initialize()
end

function PANEL:OnShow( factionID )
    self:SetFactionID( factionID or cfcFactions.localUserData.faction.id )
end

function PANEL:PerformLayout( w, h )
end

hook.Add( "cfc_Fac_AddMenuTabs", "cfc_Fac_AddFaction", function( panel )
    panel:AddMenuTab( "My Faction", vgui.Create( "D_cfc_tab_faction" ), not tobool( cfcFactions.localUserData.faction ) )
end )
