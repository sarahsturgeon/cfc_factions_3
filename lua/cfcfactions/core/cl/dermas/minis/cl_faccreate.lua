local PANEL = {}

local idCounter = 0
local cfg = cfcFactions.Config.ColorSchemes

function PANEL:Init()

    self.id = idCounter
    idCounter = idCounter + 1

    self:SetSize( 500, 480 )
    self:SetTitle( "" )
    self:ShowCloseButton( false )
    self.Paint = nil

    self:Center()
    self:SetDraggable( false )

    self:MakePopup()
    self:InvalidateLayout( true )

    self.MiniPanel = vgui.Create( "DPanel", self )
    -- Not using dock as we want to fill the frame
    self.MiniPanel:SetPos( 0, 0 )
    self.MiniPanel:SetSize( self:GetSize() )
    function self.MiniPanel:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h, color_white )
        draw.RoundedBox( 0, 1, 1, w - 2, h - 2, cfg.BackgroundPanel )
    end

    self.NameLabel = vgui.Create( "DLabel", self.MiniPanel )
    self.NameLabel:SetText( "Faction name:" )
    self.NameLabel:SetTextColor( color_white )
    self.NameLabel:Dock( TOP )
    self.NameLabel:DockMargin( 15, 5, 15, 0 )

    self.NameEntry = vgui.Create( "DTextEntry", self.MiniPanel )
    self.NameEntry:SetText( LocalPlayer():Nick() .. "'s Faction" )
    self.NameEntry:Dock( TOP )
    self.NameEntry:DockMargin( 15, 5, 15, 0 )
    self.NameEntry:SetPlaceholderText( "Enter a faction name within 3-50 characters..." )

    self.NameError = vgui.Create( "DLabel", self.MiniPanel )
    self.NameError:SetText( "" )
    self.NameError:SetWide( 300 )
    self.NameError:SetTextColor( Color( 140, 18, 0 ) )
    self.NameError.PerformLayout = function( this, w, h )
        local x, y = self.NameLabel:GetPos()
        local nw, ny = self.NameLabel:GetTextSize()
        this:SetPos( x + nw + 10, y )
    end

    self.InviteBool = vgui.Create( "DCheckBoxLabel", self.MiniPanel )
    self.InviteBool:SetTextColor( color_white )
    self.InviteBool:SetText( "Invite only?" )
    self.InviteBool:Dock( TOP )
    self.InviteBool:DockMargin( 15, 5, 15, 0 )
    self.InviteBool:SetValue( 0 )

    self.TempBool = vgui.Create( "DCheckBoxLabel", self.MiniPanel )
    self.TempBool:SetTextColor( color_white )
    self.TempBool:SetText( "Is temporary?" )
    self.TempBool:Dock( TOP )
    self.TempBool:DockMargin( 15, 5, 15, 0 )
    self.TempBool:SetValue( 0 )

    self.DescLabel = vgui.Create( "DLabel", self.MiniPanel )
    self.DescLabel:SetText( "Faction description:" )
    self.DescLabel:SetTextColor( color_white )
    self.DescLabel:Dock( TOP )
    self.DescLabel:DockMargin( 15, 5, 15, 0 )

    self.DescEntry = vgui.Create( "DTextEntry", self.MiniPanel )
    self.DescEntry:Dock( TOP )
    self.DescEntry:DockMargin( 15, 5, 15, 0 )
    self.DescEntry:SetHeight( 90 )
    self.DescEntry:SetMultiline( true )
    self.DescEntry:SetWrap( true )
    self.DescEntry:SetPlaceholderText( "Enter a faction description... ( Optional )" )

    self.DescError = vgui.Create( "DLabel", self.MiniPanel )
    self.DescError:SetTextColor( Color( 140, 18, 0 ) )
    self.DescError:SetText( "" )
    self.DescError:SetWide( 300 )
    self.DescError.PerformLayout = function( this, w, h )
        local x, y = self.DescLabel:GetPos()
        local nw, ny = self.DescLabel:GetTextSize()
        this:SetPos( x + nw + 10, y )
    end

    self.ColLabel = vgui.Create( "DLabel", self.MiniPanel )
    self.ColLabel:SetText( "Faction color:" )
    self.ColLabel:SetTextColor( color_white )
    self.ColLabel:Dock( TOP )
    self.ColLabel:DockMargin( 15, 5, 15, 0 )

    self.ColSelection = vgui.Create( "DColorMixer", self.MiniPanel )
    self.ColSelection:SetAlphaBar( false )
    self.ColSelection:SetWangs( false )
    self.ColSelection:SetPalette( false )
    self.ColSelection:SetHeight( 150 )
    self.ColSelection:Dock( TOP )
    self.ColSelection:DockMargin( 15, 5, 15, 0 )
    self.ColSelection:SetColor( Color( math.random( 1, 255 ), math.random( 1, 255 ), math.random( 1, 255 ), 255 ) )

    self.ColOutput = vgui.Create( "DPanel", self.MiniPanel )
    self.ColOutput:Dock( TOP )
    self.ColOutput:DockMargin( 15, 5, 15, 0 )

    self.ColOutput.Paint = function( this, w, h )
        surface.SetDrawColor( self.ColSelection:GetColor() )
        surface.DrawRect( 0, 0, w, h )
    end

    self.MainError = vgui.Create( "DLabel", self.MiniPanel )
    self.MainError:SetText( "" )
    self.MainError:SetWide( 300 )
    self.MainError:SetTextColor( Color( 140, 18, 0 ) )
    self.MainError:Dock( TOP )
    self.MainError:DockMargin( 20, 2, 15, 0 )

    self.Submit = vgui.Create( "DButton", self.MiniPanel )
    self.Submit:Dock( TOP )
    self.Submit:DockMargin( 15, 3, 15, 0 )
    self.Submit:SetText( "Submit" )

    local errorMap = {
        name = { entry = self.NameEntry, error = self.NameError },
        description = { entry = self.DescEntry, error = self.DescError }
    }

    self.Submit.DoClick = async( function()
        self.Submit:SetEnabled( false )
        local col = self.ColSelection:GetColor()
        col = col.r .. "," .. col.g .. "," .. col.b

        local success, data = await( NP.net.send( "cfc_Fac_CreateFaction",
            self.NameEntry:GetText(), col, self.DescEntry:GetText(), self.InviteBool:GetChecked(), self.TempBool:GetChecked() ) )

        if success then
            self:Remove()
        else
            self.Submit:SetEnabled( true )
            data.argumentError = data.argumentError or {}
            for k, v in pairs( data.argumentError ) do
                if errorMap[k] then
                    local entry = errorMap[k].entry
                    entry:SetTextColor( Color( 255, 0, 0 ) )
                    local prevOnChange = entry.OnChange
                    function entry:OnChange( ... )
                        self:SetTextColor( Color( 0, 0, 0 ) )
                        self.OnChange = prevOnChange
                        prevOnChange( self, ... )
                    end
                    errorMap[k].error:SetText( tostring( v ) )
                else
                    self.MainError:SetText( "Uh oh, something went wrong" )
                end
            end
            if table.Count( data ) > 1 then
                self.MainError:SetText( "Uh oh, something went wrong" )
            end
            PrintTable( data )
        end
    end )

    hook.Add( "VGUIMousePressed", "cfc_Fac_FactionCreateClick" .. self.id, function( pnl, code )
        local x, y = gui.MousePos()
        local left, top = self:LocalToScreen( 0, 0 )
        local right, bottom = self:LocalToScreen( self:GetSize() )
        if x < left or x > right or y < top or y > bottom then
            self:Remove()
        end
    end )
end

function PANEL:OnRemove()
    hook.Remove( "VGUIMousePressed", "cfc_Fac_FactionCreateClick" .. self.id )
end

vgui.Register( "D_cfcfactioncreate", PANEL, "DFrame" )
