local Panel = {}

local function addUserInfo( listView, data )
    --[[ 
    local plyName = data.name
    local plyRank = data.rank
    local plyKD = data.kd
    local plyFacJoin = data.join
    
    listView:AddLine( plyName, plyRank, plyKD, plyFacJoin )
    ]]
end

function Panel:Init()
    self:SetSize( 500, 500 )
    self:SetPos( ( ( ScrW() / 2 ) - ( self:GetWide() / 2 ) ), ( ( ScrH() / 2 ) - ( self:GetTall() / 2 ) ) )
    
    --remove frame after submission
    local f = vgui.Create( "DFrame", self )
    f:SetDraggable( false )
    f:Dock( FILL )
    f:MakePopup()
    
    local lview = vgui.Create( "DListView", f )
    lview:Dock( FILL )
    lview:SetSortable( false )
    lview:AddColumn( "Player" ):SetMinWidth( 50 )
    lview:AddColumn( "Rank" ):SetFixedWidth( 70 )
    lview:AddColumn( "K/D" ):SetFixedWidth( 50 )
    lview:AddColumn( "Member Since" ):SetMinWidth( 50 )
    
    --[[
    for _, member in pairs( faction.users ) do
        addUserInfo( lview, ... )
    end
    ]]
end

vgui.Register("D_cfcfactionusers", Panel)