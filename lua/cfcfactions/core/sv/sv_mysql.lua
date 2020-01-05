--[[
File Name: sv_mysql.lua

Purpose: Core functions that handle saving and loading from the mysql-db. Loads from serverside sv_config cfcFactions.Config.mysql_settings

]]--


require( 'mysqloo' )
local mysqloo = mysqloo
local string = string

local config = cfcFactions.Config.Server.MySQL

sql_db = mysqloo.connect( config.hostname, config.username, config.password, config.database )

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
function sql_db:initialize()
    MsgN( 'Initilizing SQL Database for ' .. cfcFactions.Config.NICE_NAME )
    local queries = {
        -- factions data
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
            ) ENGINE = InnoDB DEFAULT CHARSET = latin1
        ]],

        create_ranks_table = sql_db:query [[
            CREATE TABLE IF NOT EXISTS `cfcfactions_rank_data` (
                faction bigint NOT NULL,
                rank_name varchar( 100 ) NOT NULL,
                permissions JSON NOT NULL,
                UNIQUE KEY unique_rank_faction ( rank_name, faction ),
                FOREIGN KEY ( faction ) REFERENCES cfcfactions_data( faction_id )
                ON DELETE CASCADE
            )

        ]],
        -- factions users data
        create_users_table = sql_db:query [[
                CREATE TABLE IF NOT EXISTS `cfcusers_data` (
                    user_id bigint NOT NULL AUTO_INCREMENT,
                    steam_id64 varchar( 17 ) NOT NULL UNIQUE,
                    faction bigint,
                    faction_rank varchar( 32 ),
                    permissions JSON NOT NULL,
                    PRIMARY KEY( `user_id` ),
                    FOREIGN KEY ( faction ) REFERENCES cfcfactions_data( faction_id )
                    ON DELETE SET NULL
                ) ENGINE = InnoDB DEFAULT CHARSET = latin1
        ]],
        -- logs, typically related to administrative actions
        create_log_table = sql_db:query [[
                CREATE TABLE IF NOT EXISTS `cfcfactions_log` (
                    log_id int NOT NULL AUTO_INCREMENT,
                    user_id bigint NOT NULL,
                    faction_id bigint,
                    action varchar( 100 ) NOT NULL,
                    info JSON,
                    created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    PRIMARY KEY( `log_id` )
                ) ENGINE = InnoDB DEFAULT CHARSET = latin1
        ]],

    }

    for k, q in pairs( queries ) do
        function q:onSuccess( _ )
            MsgN( string.format( "cfcFactions query [%s] returned success.", k ) )
        end

        function q:onError( err, sql )
            MsgN( string.format( "CfcFactions MySQLOO: Query Failure: %s \n '%s' ", err, sql ) )
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

    for _, v in ipairs( args ) do
        local arg
        if type( v ) == "number" then
            arg = tostring( v )
        elseif type( v ) == "string" then
            arg = self:escape( v )
        elseif type( v ) == "boolean" then
            arg = v and "TRUE" or "FALSE"
        elseif type( v ) == "table" then
            local jsonData = util.TableToJSON( v, false )
            arg = self:escape( jsonData )
        else
            error( "Unsupported type: " .. type( v ) )
        end
        safeArgs[#safeArgs + 1] = arg
    end

    return string.format( query, unpack( safeArgs ) )
end

local function defaultErrorCallback( self, err, sql )
    print( "Query failed with err: " .. err )
end

local function defaultSuccessCallback( self, data )
    print( "Query succeeded" )
end

function sql_db:doQuery( queryString, callback, errorCallback )
    print( queryString )
    local query = sql_db:query( queryString )

    query.onError = errorCallback or defaultErrorCallback

    query.onSuccess = callback or defaultSuccessCallback
    query:start()
end

--------------------------------------------------------------------------------------------------------------
-- factions_data functions
--------------------------------------------------------------------------------------------------------------
-- creates a new faction with name:string, description:string, color:int, invite:bool, owner:int
function sql_db:createFaction( factionData, onSuccess, onError )
    local q = [[
    INSERT INTO cfcfactions_data
    ( name, description, color, invite, owner )
    VALUES ( '%s', '%s', %s, %s, %s );
    ]]
    q = sql_db:escapeQueryArgs(
        q,
        factionData.name,
        factionData.description,
        factionData.color,
        factionData.invite,
        factionData.owner
    )
    sql_db:doQuery( q, onSuccess, onError )
end

-- updates a faction with name:string, description:string, color:int, invite:bool, id:int
function sql_db:updateFaction( factionData, onSuccess, onError )
    local q = [[
    UPDATE cfcfactions_data SET
        name = '%s',
        description = '%s',
        color = %s,
        invite = %s,
        edited = CURRENT_TIMESTAMP
    WHERE faction_id = %s;
    ]]

    q = sql_db:escapeQueryArgs(
        q,
        factionData.name,
        factionData.description,
        factionData.color,
        factionData.invite,
        factionData.id
    )

    sql_db:doQuery( q, onSuccess, onError )
end

function sql_db:getFaction( id, onSuccess, onError )
    local q = [[
    SELECT * FROM cfcfactions_data WHERE faction_id = %s;
    ]]
    q = sql_db:escapeQueryArgs( q, id, onSuccess, onError )
    sql_db:doQuery( q )
end

-- returns <amount> factions from database starting at start
function sql_db:getFactions( start, amount, onSuccess, onError )
    local q = [[
    SELECT * FROM cfcfactions_data LIMIT %s, %s;
    ]]
    q = sql_db:escapeQueryArgs( q, start, amount )
    sql_db:doQuery( q, onSuccess, onError )
end


function sql_db:removeFaction( id, onSuccess, onError )
    local q = "DELETE FROM cfcfactions_data WHERE faction_id = %s;"
    q = sql_db:escapeQueryArgs( q, id )

    sql_db:doQuery( q, onSuccess, onError )
end

-- gets all the ranks in a faction
function sql_db:getRanks( factionId, onSuccess, onError )
    local q = "SELECT * FROM cfcfactions_data WHERE faction = %s;"
    q = sql_db:escapeQueryArgs( q, factionId )

    sql_db:doQuery( q, onSuccess, onError )
end

-- gets a users permissions in their current faction
function sql_db:getUserFactionPermissions( userId, onSuccess, onError )
    local q = [[
        SELECT ranks.permissions FROM
        cfcfactions_rank_data ranks, cfcusers_data users WHERE
        users.user_id = %s AND
        ranks.rank_name = users.faction_rank AND
        ranks.faction = users.faction;
    ]]
    q = sql_db:escapeQueryArgs( q, userId )
    sql_db:doQuery( q, onSuccess, onError )
end
----------------------------------------------------------------------------------------------------------
-- user_data functions
--------------------------------------------------------------------------------------------------------------
function sql_db:createUser( steamId, onSuccess, onError )
    local q = [[
    INSERT IGNORE INTO cfcusers_data
    ( steam_id64 )
    VALUES ( '%s' );
    ]]
    q = sql_db:escapeQueryArgs( q, steamId )
    sql_db:doQuery( q, onSuccess, onError )
end

-- updates a user with faction:int, faction_rank:string, id:int
function sql_db:updateUser( userData, onSuccess, onError )
    local q =  [[
    UPDATE cfcusers_data SET
        faction = %s,
        faction_rank = '%s'
    WHERE user_id = %s;
    ]]
    q = sql_db:escapeQueryArgs(
        q,
        userData.faction,
        userData.faction_rank,
        userData.id
    )
    sql_db:doQuery( q, onSuccess, onError )
end

function sql_db:getUser( userId, onSuccess, onError )
    local q = [[
    SELECT * FROM cfcusers_data WHERE user_id = %s;
    ]]
    q = sql_db:escapeQueryArgs( q, userId )
    sql_db:doQuery( q, onSuccess, onError )
end

function sql_db:getUserFromSteamID( steamId, onSuccess, onError )
    local q = [[
    SELECT * FROM cfcusers_data WHERE steam_id64 = '%s';
    ]]
    q = sql_db:escapeQueryArgs( q, steamId )
    sql_db:doQuery( q, onSuccess, onError )
end

-- returns <amount> users from database starting at start
function sql_db:getUsers( start, amount, onSuccess, onError )
    local q = [[
    SELECT * FROM cfcusers_data LIMIT %s, %s;
    ]]
    q = sql_db:escapeQueryArgs( q, start, amount )
    sql_db:doQuery( q, onSuccess, onError )
end

---------------------------------------------------------------------------------------------------------------------
-- logs
---------------------------------------------------------------------------------------------------------------------
-- creates a new log with user_id:int, faction_id:int, action:string, info:table
function sql_db:createLog( logData, onSuccess, onError )
    local q = [[
    INSERT INTO cfcfactions_log
        ( user_id, faction_id, action, info )
        VALUES ( %s, %s, '%s', '%s' );
    ]]
    q = sql_db:escapeQueryArgs(
        q,
        logData.user_id,
        logData.faction_id,
        logData.action,
        logData.info
    )
    sql_db:doQuery( q, onSuccess, onError )
end

-- returns <amount> logs from database starting at start
function sql_db:getLogs( start, amount, onSuccess, onError )
    local q = [[
    SELECT * FROM cfcfactions_log LIMIT %s, %s;
    ]]
    q = sql_db:escapeQueryArgs( q, start, amount )
    sql_db:doQuery( q, onSuccess, onError )
end
