if not CLIENT then return end

local Panel = {}
--cfcFactions.Dermas["View Credits"] = {10,Panel}
cfcFactions:RegisterDermaMenu("View Credits", Panel, 10)

local BasePanelWidth  = 1024
local BasePanelHeight = 800
function Panel:Init()
    local curScreenWidth  = ScrW()
    local curScreenHeight = ScrH()

    local panelWidth  = math.Clamp( BaseScreenWidth,  0, curScreenWidth  )
    local panelHeight = math.Clamp( BaseScreenHeight, 0, curScreenHeight )

    self:SetSize( panelWidth, panelHeight )
end

function Panel:Paint(w, h)

end

function Panel:Think()
	
end

vgui.Register('D_cfccreditssderma', Panel)
