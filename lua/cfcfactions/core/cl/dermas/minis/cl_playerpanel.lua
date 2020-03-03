local PANEL = {}

function PANEL:Init()
    self.Player = nil
    self.AvatarPicture = nil
    self.Status = nil
    self.Activity = nil
    self.Kills = 0
    self.Deaths = 0
    self.Rank = nil
    self.Faction = nil
    self.FactionID = 0
    self.FactionsAdmin = false
end

-- Whats my avatar again
function PANEL:SetAvatar( player )

end

-- Who are you people?!?
function PANEL:SetPlayer( player )

end

-- What are they doing?
function PANEL:SetPlayerActivity( activity )

end

-- Online? Offline?
function PANEL:SetPlayerStatus( status )

end

-- Moot
function PANEL:SetPlayerKills( kills )

end

-- Moot
function PANEL:SetPlayerDeaths( deaths )

end

-- My rank inside the faction, not my ulx rank
function PANEL:SetPlayerRank( faction_rank )

end

-- Whats my faction's name again
function PANEL:SetFactionName( faction_name )

end

-- Whats my faction's ID
function PANEL:SetFactionID( faction_id )

end

-- Can they ban me if I talk shit
function PANEL:SetFactionsAdmin( is_admin )

end