if not CLIENT then return end


local Panel = {}
--cfcFactions.Dermas["View Credits"] = {10,Panel}
cfcFactions:RegisterDermaMenu("View Credits", Panel, 10)
function Panel:Init()
    self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
end
function Panel:Paint(w, h)
end
function Panel:Think()
end

vgui.Register('D_cfccreditssderma', Panel)