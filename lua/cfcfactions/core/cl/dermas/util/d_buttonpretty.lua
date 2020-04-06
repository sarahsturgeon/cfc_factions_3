local PANEL = {}

local animSpeed = 0.2

function PANEL:Init()
    self.animState = 0
    self.bgCol = Color( 0, 0, 255 )
    self.underlineWeight = 1
    self:SetTextColor( Color( 255, 255, 255 ) )
    self:SetBackgroundColor( Color( 255, 255, 255 ) )
end

function PANEL:Think()

    local disabled = self:GetDisabled()
    local tc = self.textCol
    if disabled then
        self:SetCursor( "no" )
        self.BaseClass.SetTextColor( self, Color( 100, 100, 100 ) )
    else
        self:SetCursor( "hand" )
        self.BaseClass.SetTextColor( self, tc )
    end

    local h = self:IsHovered()
    local time = SysTime()
    self.lastT = self.lastT or time
    local change = time - self.lastT
    self.lastT = time
    if change > 1 then change = 0 end -- If there has been > 1 second since last think, dont do the animation
    if h then
        self.animState = math.Clamp( self.animState + change / animSpeed, 0, 1 )
    else
        self.animState = math.Clamp( self.animState - change / animSpeed, 0, 1 )
    end
end

function PANEL:SetTextColor( tc )
    self.BaseClass.SetTextColor( self, tc )
    self.textCol = tc
end

function PANEL:Paint( w, h )
    if self:GetDisabled() then return end

    local tw, _ = self:GetTextSize()
    tw = tw + 6
    local offset = ( w - tw ) / 2
    local s = math.sin( self.animState * ( math.pi / 2 ) )
    local uWeight = self:GetUnderlineWeight()
    surface.SetDrawColor( self:GetBackgroundColor() )
    surface.DrawRect( offset + ( tw * ( 1 - s ) * 0.5 ), h - uWeight - 4, tw * s, uWeight )

end

function PANEL:SetUnderlineWeight( w )
    self.underlineWeight = w
end

function PANEL:GetUnderlineWeight()
    return self.underlineWeight
end

function PANEL:SetBackgroundColor( c )
    self.bgCol = c
end

function PANEL:GetBackgroundColor()
    return self.bgCol
end

function PANEL:SetForceHovered( fh, skipAnim )
    self.forceHovered = fh
    if skipAnim then
        self.animState = fh and 1 or 0
    end
end

function PANEL:IsHovered()
    local w, h = self:GetSize()
    local x, y = self:LocalCursorPos()
    return self.forceHovered or ( x >= 0 and x <= w and y >= 0 and y <= h )
end

vgui.Register( "DButtonPretty", PANEL, "DButton" )