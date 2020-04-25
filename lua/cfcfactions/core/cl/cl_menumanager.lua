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
    local doOnShow = true
    if not self.MainFrame then
        cfcFactions:CreateMenu()
        doOnShow = false
    end

    self.MainFrame:Show()
    self.MainFrame:SetDraggable( true )
    gui.EnableScreenClicker( true )

    self.MainPanel:HidePanel()

    local success, data = awaitSpinner( self.MainPanel, cfcFactions.api.GetPlayer( LocalPlayer():GetFactionsID() ) )
    if not success then return end

    cfcFactions.localUserData = data[1]

    self.MainPanel:ShowPanel( doOnShow )

    if not doOnShow then
        self.MainPanel:TriggerTabAdding()
    end
end

cfcFactions.ShowMenu = async( _ShowMenu )

function cfcFactions:HasPermission( factionID, perm )
    if not cfcFactions.localUserData then return false end

    if cfcFactions.localUserData.faction.id == factionID then
        return table.hasMember( cfcFactions.localUserData.permissions, "name", perm )
    else
        return LocalPlayer():IsAdmin()
    end
end

function cfcFactions:HideMenu()
    self.MainFrame:Hide()
    self.MainFrame:SetDraggable( false )
    gui.EnableScreenClicker( false )
end

function cfcFactions:ReloadMenu()
    self.MainFrame:Remove()
    self.MainFrame = nil
    self.MainPanel = nil

    self:ShowMenu()
end

function cfcFactions:ToggleMenu()
    if self.MainFrame and self.MainFrame:IsVisible() then
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
    cfcFactions:ShowMenu()
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

