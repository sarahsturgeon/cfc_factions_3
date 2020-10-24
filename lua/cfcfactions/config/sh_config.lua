local cfcFactions = cfcFactions or {}

cfcFactions.Config = table.Merge( cfcFactions.Config or {}, {
    -- Defacto settings
    ChatCommand = "!fpvp",
    Paths = {
        BACKEND_ROOT = "https://factions.cfcservers.org/dev/",
        FACTIONS_ENDPOINT = "factions",
        PLAYERS_ENDPOINT = "players",
        -- TODO think about if this is ok - "its not"
        PLAYERS_FIND_ENDPOINT = "players/find"
    }
} )