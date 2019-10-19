if not CLIENT then return end

local Panel = {}
-- cfcFactions.Dermas["View Users"] = {1, Panel}

cfcFactions:RegisterDermaMenu( "View Users", Panel, 1 )

function Panel:Init()
    --[[
    local quickMenu = DermaMenu()
    quickMenu:SetPos( gui.MouseX(), gui.MouseY() )

    menu:AddOption( "Request Invite", function()
        --
    end )

    menu:AddOption( "Copy ID", function()
        --
    end )

    menu:AddOption( "Edit", function()
        --
    end )

    menu:AddOption( "Flag for Administration", function()
        --
    end )

    menu:AddSpacer()

    menu:AddOption( "Delete", function()
        --
    end )
    ]]
end

function Panel:Paint( w, h )

end

function Panel:Think()

end

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
