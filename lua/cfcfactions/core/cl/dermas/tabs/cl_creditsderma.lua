if not CLIENT then return end

local PANEL = {}

function PANEL:Init()
    self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
    self.MainContainer = vgui.Create( "DPanel", self )
    self.MainContainer:Dock( FILL )
    self.TextBox = vgui.Create( "DLabel", self.MainContainer )
    self.TextBox:Dock( FILL )
    local Credits = cfcFactions.Credits.GenerateDeveloperNames()
    local TextBlock = ""
    for KEY, Developer in pairs( Credits ) do
        TextBlock = TextBlock .. ( Developer .. "( " .. KEY .. " )\n" )
    end
    self.TextBox:SetText( TextBlock )
    self.TextBox:SetColor( Color( 0, 0, 0, 255 ) )

end

function PANEL:Paint( w, h )

end

function PANEL:Think()

end

vgui.Register( 'D_cfccreditssderma', PANEL )