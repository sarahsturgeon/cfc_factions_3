--[[]
File Name: sv_mysql.lua

Purpose: Core functions that handle saving and loading from the mysql-db. Loads from serverside sv_config cfcFactions.Config.mysql_settings

]]--

require( 'mysqloo' )
local mysqloo = mysqloo
local table = table
local string = string

--TODO: changed config structure
local config = cfcFactions.Config.Server.MySQL

sql_db = mysqloo.connect( config.sql_hostname, 
    config.sql_username, config.sql_password, 
    config.sql_database, config.sql_port )

function sql_db:onConnected()
    MsgN( 'CFCFactions - MySql Successfully connected' )
end

function sql_db:onConnectionFailed( error )
    MsgN( 'CFCFactions MySQL: An error occured when connecting. Check local settings: ' .. error )
end

--sql_db:connect()

--------------------------------------------------------------------------------------------------------------
--Core Init
--------------------------------------------------------------------------------------------------------------

--init the db and all queries revovling around creation of tables
function sql_db:initilize()
    --Databases being used for cfcfactions
    --cfcfactions_data  - contains the factions data ( id, json )
    --cfcusers_data - contains users data ( id, factionid, rank, extra )
    --cfcadminlog - contains all administrative transactions

    MsgN( 'Initilizing SQL Database for ' .. cfcFactions.Config.NICE_NAME )
    local queries = {
        --Table to store factions ( string , json ) [id, factiondata]
        q1 = sql_db:query( [[
            CREATE TABLE IF NOT EXISTS `cfcfactions_data` (

                 uniqueid int NOT NULL,
                 name varchar( 32 ) NOT NULL UNIQUE,
                 description varchar( 300 ) NOT NULL,
                 color varchar( 56 ) NOT NULL,
                 invite bool NOT NULL,
                 owner varchar( 32 ) NOT NULL,
                 created varchar( 32 ) NOT NULL,
                 edited varchar( 32 ) NOT NULL,
                 PRIMARY KEY ( `uniqueid` )


            ) ENGINE=InnoDB DEFAULT CHARSET=latin1
        ]] ),

        --Table to store all userdata ( playerid64:string, factionid:string, rank:string, extras:json, kills:number, deaths:number )
        q2 = sql_db:query( [[
                CREATE TABLE IF NOT EXISTS cfcusers_data (
                    playerid varchar( 32 ) NOT NULL,
                    factionid varchar( 32 ) NOT NULL,
                    factionrank varchar( 32 ) NOT NULL,
                    permissions text NOT NULL,
                    flags text,
                    PRIMARY KEY( `playerid` )

                ) ENGINE=InnoDB DEFAULT CHARSET=latin1
            ]] ),

        --Table to log all administrative actions IE: changing name, deleting faction, deleting user
        -- ( playerid:string, factionid:string, setting:string, state:string, time:string )
        --State = {DELETED, MODIFIED, NEW}

        q3 = sql_db:query( [[
                CREATE TABLE IF NOT EXISTS `cfcadminlog` (
                    id int NOT NULL AUTO_INCREMENT,
                    playerid varchar( 32 ) NOT NULL,
                    factionid varchar( 32 ) NOT NULL,
                    setting varchar( 255 ) NOT NULL,
                    state varchar( 32 ) NOT NULL,
                    time varchar( 32 ) NOT NULL,
                    PRIMARY KEY( id )

                ) ENGINE=InnoDB DEFAULT CHARSET=latin1
            ]] ),

        q4 = sql_db:query( [[
                CREATE TABLE IF NOT EXISTS `cfcpermissions` (
                    id int NOT NULL AUTO_INCREMENT,
                    permission NOT NULL,
                    PRIMARY KEY( id )
                ) ENGINE=InnoDB DEFAULT CHARSET=latin1

            ]] ),

        q5 = sql_db:query( [[
                CREATE TABLE IF NOT EXISTS `cfcfactionstats` (
                    id int NOT NULL AUTO_INCREMENT,
                    kills int,
                    deaths int,
                    points int
                )ENGINE=InnoDB DEFAULT CHARSET=latin1
            ]] ),

        q6 = sql_db:query( [[
                CREATE TABLE IF NOT EXISTS `cfcplayerstats` (
                    id int NOT NULL AUTO_INCREMENT,
                    kills int,
                    deaths int,
                    points int
                )ENGINE=InnoDB DEFAULT CHARSET=latin1
            ]] )
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

--------------------------------------------------------------------------------------------------------------
--General Fetching 
--------------------------------------------------------------------------------------------------------------

function sql_db:CountFactions()
    local qs = [[
    SELECT COUNT( * ) 
    FROM cfcfactions_data
    ]]
    local q = sql_db:query( qs )
end

function sql_db:CountUsers()
    local qs = [[
    SELECT COUNT( * ) 
    FROM cfcusers_data
    ]]
    local q = sql_db:query( qs )
end

function sql_db:CountLogs()
    local qs = [[
    SELECT COUNT( * ) 
    FROM cfcadminlog
    ]]
    local q = sql_db:query( qs )
end

function sql_db:CountFactionUsers( id )

end

--------------------------------------------------------------------------------------------------------------
--Factions
--------------------------------------------------------------------------------------------------------------

function sql_db:saveFaction()
    local qs = [[
    SELECT  
    FROM cfcfactions_data
    ]]
    local q = sql_db:query( qs )
end

function sql_db:saveFactions()
    local qs = [[
    SELECT  
    FROM cfcfactions_data
    ]]
    local q = sql_db:query( qs )
end

function sql_db:loadFaction()
    local qs = [[
    SELECT  
    FROM cfcfactions_data
    ]]
    local q = sql_db:query( qs )
end

function sql_db:loadFactions()
    local qs = [[
    SELECT  
    FROM cfcfactions_data
    ]]
    local q = sql_db:query( qs )
end

function sql_db:removeFaction()
    local qs = [[
    SELECT  
    FROM cfcfactions_data
    ]]
    local q = sql_db:query( qs )
end

--------------------------------------------------------------------------------------------------------------
--Players
--------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------
--Logging
--------------------------------------------------------------------------------------------------------------

--logs an action into cfcadminlog
--playerid = PlayerID64()
--factionid = ID of Faction
--Setting = {Description, Name, User( ID ), Color, InviteOnly, Faction}
--State = {DELETED, MODIFIED, NEW}
-- function sql_db:LogAction( ply, factionid, setting, state )
--  if( ply == nil ) then ply = "( RCON )" end
--  if( type( ply ) == "Player" ) then ply = ply:SteamID64() end
--  local qstz = [[
--     INSERT INTO `cfcadminlog` ( playerid, factionid, setting, state, time )
--     VALUES ( '%s', '%s', '%s', '%s', '%s' )
--     ]]
--     --!-- Color is a structure but can be converted to a string ( json ) IE: 255 255 255 0 becoems "255, 255, 255, 0"
--     qstz = string.format( qstz, ply, factionid, setting, state, os.date( "%H:%M:%S - %d/%m/%Y" , os.time() ) )

--     local q = sql_db:query( qstz )

--  function q:onError( err, sql )
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             sql_db:connect()
--             sql_db:wait()
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             ErrorNoHalt( "Re-connection to database server failed." )
--             return
--             end
--         end
--         MsgN( 'CFCFactions: Query Failed with ' .. err .. ' ( ' .. sql .. ' )' )
--         q:start()
--  end
--  q:start()
-- end

-- --get logs ether by ply or factionid
-- --sort by time
-- function sql_db:GetLogs( min, max, callback )
--  if ply == nil then return end

--  local qs = [[
--      SELECT * 
--      FROM `cfcadminlog`
--      ORDERBY time
--  ]]
--  local qstz = string.format( qstz )
--  local q = sql_db:query( qstz )

--  function q:onSuccess( data )
--      if #data > 0 then
--          callback( data )
--      else
--          ErrorNoHalt( '[GetLogs] Unable to fetch anything but still succeeded' )
--      end

--  end

-- end


-- --Updates a player's stats as well as adds to the SUM() for the overall faction
-- function sql_db:UpdatePlayerStats( id )

--  local qstz = [[

--  ]]
--  qstz = string.format( qstz, id )
-- end

-- --Updates a faction. Not much is different from SetFaction except it takes care of a few parameters for you
-- function sql_db:UpdateFaction( id, name, description, color, invite )


--  local timestamp = os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )
--  if extras == nil then extras = {} end
--      if type( color ) == "table" then color = util.TableToJSON( color ) end
--      if type( invite ) == "boolean" then invite = invite and 1 or 0 end
--      if type( extras ) == "table" then extras = util.TableToJSON( extras ) end

--  --rework in order to store json ( with a single uniquieid )
--  local qstz = [[
--      INSERT INTO `cfcfactions_data` ( uniqueid, name, description, color, invite, owner, created, edited, extras )
--      VALUES ( '%s', '%s', '%s', '%s', '%s', '0', '0', '%s', '[]' )
--      ON DUPLICATE KEY UPDATE
--          name = VALUES( name ),
--          description = VALUES( description ),
--          color = VALUES( color ),
--          invite = VALUES( invite ),
--          edited = VALUES( edited )

--          #uniqueid = VALUES( uniqueid ),
--          #owner = VALUES( owner ),
--          #created = VALUES( created ),
--          #extras = VALUES( extras )

--      ]]
--  qstz = string.format( qstz, id, sql_db:escape( name ), sql_db:escape( description ), color, invite, timestamp )
--   local q = sql_db:query( qstz )
--   print( qstz )
--  function q:onError( err, sql )
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             sql_db:connect()
--             sql_db:wait()
--           end
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             ErrorNoHalt( "Re-connection to database server failed." )
--             return
--         end
--         MsgN( 'CFCFactions: Query Failed with ' .. err .. ' ( ' .. sql .. ' )' )
--         q:start()
--  end
--  q:start()   
-- end


-- --Sets all Factions from a given table
-- --best not to directly inject into the table
-- function sql_db:SetFaction( id, name, description, color, invite, owner, created, edited, extras )
--  local timestamp = os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )
--  if extras == nil then extras = {} end
--      if type( color ) == "table" then color = util.TableToJSON( color ) end
--      if type( invite ) == "boolean" then invite = invite and 1 or 0 end
--      if type( extras ) == "table" then extras = util.TableToJSON( extras ) end
--      if extras == nil then extras = {} end

--  --rework in order to store json ( with a single uniquieid )
--  local qstz = [[
--      INSERT INTO `cfcfactions_data` ( uniqueid, name, description, color, invite, owner, created, edited, extras )
--      VALUES ( '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s' )
--          ON DUPLICATE KEY UPDATE
--          name = VALUES( name ),
--          description = VALUES( description ),
--          color = VALUES( color ),
--          invite = VALUES( invite ),
--          edited = VALUES( edited ),
--          extras = VALUES( extras )
--      ]]
--  qstz = string.format( qstz, id, sql_db:escape( name ), sql_db:escape( description ), color,
--      invite, owner, created, edited, extras )
--   local q = sql_db:query( qstz )

--  function q:onError( err, sql )
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             sql_db:connect()
--             sql_db:wait()
--           end
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             ErrorNoHalt( "Re-connection to database server failed." )
--             return
--         end
--         MsgN( 'CFCFactions: Query Failed with ' .. err .. ' ( ' .. sql .. ' )' )
--         q:start()
--  end
--  q:start()   
-- end


-- function sql_db:GetUsersByFactionID( factionid, callback )

--  local qs = [[
--      SELECT * 
--      FROM `cfcusers_data`
--      WHERE factionid = '%s'
--  ]]

--  qs = string.format( qs, factionid )
--  local q = sql_db:query( qs )
--     function q:onSuccess( data )
    
--      if #data > 0 then
--          local onlineusers = {}
--          local offlineusers = {}  
--          for k, d in pairs( data ) do
--              local row = data[k]
--              for _, p in pairs( player.GetHumans() ) do
--                  if ( table.HasValue( row, p:SteamID64() ) ) then 

--                      table.insert( onlineusers, p )
--                  else

--                      table.insert( offlineusers, d.playerid )
--                  end
--              end
--          end
            
--          callback( data, onlineusers, offlineusers )
--      else
--          ErrorNoHalt( '[GetUsersByFaction] Unable to fetch anything but still succeeded' )
--      end
--  end

--     function q:onError( err, sql )
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             sql_db:connect()
--             sql_db:wait()
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             ErrorNoHalt( "Re-connection to database failed." )
--             return
--             end
--         end
--         MsgN( 'CFCFactions: Query Failed with ' .. err .. ' ( ' .. sql .. ' )' )
--         q:start()
--     end
     
--     q:start()    
-- end

-- function sql_db:IsFactionNameUnique( name )
-- local IsUnique = false
--      local qs = [[
--          SELECT name
--          FROM `cfcfactions_data`
--      ]]
--      local q = sql_db:query( qs )
--      --PrintTable( q )
--      function q:onSuccess( data )
--          if #data > 0 then
--              for k, v in pairs( data ) do
--                  if table.HasValue( name ) then
--                      net.Start( "IsFactionNameUniqueSend" )
--                      net.WriteBit( 1 )
--                      net.Send( ply )
--                      IsUnique = true
--                  end

--              end
--              if IsUnique == false then
--                      net.Start( "IsFactionNameUniqueSend" )
--                      net.WriteBit( 0 )
--                      net.Send( ply )
--              end
--          else
--              ErrorNoHalt( '[IsFactionNameUnique] Unable to fetch anything but still succeeded' )
--          end
--      end
--      function q:onError( err, sql )
--      if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--          sql_db:connect()
--          sql_db:wait()
--      if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--          ErrorNoHalt( "Re-connection to database server failed." )
--          return
--          end
--      end
--      MsgN( 'CfcFactions MySQLOO: Query Failure: ' .. err .. ' [' .. sql .. ']' )
--      q:start()
--  end
--  q:start()
-- end


-- --Gets factions by min_number, max_number from DB and sends over net individually [1] Faction1 [2]Faction2 [3]...
-- --Takes range1 to range2 to return results. 5-10, 11-19, etc
-- --Returns by callback( data )
-- function sql_db:GetFactions( r1, r2, callback )
--  local min = tonumber( r1 )
--  local max = tonumber( r2 )
--  if min <= 0 then min = 0 end
--  if max <= 0 then max = 1 end

--  local qs = [[
--      SELECT *
--      FROM `cfcfactions_data`
--      LIMIT %s, %s
--  ]]
--  local q = sql_db:query( qs )
--  local qstz = string.format( q, min, max )
--  --PrintTable( q )
--  function q:onSuccess( data )
--      if #data > 0 then
--          callback( data )
--      else
--          ErrorNoHalt( '[GetAllFactions] Unable to fetch anything but still succeeded' )
--      end
--  end
--  function q:onError( err, sql )
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             sql_db:connect()
--             sql_db:wait()
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             ErrorNoHalt( "Re-connection to database server failed." )
--             return
--             end
--         end
--         MsgN( 'CfcFactions MySQLOO: Query Failure: ' .. err .. ' [' .. sql .. ']' )
--         --q:start()
--  end
--  q:start()

-- end

-- --Gets a factions from DB and sends over net
-- --Sends by ID:string DATA:binary where DATA is compressed json!
-- function sql_db:GetFaction( factionid, callback )
--  local qs = [[
--      SELECT *
--      FROM `cfcfactions_data`
--      WHERE uniqueid = '%s'
--  ]]
--  qs = string.format( qs, factionid )
--  local q = sql_db:query( qs )

--  function q:onSuccess( data )
--      if #data > 0 then

--          callback( data )
--      else
--          ErrorNoHalt( '[GetFaction] Unable to fetch anything but still succeeded' )
--      end
--  end
--  function q:onError( err, sql )
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             sql_db:connect()
--             sql_db:wait()
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             ErrorNoHalt( "Re-connection to database server failed." )
--             return
--             end
--         end
--         MsgN( 'CfcFactions MySQLOO: Query Failure: ' .. err .. ' [' .. sql .. ']' )
--         q:start()
--  end
--  q:start()
-- end




-- --Sets all users from a given table
-- --best not to directly inject into the table
-- function sql_db:SetUser( plyid, factionid, rank, extras )
--      MsgN( string.format( "Passed %s - %s - %s - %s \n", plyid, factionid, rank, extras ) )
--      if extras == nil then extras = {} end
--  --if player is passed, just convert into proper string format

--      local qs = [[
--          INSERT INTO `cfcusers_data` ( playerid, factionid, factionrank, extras )
--          VALUES ( '%s', '%s', '%s', '%s' )
--          ON DUPLICATE KEY UPDATE
--              factionid = VALUES( factionid ),
--              factionrank = VALUES( factionrank ),
--              extras = VALUES( extras )

--      ]]
--      qs = string.format( qs, plyid, factionid, rank, util.TableToJSON( extras ) )
--      MsgN( qs )
--      local q = sql_db:query( qs )


--      function q:onError( err, sql )
--          if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--              sql_db:connect()
--              sql_db:wait()
--           end
--          if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--              ErrorNoHalt( "Re-connection to database failed." )
--              return
--          end

--          MsgN( 'CFCFactions: Query Failed with ' .. err .. ' ( ' .. sql .. ' )' )
--          q:start()
--      end
         
--      q:start()
-- end







-- --Gets a user from DB and sends over net
-- --Sends by playerid:string, factionid:string, rank:string, data:blob
-- --where data is compressed!
-- function sql_db:GetUser( ply, callback )
--  if type( ply ) == "Player" then ply = ply:SteamID64() end
--  local qs = [[
--      SELECT *
--      FROM `cfcusers_data`
--      WHERE playerid = '%s'
--  ]]
--  qs = string.format( qs, ply )
--     local q = sql_db:query( qs )


--     function q:onSuccess( data )
--      if #data > 0 then
--              callback( data )
--      else
--          ErrorNoHalt( '[Get User] Unable to fetch anything but still succeeded' )
--      end
--  end

--     function q:onError( err, sql )
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             sql_db:connect()
--             sql_db:wait()
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             ErrorNoHalt( "Re-connection to database failed." )
--             return
--             end
--         end
--         MsgN( 'CFCFactions: Query Failed with ' .. err .. ' ( ' .. sql .. ' )' )
--         q:start()
--     end
     
--     q:start()

-- end



-- --Retrieves all current users from operating db
-- function sql_db:GetUsers( callback )
--  local qs = [[
--      SELECT *
--      FROM `cfcusers_data`
--  ]]
--  qs = string.format( qs, factionid )
--     local q = sql_db:query( qs )


--     function q:onSuccess( data )
--      if #data > 0 then
--          callback( data )
--      else
--          ErrorNoHalt( '[Get User] Unable to fetch anything but still succeeded' )
--          MsgN( qs )
--      end
--  end

--     function q:onError( err, sql )
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             sql_db:connect()
--             sql_db:wait()
--          end
--         if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--             ErrorNoHalt( "Re-connection to database failed." )
--             return
--         end
--         MsgN( 'CFCFactions: Query Failed with ' .. err .. ' ( ' .. sql .. ' )' )
--         q:start()
--     end
     
--     q:start()

-- end


-- --Several ways to properly insert and extract "extras"
-- --Extras is a table that is converted into a JSON string 

-- --Method 1:  Insert / Extract individual table key/value pairs
-- --Method 2: Insert / Extract entire table/json
-- --Method 3: Use SQL to do the same as Method 1, but sql side

-- --Method 2 is our chosen method for now
-- function sql_db:SetUserExtras( playerid, extras )
--  --Get any extras that have already been checked
--  --Check if what we're adding is not already in the table
--  --push the query that contains extras back into db and save

--  --TODO: optimize shit shit out of this or choose a different method
--  --adding and setting entire tables is dumb
--  if( extras == nil ) then return end

--  --TODO: redo this and instead implement a full sql statement ( instead of using sql_db:GetUserExtras() )
--  sql_db:GetUserExtras( playerid, function( userxtras )
--      local tmpTable = util.JSONToTable( userxtras )
--      if userxtras == nil then return end
--          local qs = [[
--          INSERT INTO `cfcusers_data` ( playerid, factionid, factionrank, extras )
--          VALUES ( '%s', '0', '0', '%s' )
--          ON DUPLICATE KEY UPDATE
--              extras = VALUES( extras )
--      ]]
        

--      table.insert( tmpTable, extras )

--      --pass id::String, edited::String, extras::Table
--      qs = string.format( qs, factionid, os.date( "%H:%M:%S - %d/%m/%Y" , os.time() ), 
--          util.TableToJSON( tmpTable ) )


--      local q = sql_db:query( qs )



--      function q:onError( err, sql )
--          if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--              sql_db:connect()
--              sql_db:wait()
--          if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--              ErrorNoHalt( "Re-connection to database server failed." )
--              return
--              end
--          end
--          MsgN( 'CfcFactions MySQLOO: Query Failure: ' .. err .. ' [' .. sql .. ']' )
--          q:start()
--      end
--      q:start()


--  end )

-- end

-- --see SetUserExtras for detailed notes on how this should work.
-- function sql_db:SetFactionExtras( factionid, extras )
--  if( extras == nil ) then return end
--  sql_db:GetUserExtras( playerid, function( factionextras )
--      local tmpTable = util.JSONToTable( factionextras )
--      if factionextras == nil then return end
--          local qs = [[
--          INSERT INTO `cfcfactions_data` ( uniqueid, name, description, color, invite, owner, created, edited, extras )
--          VALUES ( '%s', '0', '0', '0', '0', '0', '0', '%s' '%s' )
--          ON DUPLICATE KEY UPDATE
--              edited = VALUES( edited ),
--              extras = VALUES( extras )
--      ]]
        

--      table.insert( tmpTable, extras )
--      qs = string.format( qs, factionid, util.TableToJSON( tmpTable ) )
--      local q = sql_db:query( qs )



--      function q:onError( err, sql )
--          if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--              sql_db:connect()
--              sql_db:wait()
--          if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--              ErrorNoHalt( "Re-connection to database server failed." )
--              return
--              end
--          end
--          MsgN( 'CfcFactions MySQLOO: Query Failure: ' .. err .. ' [' .. sql .. ']' )
--          q:start()
--      end
--      q:start()


--  end )

-- end


-- --Deletes a user based on playerid ( SteamID64 )
-- function sql_db:DeleteUser( id )

--  local qs = [[
--      DELETE FROM cfcusers_data WHERE playerid = "%s";
--  ]]
--  local q = sql_db:query( qs, id )

--     function q:onSuccess()
--      MsgN( "Deleted user by " .. id )
--  end

--     function q:onError( err, sql )
--      if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--          sql_db:connect()
--          sql_db:wait()
--       end
--      if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--          ErrorNoHalt( "Re-connection to database failed." )
--          return
--      end

--      MsgN( 'CFCFactions: Query Failed with ' .. err .. ' ( ' .. sql .. ' )' )
--      q:start()
--     end
--     q:start()
-- end


-- --Deletes a faction and its users
-- function sql_db:DeleteFaction( id )
--  local qs = [[
--      DELETE FROM cfcfactions_data WHERE uniqueid = '%s';
--  ]]
--  qs = string.format( qs, id )
--  local q = sql_db:query( qs, id )

--     function q:onSuccess()
--      sql_db:GetUsersByFactionID( id, function( data, online, offline )
--          for k, v in pairs( data ) do
--              print( data[k].playerid )
--              sql_db:DeleteUser( data[k].playerid )
--          end
--      end )
--  end

--     function q:onError( err, sql )
--      if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--          sql_db:connect()
--          sql_db:wait()
--       end
--      if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--          ErrorNoHalt( "Re-connection to database failed." )
--          return
--      end

--      MsgN( 'CFCFactions: Query Failed with ' .. err .. ' ( ' .. sql .. ' )' )
--      q:start()
--     end
--     q:start()
-- end


-- --Deletes all logs
-- function sql_db:DeleteAllLogs()

--  local qs = [[
--      TRUNCATE TABLE `cfcadminlog`
--  ]]
--  local q = sql_db:query( qs )




--     function q:onSuccess()
--      MsgN( "Cleared all logs" )
--  end

--     function q:onError( err, sql )
--      if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--          sql_db:connect()
--          sql_db:wait()
--       end
--      if sql_db:status() ~= mysqloo.DATABASE_CONNECTED then
--          ErrorNoHalt( "Re-connection to database failed." )
--          return
--      end

--      MsgN( 'CFCFactions: Query Failed with ' .. err .. ' ( ' .. sql .. ' )' )
--      q:start()
--     end
--     q:start()

-- end
