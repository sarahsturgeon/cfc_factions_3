-- Thanks Acecool and HandsomeMatt for your code

local function GenerateCircle( radius )
    local seg = 50
    local cir = {}

    for i = 1, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = radius / 2 + math.sin( a ) * radius * 0.5, y = radius / 2 + math.cos( a ) * radius * 0.5, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    return cir
end

local _material = Material( "effects/flashlight001" );

local borderWidth = 3

local PANEL = {}

function PANEL:Init()
    self.outlineColor = Color( 255, 255, 255 )
    self.Image = vgui.Create( "DImage", self )
    self.Image:SetPaintedManually( true )
    self.Image:Dock( FILL )
    self:UpdatePoly()
end

function PANEL:UpdatePoly()
    self.poly = GenerateCircle( self:GetWide() )
    self.innerPoly = GenerateCircle( self:GetWide() - borderWidth * 2 )
end

function PANEL:OnSizeChanged()
    self:SetSize( self:GetWide(), self:GetWide() )
    self:UpdatePoly()
end

function PANEL:PerformLayout()
    self.Image:SetSize( self:GetWide(), self:GetTall() )
end

function PANEL:Paint( w, h )
    local imagePoly = self.poly
    if self.doDrawOutline then
        draw.NoTexture()
        surface.SetDrawColor( self.outlineColor )
        surface.DrawPoly( self.poly )
        imagePoly = self.innerPoly
    end

    render.ClearStencil()
    render.SetStencilEnable( true )

    render.SetStencilWriteMask( 1 )
    render.SetStencilTestMask( 1 )

    render.SetStencilFailOperation( STENCIL_REPLACE )
    render.SetStencilPassOperation( STENCIL_ZERO )
    render.SetStencilZFailOperation( STENCIL_ZERO )
    render.SetStencilCompareFunction( STENCIL_NEVER )
    render.SetStencilReferenceValue( 1 )

    draw.NoTexture( );
    surface.SetMaterial( _material )
    surface.SetDrawColor( color_black )

    local mat = Matrix()
    if self.doDrawOutline then
        mat:Translate( Vector( 3, 3 ) )
    end
    cam.PushModelMatrix( mat )
    surface.DrawPoly( imagePoly )
    cam.PopModelMatrix()


    render.SetStencilFailOperation( STENCIL_ZERO )
    render.SetStencilPassOperation( STENCIL_REPLACE )
    render.SetStencilZFailOperation( STENCIL_ZERO )
    render.SetStencilCompareFunction( STENCIL_EQUAL )
    render.SetStencilReferenceValue( 1 )

    self.Image:SetPaintedManually( false )
    self.Image:PaintManual()
    self.Image:SetPaintedManually( true )

    render.SetStencilEnable( false )
    render.ClearStencil()
end

function PANEL:SetDrawOutline( drawOutline )
    self.doDrawOutline = drawOutline
end

function PANEL:SetOutlineColor( col )
    self.outlineColor = col
end

function PANEL:SetImage( img )
    self.Image:SetImage( img )
end

vgui.Register( "DImageCircle", PANEL )


