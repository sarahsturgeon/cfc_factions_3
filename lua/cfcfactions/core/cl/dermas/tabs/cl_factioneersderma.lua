local PANEL = {}

function PANEL:Init()
    self.Rows = {}

    -- function self.CategoryList:OnRowRightClick( id, line )
    --     local optionMenu = DermaMenu()

    --     optionMenu:AddOption( "Copy SteamID", function()
    --         SetClipboardText( line:GetColumnText( 1 ) )
    --     end ):SetIcon( "icon16/page_edit.png" )

    --     optionMenu:AddOption( "Copy FactionID", function()
    --         --SetClipboardText( playerList[id]:GetFactionID() )
    --     end ):SetIcon( "icon16/page_edit.png" )

    --     --[[if LocalPlayer():canKick() then
    --         optionMenu:AddOption( "Kick Player", function()
    --             playerList[id]:KickPlayerFromFaction()
    --         end ):SetIcon( "icon16/lock.png" )
    --     end]]

    --     optionMenu:AddOption( "Invite to Faction" ):SetIcon( "icon16/user_add.png" )

    --     if LocalPlayer():IsAdmin() then
    --         optionMenu:AddSpacer()

    --         local child, parent = optionMenu:AddSubMenu( "Staff Actions" )
    --         parent:SetIcon( "icon16/shield.png" )

    --         child:AddOption( "Kick From Faction", function()
    --             --playerList[id]:KickPlayerFromFaction()
    --         end ):SetIcon( "icon16/asterisk_yellow.png" )

    --         child:AddOption( "Ban From Factions", function()
    --             --playerList[id]:BanPlayerFromFactions()
    --         end ):SetIcon( "icon16/flag_red.png" )
    --     end

    --     optionMenu:Open()
    -- end
end

function PANEL:AddPlayerRow( player )
    --self.Rows[player] = vgui.Create( )
end

function PANEL:RemovePlayerRow( player )
    self.Rows[player] = nil
end

-- TODO: tie into the system

local function fetchFactionUsers()

end

net.Receive( "CFC_Fac_FetchUsers", fetchFactionUsers )

local function factionUserOffline()

end

net.Receive( "CFC_Fac_UserOffline", factionUserOffline )

local function factionFetchOnline()

end

net.Receive( "CFC_Fac_FetchOnline", factionFetchOnline )

local function factionUserChange()

end

net.Receive( "CFC_Fac_UserChange", factionUserChange )

local function factionUserUpdateStats()

end

net.Receive( "CFC_Fac_UserUpdateStats", factionUserUpdateStats )

local function factionUserDeleted()

end

net.Receive( "CFC_Fac_UserDeleted", factionUserDeleted )

vgui.Register( 'D_cfcusersderma', PANEL )

