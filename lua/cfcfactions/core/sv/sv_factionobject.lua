--[[
File Name: sv_factionobj.lua

Purpose: Core faction's functions to create, edit, and destory faction specific objects. 
Faction being a object

]]--
if not SERVER then return end

local fpm = cfcFactions.fpm
local cfg = cfcFactions.Config.Server
--local factioneers = cfcFactions.Users

local Faction = {}

local function AssignFactionID()
    --todo, call sql to get the last avaiable id to assign to this faction
end
--Takes a string to check, and a number to limit the string to and returns a EDITED string for less than the max number given
local function TrimStringSize( str, max )
    local TemporaryString = str
    local MaxCharTrim = max and max > 0 or 32
    
    return #TemporaryString > MaxCharTrim and string.Trim( str ).sub( 1, MaxCharTrim ) or str
    return TemporaryString
end
--Arguments: id:number, owner:ply, name:string, color:table, description:string, private:boolean, markForDeletion:boolean
--Purpose: Create a faction with specific parameters. id, owner, name are atleast needed
function Faction:Create( id, owner, name, color, description, private, temporary, markForDeletion )
    self:Init()
    self:SetID( id )
    self:SetOwner( owner )
    self:EditName( name )
    self:EditColor( color )
    self:EditDescription( description )
    self:SetMarkForDeletion( markForDeletion )
    self:SetPrivateFaction( private )
end
--Arguments: none
--Purpose: Inits a faction to be used
function Faction:Init()
    self.__Index = self
    
    local CurrentTimeStamp = cfcFactions:TimeStamp()

    --Core Stuff
    self.ID = 0
    self.Name = ""
    self.Color = Color( 255, 255, 255, 255 )
    self.Created = CurrentTimeStamp
    self.Edited = self.Created
    self.Description = ""
    self.LastSaved = 0
    self.PrivateFaction = true
    self.Owner = ""
    self.Ranks = {}
    self.MarkFactionForDeletion = true -- Alias of IsTemporary

    --Extras
    self.Allies = {}
    self.Enemies = {}
    self.Currency = 0
    self.Deaths = 0
    self.Kills = 0
end
--Arguments: id:number
--Purpose: Change a faction's ID
function Faction:SetID( id )
    --TODO there should probably be a precaution to prevent creating 2 factions of same ID
    self.ID = id
end
--Arguments: ply:Player
--Purpose: Change a faction's owner
function Faction:SetOwner( ply )
    if not IsValid( ply ) then return nil end
    if type( ply ) == "String" then
        --TODO If a string ( SteamID, SteamID64, Uniq ID ) is provided, convert into a player object
    elseif type( ply ) == "Player" then
        self.Owner = ply 
    end
end

--Arguments: name:string
--Purpose: Change a faction's name
function Faction:SetName( name )
    self.Name = TrimStringSize( name, 32 )
end
--Arguments: color:color
--Purpose: Change a faction's color
function Faction:SetColor( color )
    self.Color = color
end
--Arguments: datetime:string
--Purpose: Change a faction's creation date
function Faction:SetEditedDate( datetime )
    self.Created = datetime
end
--Arguments: datetime:string
--Purpose: Change a faction's edited date
function Faction:SetEditedDate( datetime )
    self.Edited = datetime
end
--Arguments: desc:string
--Purpose: Change a faction's description
function Faction:SetDescription( desc )
    self.Description = MaxCharTrim( desc, 255 )
end
--Arguments: datetime:string
--Purpose: Change a faction's last saved date
function Faction:SetLastSavedDate( datetime )
    self.LastSaved = datetime
end
--Arguments: group:string, perms:table
--Purpose: Add a new rank to the faction with a table of perms. If the group exists, return false else true
function Faction:AddRank( group, perms )
    if group == nil or perms == nil then return false end
    if self.Ranks[group] == nil then
        self.Ranks[group] = perms
        return true
    else
        return false
    end
end
--Arguments: boolean:bool
--Purpose: Set whether the faction should be private or not
function Faction:SetPrivateFaction( boolean )
    self.PrivateFaction = boolean
end
--Arguments: boolean:bool
--Purpose: Set whether the faction should be marked for deletion or not
function Faction:SetMarkForDeletion( boolean )
    self.MarkFactionForDeletion = boolean
end
--Arguments: id:number, status:string, reason:string
--Purpose: Set whether the faction should be marked for deletion or not
function cfcFactions:SetRelationship( id, status, reason )
    if self.Allies[id] ~= nil then
        self.Allies[id].status = status
        self.Allies[id].reason = MaxCharTrim( reason, 255 )
    elseif self.Enemies[id] ~= nil then

    else

    end
end
--Arguments: string
--Purpose: Change a faction's name
function Faction:SetAllies( )

end
--Arguments: string
--Purpose: Change a faction's name
function Faction:SetEnemies( )

end
--Arguments: string
--Purpose: Change a faction's name
function Faction:SetCurrency( )

end
--Arguments: string
--Purpose: Change a faction's name
function Faction:SetDeaths( )

end
--Arguments: string
--Purpose: Change a faction's name
function Faction:SetKills( )

end
--Arguments: string
--Purpose: Change a faction's name
function Faction:ToggleMarkForDeletion()
    self.MarkFactionForDeletion = !self.MarkFactionForDeletion
    return self.MarkFactionForDeletion
end