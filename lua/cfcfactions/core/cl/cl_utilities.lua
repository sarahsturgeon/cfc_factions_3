function render.DrawPolyOutline( poly )
    for i = 1, #poly - 1 do
        local p1 = poly[i]
        local p2 = poly[i + 1]
        render.drawLine( p1.x, p1.y, p2.x, p2.y )
    end
    local p1 = poly[1]
    local plast = poly[#poly]
    render.drawLine( p1.x, p1.y, plast.x, plast.y )
end

-- Force a solid background on panels, rather than rounded darkened edges
function cfcFactions.solidBgPaint( self, w, h )
    surface.SetDrawColor( self:GetBackgroundColor() )
    surface.DrawRect( 0, 0, w, h )
end
