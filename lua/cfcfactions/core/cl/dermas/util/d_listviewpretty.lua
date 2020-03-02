local PANEL = {}
local cfg = ColorSchemes

-- Simple table mapping function, apply f to every element in tab
function table.map( tab, f )
    local out = {}
    for k, v in pairs( tab ) do
        out[k] = f( v )
    end
    return out
end

function table.reduce( tab, f, start )
    local total = start
    table.map( tab, function( x )
        total = f( total, x )
    end )
    return total
end

function PANEL:Init()
    self.Paint = nil
    local VBar = self.VBar
    VBar:SetHideButtons( true )
    VBar.Paint = nil
end

-- Copied directly from dlistview, only changed the line vgui element
function PANEL:AddLine( ... )

    self:SetDirty( true )
    self:InvalidateLayout()

    local Line = vgui.Create( "DListViewPretty_Line", self.pnlCanvas )
    local ID = table.insert( self.Lines, Line )

    Line:SetListView( self )
    Line:SetID( ID )

    -- This assures that there will be an entry for every column
    for k, v in pairs( self.Columns ) do
        Line:SetColumnText( k, "" )
    end

    for k, v in pairs( {...} ) do
        Line:SetColumnText( k, v )
    end

    -- Make appear at the bottom of the sorted list
    local SortID = table.insert( self.Sorted, Line )

    if ( SortID % 2 == 1 ) then
        Line:SetAltLine( true )
    end

    return Line
end

-- Again copied to change single value :(
function PANEL:DataLayout()

    local y = 0
    local h = self.m_iDataHeight
    for k, Line in ipairs( self.Sorted ) do

        Line:SetPos( 1, y )
        Line:SetSize( self:GetWide() - self.VBar:GetWide() - 3, h )
        Line:DataLayout( self )

        Line:SetAltLine( k % 2 == 1 )

        y = y + Line:GetTall()

    end

    return y
end

-- Again
function PANEL:PerformLayout()

    -- Do Scrollbar
    local Wide = self:GetWide()
    local YPos = 0

    if ( IsValid( self.VBar ) ) then

        self.VBar:SetPos( self:GetWide() - 4, 0 )
        self.VBar:SetSize( 4, self:GetTall() )
        self.VBar:SetUp( self.VBar:GetTall() - self:GetHeaderHeight(), self.pnlCanvas:GetTall() )
        YPos = self.VBar:GetOffset()

        if ( self.VBar.Enabled ) then Wide = Wide - 4 end

    end

    if ( self.m_bHideHeaders ) then
        self.pnlCanvas:SetPos( 0, YPos )
    else
        self.pnlCanvas:SetPos( 0, YPos + self:GetHeaderHeight() )
    end

    self.pnlCanvas:SetSize( Wide, self.pnlCanvas:GetTall() )

    self:FixColumnsLayout()

    --
    -- If the data is dirty, re-layout
    --
    if ( self:GetDirty() ) then

        self:SetDirty( false )
        local y = self:DataLayout()
        self.pnlCanvas:SetTall( y )

        -- Layout again, since stuff has changed..
        self:InvalidateLayout( true )

    end

end

function PANEL:OnMousePressed( key )
    if key == MOUSE_LEFT then
        self:ClearSelection()
    end
end

function PANEL:ClearSelection()
    self.BaseClass.ClearSelection( self )
    self:OnRowSelected()
end

-- Add multiple columns
function PANEL:AddColumns( columns, columnSizes )
    self.columnSizes = columnSizes
    table.map( columns, function( x ) self:AddColumn( x ) end )

    local nilCount = 0
    local sum = table.reduce( self.columnSizes, function( a, b )
        if b then
            return a + b
        else
            nilCount = nilCount + 1
            return a
        end
    end, 0 )
    self.relativeSizeColumns = nilCount
    self.totalColumnWidths = sum
end

function PANEL:OnSizeChanged( w, h )

    if not self.columnSizes then return end

    local remainingWidth = w - self.totalColumnWidths

    for k, v in ipairs( self.Columns ) do
        if self.columnSizes[k] then
            v:SetWidth( self.columnSizes[k] )
        else
            v:SetWidth( remainingWidth / self.relativeSizeColumns )
        end
    end
end

vgui.Register( "DListViewPretty", PANEL, "DListView" )

local LINE = {}

function LINE:AddColumn( ... )
    local column = self.BaseClass.AddColumn( self, ... ) -- Can't use ":" here due to BaseClass :(
    local btn = column.Header

    btn.Paint = nil -- ?

    return column
end

-- Height refuses to change unless I use BOTH of these
-- Not sure why SetTall is needed when GetTall is overridden
-- TODO: make this less gross
function LINE:PerformLayout()
    self:SetTall( 30 )
end
function LINE:GetTall()
    return 30
end

function LINE:Paint( w, h )
    if self:IsSelected() then
        surface.SetDrawColor( cfg.BackgroundButton )
    else
        surface.SetDrawColor( self.alt and cfg.InlineHeaderPanel or cfg.BackgroundPanel )
    end
    surface.DrawRect( 0, 0, w, h )
end

function LINE:SetAltLine( alt )
    self.alt = alt
end

function LINE:SetColumnText( ... )
    local label = self.BaseClass.SetColumnText( self, ... ) -- Can't use ":" here due to BaseClass :(
    label:SetTextColor( Color( 255, 255, 255 ) )
    label:SetFont( "CFC_Normal" )
    label:SizeToContents()
    function label:Paint( w, h )
        surface.SetDrawColor( cfg.InlinePanelSeparater )
        surface.DrawRect( 0, 1, 1, h-2 )
        surface.DrawRect( w-1, 1, 1, h-2 )
    end
    return label
end

vgui.Register( "DListViewPretty_Line", LINE, "DListView_Line" )