local PANEL = {}
local cfg = cfcFactions.Config.ColorSchemes

function PANEL:Init()
    self.tabBar = vgui.Create( "DPanel", self )
    self.tabBar:Dock( TOP )
    self.tabBar:SetTall( 30 )
    self.tabBar:SetBackgroundColor( cfg.InlineHeaderPanel )
    self.tabBar.prevTime = 0
    self.animSpeed = 0

    local pSheet = self
    function self.tabBar:Paint( w, h )
        surface.SetDrawColor( self:GetBackgroundColor() )
        surface.DrawRect( 0, 0, w, h )

        if #pSheet.tabs == 0 then return end

        local curTime = SysTime()
        local deltaTime = curTime - self.prevTime
        self.prevTime = curTime

        if deltaTime > 0.5 then deltaTime = 0 end

        if pSheet.animState ~= pSheet.targetAnimState then
            local animChange = deltaTime * pSheet.animSpeed
            if pSheet.targetAnimState < pSheet.animState then
                pSheet.animState = math.Clamp( pSheet.animState - animChange, pSheet.targetAnimState, 1 )
            else
                pSheet.animState = math.Clamp( pSheet.animState + animChange, 0, pSheet.targetAnimState )
            end
        end

        surface.SetDrawColor( cfg.MiniPanelHeader )
        surface.DrawRect( 6 + pSheet.animState * w, h - 5, ( w / #pSheet.tabs ) - 12, 2 )

        for k = 1, #pSheet.tabs - 1 do
            local offset = k * w / #pSheet.tabs
            surface.SetDrawColor( cfg.InlinePanelSeparater )
            surface.DrawRect( offset, 5, 1, h - 9 )

            surface.SetDrawColor( self:GetBackgroundColor() )
            surface.DrawRect( offset - 6, h - 5, 12, 2 )
        end
    end

    self.container = vgui.Create( "DPanel", self )
    self.container.Paint = nil
    self.container:Dock( FILL )

    self.tabs = {}
    self.selectedTabIdx = false
    self.animState = 0
    self.targetAnimState = 0
end

function PANEL:AddSheet( tabName, panel )
    if not self.selectedTabIdx then
        self.selectedTabIdx = 1
    end
    local btn = vgui.Create( "DButton", self.tabBar )
    btn:SetText( tabName )
    btn:SetTextColor( cfg.NormalText )
    btn:SetFont( "CFC_Normal_Bold18" )
    btn:Dock( LEFT )
    btn.Paint = nil
    btn.psheet = self
    btn.idx = #self.tabs + 1
    function btn:PerformLayout()
        local w = self.psheet:GetWide()
        self:SetWide( w / #self.psheet.tabs )
    end
    function btn:DoClick()
        self.psheet:SelectTabIdx( self.idx )
    end

    panel:SetVisible( #self.tabs == 0 )
    if #self.tabs == 0 and panel.OnSelect then
        panel:OnSelect()
    end

    panel:SetParent( self.container )
    panel:Dock( FILL )
    table.insert( self.tabs, { name = tabName, panel = panel, button = btn } )
end

function PANEL:SelectTabIdx( idx )
    if idx > #self.tabs then return end
    if idx == self.selectedTabIdx then return end

    self.targetAnimState = ( 1 / #self.tabs ) * ( idx - 1 )

    local prevData = self.tabs[self.selectedTabIdx]
    local change = idx - self.selectedTabIdx
    self.selectedTabIdx = idx

    self.animSpeed = 5 * ( math.abs( change ) / #self.tabs )
    local newData = self.tabs[idx]

    local prevPanel = prevData.panel
    local newPanel = newData.panel

    if prevPanel.OnDeselect then
        prevPanel:OnDeselect( newData )
    end

    if newPanel.OnSelect then
        newPanel:OnSelect( prevData )
    end

    if self.OnChangeTab then
        self:OnChangeTab( prevData, newData )
    end

    prevPanel:Show()
    newPanel:Show()

    prevPanel:SetAlpha( 255 )
    newPanel:SetAlpha( 0 )
    prevPanel:AlphaTo( 0, 0.2 )
    newPanel:AlphaTo( 255, 0.2 )
    timer.Simple( 0.2, function()
        prevPanel:Hide()
        newPanel:Show()
        newPanel:SetAlpha( 255 )
    end )
end

function PANEL:SelectTab( tabName )
    for k, tabData in pairs( self.tabs ) do
        if tabData.name == tabName then
            self:SelectTabIdx( k )
            return
        end
    end
end

function PANEL:GetSelectedTab()
    return self.tabs[self.selectedTabIdx]
end

function PANEL:GetSelectedPanel()
    return self:GetSelectedTab().panel
end

function PANEL:Clear()
    self.tabBar:Clear()
    self.container:Clear()
    self.tabs = {}
    self.selectedTabIdx = false
end

vgui.Register( "DPropertySheetPretty", PANEL )
