--Data Module settings
cfcFactions.Config.Server = {
    --stance: MySql or SQL
        --"Mysql" is for external db connections / offsite db
        --"SQL" is internally used by gmod and stores it in sv.dll
    DB_Stance = "MySQL",
    MySQL = {
        sql_username = "nativeuser",
        sql_password = "factions",
        sql_hostname = "localhost",
        sql_database = "cfctest",
        sql_port = 3306
    },
}




