local Panel = {}

function Panel:Init()
    self = vgui.Create( "DFrame" )
    self:SetSize( 400, 180 )
    self:Center()
    self:DockPadding( 0, 0, 0, 0 )
    self:SetTitle( "" )
    self:ShowCloseButton( false )
    self:MakePopup()

    function self:Paint( w, h )
        surface.SetDrawColor( Color( 31, 32, 39 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    local frame = self

    local frameDivideA = vgui.Create( "DPanel", self )
    frameDivideA:Dock( FILL )
    frameDivideA.Paint = nil

    local labelTitle = vgui.Create( "DLabel", frameDivideA )
    labelTitle:SetFont( "Trebuchet24" )
    labelTitle:SetText( "Delete faction" )
    labelTitle:SetTextColor( Color( 255, 255, 255 ) )
    labelTitle:Dock( TOP )
    labelTitle:DockMargin( 10, 10, 0, 10 )
    labelTitle:SizeToContents()

    local labelMessage = vgui.Create( "DLabel", frameDivideA )
    labelMessage:SetText( "Are you sure you want to delete this faction? This action cannot be undone." )
    labelMessage:SetTextColor( Color( 255, 255, 255 ) )
    labelMessage:Dock( TOP )
    labelMessage:DockMargin( 10, 0, 0, 0 )
    labelMessage:SizeToContents()
    labelMessage:SetWrap( true )
    labelMessage:SetMultiline( true )

    local frameDivideB = vgui.Create( "DPanel", self )
    frameDivideB:Dock( BOTTOM )
    frameDivideB:SetHeight( 50 )

    function frameDivideB:Paint( w, h )
        surface.SetDrawColor( Color( 45, 49, 58 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    local buttonYes = vgui.Create( "DButton", frameDivideB )
    buttonYes:Dock( RIGHT )
    buttonYes:DockMargin( 0, 10, 10, 10 )
    buttonYes.Paint = nil
    buttonYes.DoClick = function()
        frame:Close()
    end

    function buttonYes:PaintOver( w, h )
        if not self:IsHovered() then
            draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 0, 0 ) )
        else
            draw.RoundedBox( 4, 0, 0, w, h, Color( 205, 0, 0 ) )
        end

        draw.SimpleText( "Delete", "CenterPrintText", w / 2, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local buttonNo = vgui.Create( "DButton", frameDivideB )
    buttonNo:Dock( RIGHT )
    buttonNo:DockMargin( 0, 10, 10, 10 )
    buttonNo.Paint = nil
    buttonNo.DoClick = function()
        frame:Close()
    end

    function buttonNo:PaintOver( w, h )
        if not self:IsHovered() then
            draw.RoundedBox( 4, 0, 0, w, h, Color( 31, 32, 39 ) )
        else
            draw.RoundedBox( 4, 0, 0, w, h, Color( 74, 74, 74 ) )
        end

        draw.SimpleText( "Cancel", "CenterPrintText", w / 2, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
end

vgui.Register( "D_confirmation", Panel )