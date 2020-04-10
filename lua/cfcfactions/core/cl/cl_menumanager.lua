function cfcFactions:CreateMenu()
    self.MainFrame = vgui.Create( "DFrame" )
    self.MainFrame:SetSize( math.Clamp( 800, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
    self.MainFrame:SetDeleteOnClose( false )
    self.MainFrame:Center()
    self.MainFrame.Paint = nil

    self.MainPanel = vgui.Create( "D_cfcmainderma", self.MainFrame )
    self.MainPanel:Dock( FILL )
    self.MainFrame:SetVisible( false )
    self.MainFrame:SetDraggable( false )
end

local function _ShowMenu( self )
    local success, data = await( cfcFactions.api.GetPlayer( LocalPlayer():GetFactionsID() ) )
    if not success then return end

    cfcFactions.localUserData = data[1]

    local doOnShow = true
    if not self.MainFrame then
        cfcFactions:CreateMenu()
        doOnShow = false
    end

    self.MainFrame:Show()
    self.MainFrame:SetDraggable( true )
    gui.EnableScreenClicker( true )

    if doOnShow and self.MainPanel:GetSelectedPanel().OnShow then
        self.MainPanel:GetSelectedPanel():OnShow()
    end
end

cfcFactions.ShowMenu = async( _ShowMenu )

function cfcFactions:HideMenu()
    self.MainFrame:Hide()
    self.MainFrame:SetDraggable( false )
    gui.EnableScreenClicker( false )
end

function cfcFactions:ToggleMenu( force )
    if self.MainFrame:IsVisible() then
        cfcFactions:HideMenu()
    else
        cfcFactions:ShowMenu()
    end
end

net.Receive( "CFC_Fac_ToggleDerma", function( length )
    cfcFactions:ToggleMenu()
end )

local function _OpenMenu()
    local success, value = await( NP.net.send( "CFC_Fac_OpenMenu" ) )

    if not success then return end

    if not value then return end

    -- Escape the call from async, so errors are clearer - Not needed anymore? Test without it
    timer.Simple( 0, function()
        cfcFactions:ShowMenu()
    end )
end

cfcFactions.OpenMenu = async( _OpenMenu )

local lastCall = 0
hook.Add( "PlayerButtonDown", "CFC_Fac_MenukeyDown", function( player, button )
    local cTime = CurTime()
    if button == cfcFactions.Config.MenuKey and cTime - lastCall > 0.1 then
        cfcFactions:OpenMenu()
    end
    lastCall = cTime
end )

hook.Add( "OnPlayerChat", "CFC_Fac_SayMenuCommand", function( ply, text )
    if ply == LocalPlayer() and string.StartWith( text:lower(), cfcFactions.Config.ChatCommand ) then
        cfcFactions:OpenMenu()
    end
end )

