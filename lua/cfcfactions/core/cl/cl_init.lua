


cfcFactions.IsOpen = false
cfcFactions.MainDerma = nil
cfcFactions.CurrentTab = nil



include("cfcfactions/core/sh/sh_init.lua")
include("cfcFactions/config/cl_config.lua")
include("cfcfactions/core/cl/cl_mainderma.lua")
include("cfcfactions/core/cl/cl_factionsderma.lua")
include("cfcfactions/core/cl/cl_usersderma.lua")
include("cfcfactions/core/cl/cl_newsderma.lua")
include("cfcfactions/core/cl/cl_alertbox.lua")
include("cfcfactions/core/cl/cl_utilities.lua")
include("cfcfactions/core/cl/cl_creditsderma.lua")



--Displays and handles closing (an already open) menu derma. 
function cfcFactions:DisplayMenu()

	if not cfcFactions.MainDerma or cfcFactions.MainDerma == nil then
		cfcFactions.MainDerma = vgui.Create("D_cfcmainderma")
		cfcFactions.MainDerma:SetVisible(false)
		
	end

	if not cfcFactions.MainDerma:IsVisible() then
		cfcFactions:ClearAlerts()
		cfcFactions.MainDerma:Show()
		gui.EnableScreenClicker(true)
	else
		cfcFactions.MainDerma:Hide()
		gui.EnableScreenClicker(false)
	end	
end

--If the defined key is properly set, users can use that specific key to also open/close the derma
hook.Add("PlayerButtonDown","CFC_FAC_MENUKEYDOWN", function(ply, button)
	if input.GetKeyName(button) == cfcFactions.Config.CLIENT_KEY then
		cfcFactions:DisplayMenu()
	end
end)

--If a user requests to display the derma from serverside
net.Receive('CFC_Fac_ToggleDerma', function(len, ply)
	cfcFactions:DisplayMenu()
end)

net.Receive('CFC_Fac_SendMessage', function(len, ply)

end)


