if not CLIENT then return end

cfcFactions.Dermas["View Alerts"] = Panel
local Panel = {}
--cfcFactions:RegisterDermaMenu("View Alerts",Panel)
function Panel:Init()
	--self:SetSize(self:GetWide(), 25)
end
function Panel:Paint(w, h)
end
function Panel:Think()
end

vgui.Register('D_cfcalertsderma', Panel)