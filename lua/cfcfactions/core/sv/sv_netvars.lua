--[[]
File Name: sv_netvars.lua

Purpose: Contains all NetworkedStrings registered on server start
]]--

local util = util
local NamedNetworkVars = {

    --Alerts/Msgs
    "CFC_Fac_SendTextAlert", 
    "CFC_Fac_GetTextAlert", 
    "CFC_Fac_SendServerTextAlert", 
    "CFC_Fac_GetServerTextAlert",
    --Notifications
    "CFC_Fac_NewFactionCreated",
    "CFC_Fac_FactionDeleted",
    "CFC_Fac_FactionChanged",
    "CFC_Fac_MemberJoined",
    "CFC_Fac_MemberLeft",
    "CFC_Fac_PermissionChanged",
    --Checks for submitting faction
    "CFC_Fac_SendFactionSubmit",
    "CFC_Fac_RequestFactionSubmit",
    --Editing
    "CFC_Fac_SendFactionEdit",
    "CFC_Fac_RequestFactionEdit",
    --News
    "CFC_Fac_SendNews",
    "CFC_Fac_RequestNews",
    --PlayerInfo/State
    "CFC_Fac_RequestPlayerInfo",
    "CFC_Fac_SendPlayerInfo",
    --Menu
    "CFC_Fac_ToggleDerma",
    "CFC_Fac_RequestNotifcation",
    "CFC_Fac_SendNotifcation",
    --FactionDeletion
    "CFC_Fac_RequestFactionRemoval",
    --UserLeaving
    "CFC_Fac_FactionUserRemoval",
    --FactionsRefresh
    "CFC_Fac_FactionRefresh"
}

--loop through and auto gens netvar names
for _, v in pairs( NamedNetworkVars ) do
    util.AddNetworkString( v )
end



