function surface.DrawPolyOutline( poly )
    for i = 1, #poly - 1 do
        local p1 = poly[i]
        local p2 = poly[i + 1]
        surface.DrawLine( p1.x, p1.y, p2.x, p2.y )
    end
    local p1 = poly[1]
    local plast = poly[#poly]
    surface.DrawLine( p1.x, p1.y, plast.x, plast.y )
end

-- Force a solid background on panels, rather than rounded darkened edges
function cfcFactions.solidBgPaint( self, w, h )
    surface.SetDrawColor( self:GetBackgroundColor() )
    surface.DrawRect( 0, 0, w, h )
end

local spinnerMaterial = Material( "icons/spinner.png" )

-- Await but with a spinner
function awaitSpinner( element, ... )
    assert( coroutine.running(), "Cannot use awaitSpinner outside of async function" )

    local spinner = vgui.Create( "DPanel", element )
    spinner:SetSize( 100, 100 )
    spinner:Center()

    function spinner:PerformLayout()
        spinner:Center()
    end

    function spinner:Paint( w, h )
        surface.SetMaterial( spinnerMaterial )
        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawTexturedRectRotated( 50, 50, 80, 80, -CurTime() * 500 )
    end

    local data = { await( ... ) }

    if spinner and IsValid( spinner ) then
        spinner:Remove()
    end

    return unpack( data )
end