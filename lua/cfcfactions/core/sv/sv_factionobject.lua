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
    if #str == 0 then return "" end
    local TemporaryString = str
    local MaxCharTrim = max and max > 0 or 32
    
    return #TemporaryString > MaxCharTrim and string.Trim( str ).sub( 1, MaxCharTrim ) or str
end
--Arguments: id:number, owner:ply, name:string, color:table, description:string, private:boolean, markForDeletion:boolean
--Purpose: Create a faction with specific parameters. id, owner, name are atleast needed
function Faction:Create( id, owner, name, color, description, private, markForDeletion )
    self:Init()
    self:SetID( id )
    self:SetOwner( owner )
    self:EditName( name )
    self:EditColor( color )
    self:EditDescription( description )
    self:SetMarkForDeletion( markForDeletion )
    self:SetPrivateFaction( private )
    self:SetFactionSave( true )
    return self
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
    self.MarkFactionForSave = false
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
function Faction:GetID()
    return self.ID
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
function Faction:GetOwner()
    return self.Owner
end
--Arguments: name:string
--Purpose: Change a faction's name
function Faction:SetName( name )
    self.Name = TrimStringSize( name, 32 )
    self:SetFactionSave( true )
end
function Faction:GetName()
    return self.Name
end
--Arguments: color:color
--Purpose: Change a faction's color
function Faction:SetColor( color )
    self.Color = color
    self:SetFactionSave( true )
end
function Faction:GetColor()
    return self.Color
end
--Arguments: datetime:string
--Purpose: Change a faction's creation date
function Faction:SetCreatedDate( datetime )
    self.Created = datetime
    self:SetFactionSave( true )
end
function Faction:GetCreationDate()
    return self.Created
end
--Arguments: datetime:string
--Purpose: Change a faction's edited date
function Faction:SetEditedDate( datetime )
    self.Edited = datetime
    self:SetFactionSave( true )
end
function Faction:GetEditedDate()
    return self.Edited
end
--Arguments: desc:string
--Purpose: Change a faction's description
function Faction:SetDescription( desc )
    self.Description = MaxCharTrim( desc, 255 )
    self:SetFactionSave( true )
end
function Faction:GetDescription()
    return self.Description
end
--Arguments: datetime:string
--Purpose: Change a faction's last saved date
function Faction:SetLastSavedDate( datetime )
    self.LastSaved = datetime
    self:SetFactionSave( true )
end
function Faction:GetLastSavedDate()
    return self.LastSaved
end
--Arguments: group:string, perms:table
--Purpose: Add a new rank to the faction with a table of perms. If the group exists, return false else true
function Faction:AddRank( group, perms )
    if group == nil or perms == nil then return false end
    if self.Ranks[group] == nil then
        self.Ranks[group] = perms
        self:SetFactionSave( true )
        return true
    else
        return false
    end
end
function Faction:GetRanks()
    return self.Ranks
end
function Faction:GetRank( group )
    return self.Ranks[group]
end
--Arguments: boolean:bool
--Purpose: Set whether the faction should be private or not
function Faction:SetPrivateFaction( boolean )
    self.PrivateFaction = boolean
    self:SetFactionSave( true )
end
function Faction:GetPrivate()
    return self.PrivateFaction
end
--Arguments: boolean:bool
--Purpose: Set whether the faction should be marked for deletion or not
function Faction:SetMarkForDeletion( boolean )
    self.MarkFactionForDeletion = boolean
    self:SetFactionSave( true )
end
function Faction:GetMarkedDeletion()
    return self.MarkFactionForDeletion
end
--Arguments: id:number, status:string, reason:string
--Purpose: Set a relationship to another faction
function Faction:SetRelationship( id, status, reason )
    if id == nil then return false end

    if status == "ENEMY" then
        self.Enemies[id] = {
            ["status"] = "ENEMY",
            ["reason"] = MaxCharTrim( reason, 255 )
        }
        self.Allies[id] = nil
        self:SetFactionSave( true )
        return true
    elseif status == "ALLY" then
        self.Allies[id] = {
            ["status"] = "ALLY",
            ["reason"] = MaxCharTrim( reason, 255 )
        }
         self.Enemies[id] = nil
         self:SetFactionSave( true )
        return true
    else
        return false
    end

    end
end
function Faction:GetRelationship( id )
    return self.Allies[id] ~= nil or self.Enemies[id] ~= nil or false
end
--Arguments: boolean:bool
--Purpose: Sets a faction to be saved to database
function Faction:SetFactionSave( boolean )
    self.MarkFactionForSave = boolean
    self:SetFactionSave( true )
end
function Faction:GetFactionSave()
    return self.MarkFactionForSave
end
--Arguments: id:number, reason:string
--Purpose: Set an ally of the faction
function Faction:SetAlly( id, reason )
    self:SetRelationship( id, "ALLY", reason )
end
function Faction:GetAllies()
    return self.Allies
end
--Arguments: id:number, reason:string
--Purpose: Set an enemy of the faction
function Faction:SetEnemy( id, reason )
    self:SetRelationship( id, "ENEMY", reason )
end
function Faction:GetEnemies()
    return self.Enemies
end
--Arguments: currencyName:string, currencyValue:number
--Purpose: Set a faction's currency. They can name their own currency
function Faction:SetCurrency( currencyName, currencyValue )
    if currencyName == nil then
        currencyName = "Points"
    end
    if currencyValue < 0 then 
        currencyValue = 0
    end
    self.Currency = {
        ["CurrencyName"] = MaxCharTrim( currencyName, 25 ),
        ["CurrencyValue"] = currencyValue and currencyValue > 0 or 0
    }
    self:SetFactionSave( true )
end
--Arguments: value:number
--Purpose: Increments the faction's currency by a numbered amount
function Faction:IncrementCurrency( value )
    self.Currency.CurrencyValue = self.Currency.CurrencyValue + value
    self:MarkFactionForSave( true )
end
function Faction:GetCurrency()
    return self.Currency
end
function Faction:GetCurrencyAmount()
    return self.Currency.CurrencyValue
end
function Faction:GetCurrencyName()
    return self.Currency.CurrencyName
end
--Arguments: deaths:number
--Purpose: Set a faction's deaths
function Faction:SetDeaths( deaths )
    self.Deaths = deaths
    self:SetFactionSave( true )
end
--Arguments: kills:number
--Purpose: Set a faction's kills
function Faction:SetKills( kills )
    self.kills = kills
    self:SetFactionSave( true )
end

function Faction:AddDeath( )
    self.Deaths = self.Deaths + 1
    self:SetFactionSave( true )
end
function Faction:GetDeaths()
    return self.Deaths
end
function Faction:AddKill( )
    self.Kills = self.Kills + 1
    self:SetFactionSave( true )
end
function Faction:GetKills()
    return self.Kills
end

--Arguments: string
--Purpose: Change a faction's name
function Faction:ToggleMarkForDeletion()
    self:SetMarkForDeletion( !self.MarkFactionForDeletion )
    return self.MarkFactionForDeletion
end

function Faction:ToJSON()
    return util.TableToJSON( self, true ) 
end