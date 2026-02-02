--[[
File Name: sv_player_ext.lua

Purpose: Player table data that contain generic server-side only functions and not shared.
Note: Many of these functions need to be rewritten under sv_users.lua and then
adjusted here to use it. We should still be able to access player:IsInFaction for example,
but it will instead just be a 'shortcut' to sv_user.lua 's IsInFaction'

]]--

meta = FindMetaTable( "Player" )
local fpm = cfcFactions.fpm

-- TODO: Should probably have some kind of internal cooldown just to be safe
function meta:CFCToggleMenu()
    if not fpm:HasPermission( self, "AccessAll" ) then
        return cfcFactions:SendNotifcation( "factions-ban", mtype, player )
    end

    net.Start( "CFC_Fac_ToggleDerma" )
    net.Send( self )
end

--[[
    TODO: rework a lot of this into fetching from sv_users.lua
]]--

-- Checks to see if a player is currently in a faction. returns false if not in one.
function meta:IsInFaction()

    local userHasFaction = self:GetFactionID() ~= nil

    return userHasFaction
end

-- Obtains the player's faction id, or 0 if not. Bots always return 'b0t'
function meta:GetFactionID()
    if self:IsBot() then return "b0t" end

    if not self:IsPlayer() then return end

    return fpm[self:SteamID64()]
end

-- Obtains the player's rank if in a faction. Returns empty string if not
function meta:GetFactionRank()
    if not self:IsInFaction() then return "" end

    return fpm[self:SteamID64()].FactionRank
end

-- Gets a player's faction as a table. Returns an empty table if not in one
-- TODO: Make these return values consistent
function meta:GetFaction()
    if not self:IsPlayer() then return false end

    if not self:IsInFaction() then
        return false
    end

    local faction = cfcFactions.Factions[self:GetFactionID()]

    if faction == 0 then return end

    return faction
end

-- Sets a player's faction based on given id. ply being who is doing the setting
function meta:SetFactionID( id )
    fpm.Users[self:SteamID64()].FactionID = id
end

function meta:SetFactionRank( rank )
    fpm.Users[self:SteamID64()].FactionRank = rank
end
