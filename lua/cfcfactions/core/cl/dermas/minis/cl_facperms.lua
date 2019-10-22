local Panel = {}

function addPermCategory( text, par )
    local label = vgui.Create( "DLabel", par )
    label:SetText( text )
    label:Dock( TOP )
    label:DockMargin( 10, 5, 0, 0 )
end

function addPermCheckbox( perm, par )
    local check = vgui.Create( "DCheckBoxLabel", par )
    check:Dock( TOP )
    check:DockMargin( 20, 10, 0, 0 )
    check:SetText( perm )
    check:SetValue( 0 )
    
    function check:OnChange( val )
        -- networking magic goes here
    end
end

function Panel:Init()
    self:SetSize(300, 450)
    self:SetPos( ( ( ScrW() / 2 ) - ( self:GetWide() / 2 ) ), ( ( ScrH() / 2 ) - ( self:GetTall() / 2 ) ) )
    
    local f = vgui.Create( "DFrame", self )
    f:SetDraggable( false )
    f:Dock( FILL )
    f:Center()
    f:MakePopup()

    --[[ ex.
    addPermCategory( "super important stuff", f )
    addPermCheckbox( "ur mom?", f )
    addPermCheckbox( "ur dad?", f )
    addPermCheckbox( "ur bald headed granny?", f )
    
    addPermCategory( "stupid", f )
    addPermCheckbox( "ur mom?", f )
    ]]
end

vgui.Register("D_factionpermissions", Panel)