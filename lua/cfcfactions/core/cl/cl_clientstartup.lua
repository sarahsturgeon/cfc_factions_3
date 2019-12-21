function cfcFactions:DisplayMenu()

    if not self.MainFrame then
        self.MainFrame = vgui.Create( "DFrame" )
        self.MainFrame:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
        self.MainFrame:SetDeleteOnClose( false )
        self.MainFrame.Paint = nil
        self.MainPanel = vgui.Create("D_cfcmainderma", self.MainFrame)
        self.MainPanel:Dock( FILL )
        self.MainPanel:CopyWidth(  self.MainFrame )
        self.MainFrame:SetVisible( false ) 
        self.MainFrame:SetDraggable( false )
    end

    if self.MainFrame:IsVisible() then
        self.MainFrame:Hide()
        self.MainFrame:SetDraggable( false )
        gui.EnableScreenClicker( false )
    else
        self.MainFrame:Show()
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