
function cfcFactions:DisplayMenu()

    if not self.MainMenu then
        self.MainFrame = vgui.Create( "DFrame" )
        self.MainFrame:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
        self.MainPanel = vgui.Create("D_cfcmainderma", self.MainFrame)
        self.MainPanel:Dock( FILL )
        
        self.MainFrame:SetVisible( false ) 

    end

    if self.MainFrame:IsVisible() then
        self.MainFrame:Hide()
        self.MainFrame:SetDraggable( false )
        gui.EnableScreenClicker( false )
    else
        self.MainFrame:Show()
        --self.SetDraggable( true )
        self.MainFrame:SetDraggable( true )
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