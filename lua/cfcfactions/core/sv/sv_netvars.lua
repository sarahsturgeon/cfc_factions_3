--[[]
File Name: sv_netvars.lua

Purpose: Contains all NetworkedStrings registered on server start
]]--

local util = util
local NamedNetworkVars = {

    --Alerts/Msgs
    "CFC_Fac_SendTextAlert", "CFC_Fac_GetTextAlert", "CFC_Fac_SendServerTextAlert", "CFC_Fac_GetServerTextAlert",
    --Logs
    "CFC_Fac_RequesthLogs",
    "CFC_Fac_RequestAdminLogs",
    "CFC_Fac_RequestGlobalAdminLogs",
    "CFC_Fac_SendLogs",
    "CFC_Fac_SenddminLogs",
    "CFC_Fac_SendGlobalAdminLogs",
    --Checks for submitting faction
    "CFC_Fac_SendFactionSubmit",
    "CFC_Fac_RequestFactionSubmit",
    --News
    "CFC_Fac_SendNews",
    "CFC_Fac_RequestNews",
    --PlayerInfo/State
    "CFC_Fac_RequestPlayerInfo",
    "CFC_Fac_SentPlayerInfo",
    --Menu
    "CFC_Fac_ToggleDerma",
    "CFC_Fac_RequestNotifcation",
    "CFC_Fac_SendNotifcation"
}

--loop through and auto gens netvar names
for _, v in pairs(NamedNetworkVars) do
    util.AddNetworkString(v)
end



