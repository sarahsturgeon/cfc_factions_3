local cfcFactions = cfcFactions or {}
local cfg = cfcFactions.Config.Client


function cfcFactions:DisplayMenu()
    if not cfcFactions.MainMenu then
        cfcFactions.MainMenu = vgui.Create( "D_cfcmainderma" )
    end

    if cfcFactions.MainMenu:IsVisible() then
        cfcFactions.MainMenu:Hide()
        gui.EnableScreenClicker( false )
    else
        cfcFactions.MainMenu:Show()
        gui.EnableScreenClicker( true )
    end

end

function cfcFactions:Think()

    if input.IsKeyDown( cfg.CLIENT_KEY ) and not self.KeyDown then
        self.KeyDown = true
    elseif self.KeyDown and not input.IsKeyDown(cfg.CLIENT_KEY) then
        self.KeyDown = false
    end

    if not IsValid(self.MainMenu) then
        --for now, open it clientside but ask server permission for opening it eventually (net handling)
        self:DisplayMenu()
    else
        self.MainMenu:Close()
    end

end

hook.Add("Think", "CFC_Factionhook_Clientsidemenu", function()
    cfcFactions:Think()
end)

net.Receive('CFC_Factionhook_ToggleMenu', function(length)
    cfcFactions:DisplayMenu()
end)



