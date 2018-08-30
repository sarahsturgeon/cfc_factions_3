if not CLIENT then return end

cfcFactions.FactionsView = nil

local Panel = {}

cfcFactions:RegisterDermaMenu("View Factions", Panel, 1)

function Panel:Init()
	cfcFactions.FactionsView=1

end
function Panel:Paint(w, h)

end
function Panel:Think()
end

vgui.Register('D_cfcfactionsderma', Panel)
