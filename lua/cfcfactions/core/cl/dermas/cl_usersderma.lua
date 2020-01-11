if not CLIENT then return end

local Panel = {}

cfcFactions:RegisterDermaMenu( "View Users", Panel, 1 )

function Panel:Init()
    self:Dock( FILL )

    self.CategoryList = vgui.Create( "DListView", self )
    self.CategoryList:Dock( FILL )
    self.CategoryList:AddColumn( "Steam ID" )
    self.CategoryList:AddColumn( "Player" )
    self.CategoryList:AddColumn( "Kills" )
    self.CategoryList:AddColumn( "Deaths" )
    self.CategoryList:AddColumn( "Faction Name" )
    self.CategoryList:AddColumn( "Faction Rank" )

    local playerList = {}
    local iterator = 1

    for _, ply in pairs( player.GetHumans() ) do
        if ply:IsValid() and ply:IsPlayer() then
            -- self.CategoryList( ply:SteamID(), ply:Name(), ply:Frags(), ply:Deaths(), ply:GetFaction().Name, ply:GetRank() )
            playerList[ iterator ] = ply
            iterator = iterator + 1
        end
    end

    function self.CategoryList:OnRowRightClick( id, line )
        local optionMenu = DermaMenu()

        optionMenu:AddOption( "Copy SteamID", function()
            SetClipboardText( line:GetColumnText( 1 ) )
        end ):SetIcon( "icon16/page_edit.png" )

        optionMenu:AddOption( "Copy FactionID", function()
            -- SetClipboardText( playerList[id]:GetFactionID() )
        end ):SetIcon( "icon16/page_edit.png" )

        --[[ if LocalPlayer():canKick() then
            optionMenu:AddOption( "Kick Player", function()
                playerList[id]:KickPlayerFromFaction()
            end ):SetIcon( "icon16/lock.png" )
        end]]

        optionMenu:AddOption( "Invite to Faction" ):SetIcon( "icon16/user_add.png" )

        if LocalPlayer():IsAdmin() then
            optionMenu:AddSpacer()

            local child, parent = optionMenu:AddSubMenu( "Staff Actions" )
            parent:SetIcon( "icon16/shield.png" )

            child:AddOption( "Kick From Faction", function()
                -- playerList[id]:KickPlayerFromFaction()
            end ):SetIcon( "icon16/asterisk_yellow.png" )

            child:AddOption( "Ban From Factions", function()
                -- playerList[id]:BanPlayerFromFactions()
            end ):SetIcon( "icon16/flag_red.png" )
        end

        optionMenu:Open()
    end
end

--[[
function Panel:Paint( w, h )

end

function Panel:Think()

end
]]

vgui.Register( "D_cfcusersderma", Panel )

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
