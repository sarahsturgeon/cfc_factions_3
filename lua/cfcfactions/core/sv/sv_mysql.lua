--[[
File Name: sv_mysql.lua

Purpose: Core functions that handle saving and loading from the mysql-db. Loads from serverside sv_config cfcFactions.Config.mysql_settings

]]--

require( 'mysqloo' )
local mysqloo = mysqloo
local table = table
local string = string

-- TODO: changed config structure
local config = cfcFactions.Config.Server.MySQL


sql_db = mysqloo.connect( "localhost", "factions_dev", "factions", "factions" )

function sql_db:onConnected()
    MsgN( 'CFCFactions - MySql Successfully connected' )
end

function sql_db:onConnectionFailed( error )
    MsgN( 'CFCFactions MySQL: An error occured when connecting. Check local settings: ' .. error )
end
sql_db:connect()

--------------------------------------------------------------------------------------------------------------
-- Core Init
--------------------------------------------------------------------------------------------------------------

--init the db and all queries revovling around creation of tables
function sql_db:initialize()
    --Databases being used for cfcfactions
    --cfcfactions_data  - contains the factions data ( id, json )
    --cfcusers_data - contains users data ( id, factionid, rank, extra )
    --cfcadminlog - contains all administrative transactions

    MsgN( 'Initilizing SQL Database for ' .. cfcFactions.Config.NICE_NAME )
    local queries = {
        -- table to store all factions
        create_factions_table = sql_db:query [[
            CREATE TABLE IF NOT EXISTS `cfcfactions_data` (

                 faction_id bigint NOT NULL AUTO_INCREMENT,
                 name varchar( 32 ) NOT NULL UNIQUE,
                 description varchar( 300 ) NOT NULL,
                 color int NOT NULL,
                 invite bool NOT NULL,
                 owner bigint NOT NULL UNIQUE,
                 created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                 edited timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                 PRIMARY KEY ( `faction_id` )

            ) ENGINE=InnoDB DEFAULT CHARSET=latin1
        ]],

        create_users_table = sql_db:query [[
                CREATE TABLE IF NOT EXISTS `cfcusers_data` (
                    user_id bigint NOT NULL AUTO_INCREMENT,
                    steam_id64 varchar(17) NOT NULL UNIQUE,
                    faction bigint,
                    faction_rank varchar( 32 ),
                    permissions text NOT NULL,
                    PRIMARY KEY( `user_id` ),
                    FOREIGN KEY (faction) REFERENCES cfcfactions_data(faction_id)
                    ON DELETE SET NULL
                ) ENGINE=InnoDB DEFAULT CHARSET=latin1
        ]],

        create_log_table = sql_db:query [[
                CREATE TABLE IF NOT EXISTS `cfcfactions_log` (
                    log_id int NOT NULL AUTO_INCREMENT,
                    player_id bigint NOT NULL,
                    faction_id bigint NOT NULL,
                    action varchar(300) NOT NULL,
                    created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    PRIMARY KEY( `log_id` )
                ) ENGINE=InnoDB DEFAULT CHARSET=latin1
        ]],
    }

    for k, q in pairs( queries ) do
        function q:onSuccess( _ )
            MsgN( string.format( "cfcFactions query [%s] returned success.", k ) )
        end

        function q:onError( err, sql )
            if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
                sql_db:connect()
                sql_db:wait()
            if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
                ErrorNoHalt( "Re-connection to database server failed." )
                return
                end
            end
            MsgN( 'CfcFactions MySQLOO: Query Failure: ' .. err .. ' [' .. sql .. ']' )
            MsgN( "When attempting query " )
            MsgN( q )
        end

        q:start()
    end
end
sql_db:initialize()

-- Helper functions
function sql_db:escapeQueryArgs( query, ... )
    local args = {...}
    local safeArgs = {}

    for _, v in ipairs(args) do
        local arg
        if type(v) == "number" then
            arg = tostring(v)
        elseif type(v) == "string" then
            arg = self:escape(v)
        elseif type(v) == "boolean" then
            arg = v and "TRUE" or "FALSE" 
        else
            error("Unsupported type: "..type(v))
        end
        safeArgs[#safeArgs+1] = arg
    end

    return string.format(query, unpack(safeArgs))
end

local function defaultErrorCallback(self, err, sql)
    print(err)
    print(sql)
end

local function defaultSuccessCallback(self, data)
    PrintTable(data)
end

function sql_db:doQuery(queryString, callback, errorCallback)
    local query = sql_db:query( queryString )

    query.onError = errorCallback or defaultErrorCallback

    query.onSuccess = callback or defaultSuccessCallback
    query:start()
end
--------------------------------------------------------------------------------------------------------------
-- General Fetching
--------------------------------------------------------------------------------------------------------------

-- just removed the count functions for now

--------------------------------------------------------------------------------------------------------------
--factions_data functions
--------------------------------------------------------------------------------------------------------------

-- creates a new faction
function sql_db:createFaction( faction_data )
    local q = [[
    INSERT INTO cfcfactions_data 
    (name, description, color, invite, owner)
    VALUES ( '%s', '%s', %s, %s, %s);
    ]]
    q = sql_db:escapeQueryArgs(
        q, 
        faction_data.name,
        faction_data.description,
        faction_data.color,
        faction_data.invite,
        faction_data.owner
    )
    sql_db:doQuery( q )
end


-- updates an existing faction
function sql_db:updateFaction( faction_data )
    local q = [[
    UPDATE cfcfactions_data SET 
        name = '%s',
        description = '%s',
        color = %s,
        invite = %s,
        edited=CURRENT_TIMESTAMP
    WHERE faction_id = %s
    ]]
    q = sql_db:escapeQueryArgs(
        q,
        faction_data.name,
        faction_data.description,
        faction_data.color,
        faction_data.invite,
        faction_data.id
    )

    sql_db:doQuery( q )
end

-- returns a single faction with the given id
function sql_db:getFaction( id )
    local q = [[
    SELECT * FROM cfcfactions_data WHERE faction_id = %s;
    ]]
    q = sql_db:escapeQueryArgs(q, id)
    sql_db:doQuery(q)
end

-- deletes a faction
function sql_db:removeFaction( id )
    local q = "DELETE FROM cfcfactions_data WHERE faction_id = %s;"
    q = sql_db:escapeQueryArgs(q, id)

    sql_db:doQuery( q )
end

function sql_db:loadFactions()
end

--  testing stuff
timer.Simple(5, function()

    sql_db:createFaction{
        name = "Some random faction",
        description = "test",
        color = 0xFF00FF,
        invite = false,
        owner = 23
    }

    sql_db:updateFaction{
        id=24,
        name="test_faction",
        description = "a new description",
        color = 0xFF0000,
        invite = false
    }

    sql_db:getFaction(24)


end)


----------------------------------------------------------------------------------------------------------
--user_data functions
--------------------------------------------------------------------------------------------------------------
-- creates a new user in the database returning the id
function sql_db:createUser( steam_id )
    local qs = [[
        INSERT IGNORE INTO cfcusers_data
        (steam_id64, permissions)
        VALUES ('%s', '%s');
        SELECT LAST_INSERT_ID();
    ]]
end

function sql_db:updateUser( user_id, rank )
    local qs =  [[
    UPDATE cfcusers_data SET 
        faction_id = %s
        faction_rank = '%s'
    WHERE user_id=1;
    ]]
end

function sql_db:getUser( user_id )
    local qs = [[
    SELECT * FROM cfcusers_data WHERE user_id = %s;
    ]]
end

function sql_db:getUserFromSteamID( steam_id )
    local qs = [[
    SELECT * FROM cfcusers_data WHERE steam_id64 = '%s';
    ]]
end