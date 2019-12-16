local Default = {
    ["Default"] = 
    {
        ["AllowEditing"] = false,
        ["Name"] = "default",
        --A regular button
        ["NormalButton"] = 
        {
            ["Match"] = "DButton",
            ["TextColor"] = Color( 255, 255, 255, 255 ),
            ["TextPressedColor"] = Color( 192, 192, 192, 255 ),
            ["TextBackground"] = Color( 36, 128, 185 )
        },
        --A tab button
        ["WindowButtonExit"] = 
        {
            ["Match"] = "DButton",
            ["TextColor"] = Color( 255, 255, 255, 255 ),
            ["TextPressedColor"] = Color( 255, 0, 0, 255 ),
            ["TextBackground"] = nil
        },


        --A tab button
        ["TabButton"] = 
        {
            ["Match"] = "DButton",
            ["TextColor"] = Color( 255, 255, 255, 255 ),
            ["TextPressedColor"] = Color( 192, 192, 192, 255 ),
            ["TextBackground"] = Color( 36, 128, 185 )
        },

        --Regular label
        ["NormalLabel"] = 
        {
            ["Match"] = "DLabel",
            ["TextColor"] = Color( 255, 255, 255, 255 ),
            ["Font"] = "Arial"    
        },

            --Regular label
        ["HeaderLabel"] = 
        {
            ["Match"] = "DLabel",
            ["TextColor"] = Color( 255, 255, 255, 255 ),
            ["Font"] = "Arial"  
        },

        --Regular label
        ["ImportantLabel"] = 
        {
            ["Match"] = "DLabel",
            ["TextColor"] = Color( 255, 0, 0, 255 ),
            ["Font"] = "Arial"  
        },
        --Regular label
        ["EasterEggLabel"] = 
        {
            ["Match"] = "DLabel",
            ["TextColor"] = Color( 153, 51, 255, 255 ),
            ["Font"] = "Arial"  
        },
        --Panels that are set inline into another panel
        ["BackgroundMiniPanelFirst"] = 
        {
            ["Match"] = "DPanel",
            ["BackgroundColor"] = Color( 44, 62, 80, 200 )
        },
        --Secondary version of BackgroundMiniPanelFirst to spice things up
        ["BackgroundMiniPanelSecond"] = 
        {
            ["Match"] = "DPanel",
            ["BackgroundColor"] = Color( 88, 124, 160, 200 ) 
        },
        --Secondary version of BackgroundMiniPanelFirst to spice things up
        ["BackgroundMainPanel"] = 
        {
            ["Match"] = "DPanel",
            ["BackgroundColor"] = Color( 55, 55, 55, 220 )
        }
    }
}



--GetConVar("fpvp_colorscheme"):GetString()
cfcFactions.ColorSchemes = cfcFactions.ColorSchemes or {}

--CreateClientConVar( string name, string default, boolean shouldsave=true, boolean userinfo=false, string helptext="", number min=nil, number max=nil ) 
CreateClientConVar( "fpvp_colorscheme", "default", true,  FCVAR_ARCHIVE )
function cfcFactions:AutoCompleteNames()
    local TableToReturn = {}
    for KEY, CHILD in pairs( cfcFactions.ColorSchemes ) do 
        table.insert( TableToReturn, CHILD[KEY].Name )
    end
    return TableToReturn and TableToReturn or {}
end

local function UpdateTheme( ply, cmd, args )
    if #args == 0 then 
        return {} 
    end
    local ArgumentSlice = string.lower( args[1] ) 


    if cfcFactions.ColorSchemes[ArgumentSlice] then
        local GetConvar = GetConVar("fpvp_colorscheme"):GetString()
        cfcFactions.ColorSchemes.SelectedTheme = string.lower( GetConvar) 
        Msg("Updated theme " .. ArgumentSlice)
    end
end
concommand.Add( "fpvp_scheme", UpdateTheme, AutoCompleteNames, "Changes the current user theme" ) 


function cfcFactions:InitColorSchemes()
    local ConfigPath = "cfcFactions/config/"
    local ConfigName = "clientcfg.json"
    local ConfigFile = ConfigPath .. ConfigName
    local SchemesPath = "cfcFactions/colorschemes/"


    if not file.Exists( ConfigPath, "DATA" ) then
        file.CreateDir( ConfigPath ) 
    end
    if not file.Exists( SchemesPath, "DATA" ) then
        file.CreateDir( SchemesPath ) 
    end

    if not file.Exists( ConfigFile, "DATA" ) then
        file.Write( ConfigFile, cfcFactions.ColorSchemes )
    end

    cfcFactions:WriteDefaultScheme()
    cfcFactions:LoadCustomColorSchemes()
    self.CurrentColorScheme = cfcFactions.ColorSchemes.Default
end
function cfcFactions:WriteDefaultScheme()
    local SchemesPath = "cfcfactions/colorschemes/"
    local DefaultFileName = "Default.json"
    local PreparedPath = SchemesPath .. DefaultFileName

    if not file.Exists( PreparedPath, "DATA" ) then
        local PreparedFile = util.TableToJSON( Default, true ) 
        file.Write( PreparedPath, PreparedFile )
    end
end

function cfcFactions:LoadCustomColorSchemes() 
    local LoadedSchemes, _ = file.Find( "cfcfactions/colorschemes/*.json", "DATA" )
    if table.Count( LoadedSchemes  ) > 0 then
        for _ , customschemes in ipairs( LoadedSchemes ) do
            cfcFactions:LoadCustomColorScheme( customschemes )
        end
    end
end

function cfcFactions:LoadCustomColorScheme( path )
    local SchemesPath = "cfcfactions/colorschemes/"
    local FullPath = SchemesPath .. path

    if file.Exists( FullPath, "DATA" ) then
        local fileToRead = file.Read( FullPath, "DATA" ) 
        local schemefile = string.lower( string.gsub( fileToRead, "%.json$", "" ) )
        --print( schemefile )

        local JSONTable = util.JSONToTable( fileToRead ) 
        print( util.JSONToTable( fileToRead ) )
        cfcFactions.ColorSchemes[schemefile] = JSONTable
        print('Storing ' .. JSONTable.Name .. ' @' .. cfcFactions.ColorSchemes[JSONTable.Name] )
        
    end
end

--Allows us to constantly update any panel aswell as override (Dangerous, but doable) to whatever is currently loaded
--as the color scheme. This by default loads a file from data/cfcfactions/config/
--For example, ApplyColorScheme( "MenuButton", nil)

--Overriding lets us use another loaded scheme for the panel. By default, we pass nil
--ApplyColorScheme( "AVeryImportantLabel", "ImportantLabel")
--or even 
--ApplyColorScheme( "AVeryImportantLabel", "NormalLabel")

function cfcFactions:ApplyColorScheme( panel, panel_override )

    --Just encase, lets store a old copy of the panel
    if not IsValid( panel ) then return end

    if not IsValid( panel.oldPaint ) then
        panel.OldPaint = panel.Paint
    end

    if not IsValid( panel.oldPanel ) then
        panel.OldPanel = panel
    end

    local HasOverride = function( override )
        if IsValid( override ) or IsValid( panel.Override ) then
            return true
        else
            return false
        end
    end

    if HasOverride( panel_override ) and not IsValid( panel.HasOverride ) then
        panel.HasOverride = panel_override
    end

    local GetConvar = GetConVar("fpvp_colorscheme"):GetString()
    local CurrentScheme = cfcFactions.ColorSchemes[GetConvar]

    --Change the actual stuff
    if IsValid( CurrentScheme ) then
        if type( panel ) == "DLabel" and not HasOverride( panel_override ) then
            panel:SetColor( CurrentScheme.TextColor )
        elseif type( panel ) == "DButton" and not HasOverride( panel_override ) then

        elseif type( panel ) == "DPanel" and not HasOverride( panel_override ) then

        elseif HasOverride( panel_override ) then
            --panel = 
        else

        end
    end

end

function cfcFactions:PaintOverride()
    --Dynamically paint over elements
    if not IsValid( self.MainMenu ) then return end
    for KEY, CHILD in pairs( self.MainMenu:GetChildren() ) do
        if IsValid( CHILD ) then
            self:ApplyColorScheme( CHILD )
        end
    end
end