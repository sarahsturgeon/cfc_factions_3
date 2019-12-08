if not CLIENT then return end

local Panel = {}
-- cfcFactions.Dermas["View Users"] = {1, Panel}

cfcFactions:RegisterDermaMenu( "View Users", Panel, 1 )

function Panel:Init()
    self:SetSize( 500, 500 )
    self:Center()

    self.mainFrame = vgui.Create( "DFrame", self )
    self.mainFrame:Dock( FILL )
    self.mainFrame:MakePopup()

    self.categoryList = vgui.Create( "DListView", self.mainFrame )
    self.categoryList:Dock( FILL )
    self.categoryList:AddColumn( "Steam ID" )
    self.categoryList:AddColumn( "Player" )
    self.categoryList:AddColumn( "Kills" )
    self.categoryList:AddColumn( "Deaths" )
    self.categoryList:AddColumn( "Faction Name" )
    self.categoryList:AddColumn( "Faction Rank" )

    --self.categoryList:AddLine( "1234", "Bleck", "69", "420", "Tunnel Snakes", "God Status" )

    function self.categoryList:OnRowRightClick( id, line )
        local optionMenu = DermaMenu()

        optionMenu:AddOption( "Copy SteamID" ):SetIcon( "icon16/page_edit.png" )
        optionMenu:AddOption( "Copy FactionID" ):SetIcon( "icon16/page_edit.png" )

        --[[if LocalPlayer():canKick() then
            optionMenu:AddOption( "Kick Player" ):SetIcon( "icon16/lock.png" )
        end]]

        optionMenu:AddOption( "Invite to Faction" ):SetIcon( "icon16/user_add.png" )

        if LocalPlayer():IsAdmin() then
            optionMenu:AddSpacer()

            local child, parent = optionMenu:AddSubMenu( "Staff Actions" )
            parent:SetIcon( "icon16/shield.png" )
            child:AddOption( "Kick From Faction" ):SetIcon( "icon16/asterisk_yellow.png" )
            child:AddOption( "Ban From Factions" ):SetIcon( "icon16/flag_red.png" )
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

vgui.Register( 'D_cfcusersderma', Panel )

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
