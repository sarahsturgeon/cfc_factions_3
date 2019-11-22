if not CLIENT then return end

local factioneers = {}

local ViewUserDerma = {}
-- cfcFactions.Dermas["View Users"] = {1, ViewUserDerma}

-- Get current online users from server
local function fetchUserData() 
    factioneers = util.JSONToTable( net.ReadString() )
end
net.Receive( "CFC_Fac_SendPlayerInfo", fetchUserData )

-- Not sure which event this should occur on
local function requestUserData()
    net.Start( "CFC_Fac_RequestPlayerInfo" )
    net.SendToServer()
end
hook.Add( "InitPostEntity", "CFC_Fac_RequestUserData", requestUserData )


cfcFactions:RegisterDermaMenu( "View Users", ViewUserDerma, 1 )

function ViewUserDerma:Init()

end

function ViewUserDerma:Paint( w, h )

end

function ViewUserDerma:Think()

end

vgui.Register( 'D_factioneersderma', ViewUserDerma )

-- TODO: tie into the system - This may be completed by above code, ask V

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
