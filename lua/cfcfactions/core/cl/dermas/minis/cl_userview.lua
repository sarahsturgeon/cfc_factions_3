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