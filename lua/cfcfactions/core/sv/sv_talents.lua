cfcFactions.Talents = cfcFactions.Talents or {}

--A talent is a tree like structure that gives perks

--[[

Tree = {
    --Branch 1
    1 = {
        --Perk 1
        1 = {}
        --Perk 2
        2 = {}
        --Perk 3
        3 = {}
    },
    Branch 2
    2 = {
        --Perk 1
        1 = {}
        --Perk 2
        2 = {}
        --Perk 3    
        3 = {}
    }

}



Tree {
    --Branch 1
    1 = {
            --Perk 1
            1 = {
                Title = "I'm the juggernaut",
                Description = "Gives the player %s amount of armor on spawn.",
                Var1 = 5,
                XP = 10
                Hook = "PlayerSpawn",
                Func = function()

                end
            },
            --Perk 2
            2 = {
                Title = "Bulletsponge",
                Description = "Gives the player %s amount of extra health on spawn.",
                Var1 = 25,
                XP = 10
            },
            --Perk 3
            3 = {
                Title = "Daka Daka Daka Daka",
                Description = "Gives the player %s amount of extra ammo on spawn.",
                Var1 = 25,
                XP = 10
            }
    },  
    -Branch 2
    2 = {
    
        1 = {
            Title ="Boom!, Headshot!"
            Description = "On successful headshot, do %s damage, %s ft around the afflicted player."
            Var1 = 10,
            Var2 = 5,
            XP = 100
            Func = function( damage )
                local attacker = damage:GetAttacker()
                --do logic shit
            end
        },
        2 = {
        
            "Key" = {
                Title =""
                Description = ""
                Var1 = 0,
                Var2 = 0,
                XP = 0
            
            },
        3 = {
            "Key" = {
                Title =""
                Description = ""
                Var1 = 0,
                Var2 = 0,
                XP = 0
            
            }
    }


}
]]--
