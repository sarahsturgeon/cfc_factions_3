--[[

File Name: sv_player_ext.lua

Purpose: Player table data that contain generic server-side only functions and not shared.

]]--

meta = FindMetaTable("Player")
local fpm = cfcFactions.fpm.Users

function meta:CFCToggleMenu()
    net.Start('CFC_Fac_ToggleDerma')
    net.Send(self)
end

--[[
TODO: rework a lot of this into sv_users.lua
]]--

--Checks to see if a player is currently in a faction. returns false if not in one.
function meta:IsInFaction()
    if self:IsMerc() then return false end

    local userHasFaction = self:GetFactionID() ~= nil

    return userHasFaction
end

--Obtains the player's faction id, or 0 if not. nil if invalid or not found.
function meta:GetFactionID()
    if not self:IsPlayer() then return end

    local steam64 = self:SteamID64()

    local playerFPM = fpm[steam64]

    if playerFPM then return playerFPM end
end

--Obtains the player's rank if in a faction. Returns nil otherwise.
function meta:GetFactionRank()
    if not self:IsInFaction() then return end

    local playerFPM = fpm[self:SteamID64()]
    local factionRank = playerFPM.FactionRank

    return factionRank
end

--Gets a player's faction as a table. Returns an empty table if not in one
function meta:GetFaction()
    if not self:IsInFaction() then return end

    local playerFactionID = self:GetFactionID()
    local playerFaction = cfcFactions.Factions[playerFactionID]

    local playerFactionIsInvalid = playerFaction == 0
    if playerFactionIsInvalid then return end

    return playerFaction
end

--Sets a player's faction based on given id. ply being who is doing the setting
function meta:SetFactionID(id)
    fpm.Users[self:SteamID64()].FactionID = id
end

function meta:SetFactionRank(rank)
    fpm.Users[self:SteamID64()].FactionRank = rank
end

function meta:IsMerc()
    return fpm[self:SteamID64()].IsMerc or false
end

-- function player:SetRank(rank)

-- end

-- function player:KickByID(id, ply)

-- end


-- function player:Ban(ply)

-- end
