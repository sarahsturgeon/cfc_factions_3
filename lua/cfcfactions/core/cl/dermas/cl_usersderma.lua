if not CLIENT then return end

local Panel = {}
--cfcFactions.Dermas["View Users"] = {1,Panel}

cfcFactions:RegisterDermaMenu("View Users", Panel, 1)

function Panel:Init()

end

function Panel:Paint(w, h)

end

function Panel:Think()

end

vgui.Register('D_cfcusersderma', Panel)

--TODO: tie into the system

local function fetchFactionUsers()
    
end

net.Receive("CFC_Fac_FetchUsers", fetchFactionUsers)

local function factionUserOffline()
    
end

net.Receive("CFC_Fac_UserOffline", factionUserOffline)

local function factionFetchOnline()
    
end

net.Receive("CFC_Fac_FetchOnline", factionFetchOnline)

local function factionUserChange()
    
end

net.Receive("CFC_Fac_UserChange", factionUserChange)

local function factionUserUpdateStats()
    
end

net.Receive("CFC_Fac_UserUpdateStats", factionUserUpdateStats)

local function factionUserDeleted()
    
end

net.Receive("CFC_Fac_UserDeleted", factionUserDeleted)
