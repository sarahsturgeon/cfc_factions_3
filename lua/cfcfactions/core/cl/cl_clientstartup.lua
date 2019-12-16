
function cfcFactions:DisplayMenu()

    if not self.MainMenu then
        cfcFactions:InitColorSchemes()
        self.MainMenu = vgui.Create( "D_cfcmainderma" )
        self.MainMenu:SetVisible( false ) 
    end

    if self.MainMenu:IsVisible() then
        self.MainMenu:Hide()
        gui.EnableScreenClicker( false )
    else
        self.MainMenu:Show()
        --self.SetDraggable( true )
        gui.EnableScreenClicker( true ) 
    end
end

function cfcFactions:Think()

end

hook.Add("Think", "CFC_Factionhook_Think", function()
    cfcFactions:Think()
end )

net.Receive('CFC_Fac_ToggleDerma', function(length)
    cfcFactions:DisplayMenu()
end )

hook.Add( "PlayerButtonDown", "CFC_Fac_MenukeyDown", function( player, button )
    if MENU_KEY == button then
        net.Start("CFC_Fac_RequestDerma")
        net.SendToServer()
    end
end )