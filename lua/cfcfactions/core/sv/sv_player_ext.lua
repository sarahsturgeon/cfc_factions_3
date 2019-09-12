--[[]
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
    if self:IsMerc() == true then return true end
    
    local userHasFaction = self:GetFactionID() ~= nil
    return userHasFaction
end

--Obtains the player's faction id, or 0 if not. Bots always return 'b0t'
function meta:GetFactionID()
    if self:IsBot() then return "b0t" end
    if self:IsPlayer() then
        if self:IsInFaction() == false then
            return nil
        else 
            return fpm[self:SteamID64()].FactionID
        end
    end
end

--Obtains the player's rank if in a faction. Returns empty string if not
function meta:GetFactionRank()
    if self:IsInFaction() then 
        return fpm[self:SteamID64()].FactionRank 
    else
        return ""
    end
end

--Gets a player's faction as a table. Returns an empty table if not in one
function meta:GetFaction()
    if self:IsInFaction() then
        if cfcFactions.Factions[self:GetFactionID()] ~= 0 then
            return cfcFactions.Factions[self:GetFactionID()]
        end
    else
        return {}
    end
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
