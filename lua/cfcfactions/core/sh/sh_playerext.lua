-- [[]
File Name: sh_playerext.lua

Purpose: Player table data that contain generic server-side OR client-side only functions.

]]--

-- player = FindMetaTable( "Player" )

-- function player:IsInFaction()
--  if self:GetFactionID() == 0 then return false else return true end
-- end
-- function player:GetFactionID()
--  if self:IsBot() then return "b0t" end
--  if self:IsPlayer() then
--      local id = cfcFactions.Users[self:SteamID64()].FactionID
--      if id == nil then return 0 else return id end
--  end
-- end

-- function player:GetFactionRank()
--  if self:IsInFaction() then return cfcFactions.Users[self:SteamID64()].FactionRank end
-- end

-- function player:GetFaction()
--  if self:IsInFaction() then
--      return cfcFactions.Factions[self:GetFactionID()]
--  end
-- end

-- function player:GetRank()

-- end


-- function player:SetFaction( id )


-- end
-- function player:SetRank( rank )

-- end
