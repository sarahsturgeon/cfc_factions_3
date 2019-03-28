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

local function fetchUsers()
	
end

net.Receive("FetchUsers", fetchUsers)

local function userOffline()
	
end

net.Receive("UserOffline", userOffline)

local function fetchOnline()
	
end

net.Receive("FetchOnline", fetchOnline)

local function userChange()
	
end

net.Receive("UserChange", userChange)

local function userUpdateStats()
	
end

net.Receive("UserUpdateStats", userUpdateStats)

local function userDeleted()
	
end

net.Receive("UserDeleted", userDeleted)
