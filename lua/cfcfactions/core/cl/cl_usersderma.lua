

if not CLIENT then return end

local Panel = {}
--cfcFactions.Dermas["View Users"] = {1,Panel}

cfcFactions:RegisterDermaMenu("View Users", Panel, 1)
function Panel:Init()
	
end
function Panel:Paint(w, h)
end
function Panel:Think()
end

vgui.Register('D_cfcusersderma', Panel)

