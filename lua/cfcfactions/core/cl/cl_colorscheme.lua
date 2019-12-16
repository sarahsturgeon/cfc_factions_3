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

CreateClientConVar( "fpvp_colorscheme", "default", true,  {FCVAR_ARCHIVE, FCVAR_LUA_CLIENT} )
local function AutoCompleteNames()
    local TableToReturn = {}
    for KEY, CHILD in pairs( cfcFactions.ColorSchemes ) do 
        table.insert( TableToReturn, string.lower( string.gsub( KEY, "%.json$", "" ) ) )
    end
    return TableToReturn
end

local function UpdateTheme( ply, cmd, args )
    if not args then 
        return 
    end
    local ArgumentSlice = string.lower( args[1] ) 
    local GetConvar = GetConVar("fpvp_colorscheme"):GetString()
    if ArgumentSlice == GetConvar then
        Msg("[cfcFactions] Same theme selected")
        return
    end
    if cfcFactions.ColorSchemes[ArgumentSlice] then
        RunConsoleCommand( "fpvp_colorscheme", args[1] ) 
        cfcFactions.ColorSchemes.SelectedTheme = string.lower( GetConvar) 
        Msg("Updated theme " .. ArgumentSlice)
    end
end
concommand.Add( "fpvp_scheme", UpdateTheme, AutoCompleteNames, "Changes the current user theme" ) 


function cfcFactions:InitColorSchemes()
    self.ColorSchemes = {}

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
        local fileToRead = file.Read( FullPath ) 
        local schemefile = string.lower( string.gsub( path, "%.json$", "" ) )
        local JSONTable = util.JSONToTable( fileToRead )
        if JSONTable then
            if not self.ColorSchemes[schemefile] then
                
                self.ColorSchemes[schemefile] = JSONTable
            end
        end
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
    --print(panel:GetClassName())
    --Change the actual stuff
    PrintTable(panel:GetTable())
    if IsValid( CurrentScheme ) then
        print("Valid")
        if pane:GetName()  == "DLabel" and not HasOverride( panel_override ) then
            local LabelScheme = CurrentScheme.NormalLabel
            panel:SetColor( LabelScheme.TextColor )
        elseif pane:GetName() == "DButton" and not HasOverride( panel_override ) then
            local ButtonScheme = CurrentScheme.NormalButton
            panel:SetTextColor( ButtonScheme.TextColor )
            panel:SetBackgroundColor( ButtonScheme.TextBackground )
            panel:SetText( "Test" )
        elseif pane:GetName() == "DPanel" and not HasOverride( panel_override ) then
            local PanelScheme = CurrentScheme.BackgroundMainPanel
            panel:SetColor( PanelScheme.BackgroundColor )
        elseif HasOverride( panel_override ) then
            --panel = 
        else

        end
    end

end

function cfcFactions:PaintOverride( masterpanel )
    --Dynamically paint over elements
    if not IsValid( masterpanel ) then return end
    local Children = masterpanel:GetChildren()

    for KEY, CHILD in pairs( Children ) do
        if table.Count( CHILD:GetChildren() ) > 0 then
            self:PaintOverride( CHILD )
        else
            self:ApplyColorScheme( CHILD )
        end
    end
end