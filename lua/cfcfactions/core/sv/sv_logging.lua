--[[]
File Name: sv_logging.lua

Purpose: Logging functions to show when events happen and variables
change that are important to the end user. Differs from notifcations since these
are mostly back end things such as factions created, edited ( Name, descriptions, etc ), users
join or leave but are never shown to the user. ( While a notifcation ) can affect the same
things and display to the user. Logging is simply a way to keep track of everything.

Global Tables: cfcFactions.Logs
]]--

cfcFactions.Logs = cfcFactions or {}
cfcFactions.LogTypes = {
    MESSAGE = "MESSAGE",
    ERROR = "ERROR",
    WARNING = "WARNING",
    DEBUG = "DEBUG",
}

--parses and correctly displays a log from arg:table into proper format, returns a table
local function safeLog( log, msg, type, args, parse, sve, time )
--[[
    --Internal structure of what is passed into a logging session
    Table = {
        Msg = "",
        Type = ERROR_TYPE,
        Args = {},
        ShouldParse = true, --Parse args into the msg if possible
        SaveDB = true, --Save to database?
        Time = os.time(),
        Checked = nil, --Allows us to check if this table has been sanitized before.
    }
]]--
    local t = cfcFactions.LogTypes
    local tmpLogTable = {}
    if type( log ) == "table" then
        if log[Checked] == nil then
            log[Checked] = true
        else
            return log
        end

        if log[Msg] == nil then
            log[Msg] = "Undefined Message was thrown"
        end

        if log[Type] == nil then
            log[Type] == t.DEBUG
        end

        if log[Args] == nil then
            log[Args] = {}
        end

        if log[ShouldParse] == nil then
            log[ShouldParse] = false
        end

        if log[SaveDB] == nil then
            log[SaveDB] = true
        end

        if log[Time] == nil then
            log[Time] = cfcFactions:TimeStamp()
        end

        --if not a table, we'll need to properly form a table for the string to be recorded.
    elseif type( log ) == "string" then

    end
    
    return tmpLogTable
end


--main function to transcribe a log based on a table of data
function cfcFactions:TransLog( table )
    if type( table ) ~= table then
        if type( table ) == "string" then

        end
    end
end

--quick function to log errors
function cfcFactions:ErrorLog( msg, args )

end

--quick function to log debugging items
function cfcFactions:DebugLog( msg, args )

end

--quick function to log messages
function cfcFactions:MessageLog( msg, args )

end

--quick function to log virtually anything
function cfcFactions:Log( msg, args )

end