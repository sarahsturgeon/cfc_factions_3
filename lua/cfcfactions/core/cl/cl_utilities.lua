local cfcFactions = cfcFactions or {}
if not CLIENT then return end

local function isValidParent( parent )
    if parent == nil then return false end
    if ~parent:HasChildren() then return false end

    return true
end

local function isInvalidParent( parent )
    return ~isValidParent( parent )
end

--Used to clean a string in order to properly use it as a 
--dynamic variable name
function cfcFactions:SanitizeLuaVariableName(inputstring)
    if inputstring == nil then return "" end

    local ret = ""
    for k = 1, #inputstring do
        ret = string.Replace( inputstring, " ", "_" )
    end

    ret = string.lower( ret )

    return ret
end

--Resizes all buttons inside a parent equally (Highest text length is what is used to determine all button's size)
--Modifier adds onto size for a fixed amount 
function cfcFactions:ResizeChildrenEqually(parent, modifer)
    local mulmod = modifer and modifer or 0
    local MaxSize = 0
    
    if isInvalidParent( parent ) then return end

    for _, babypanel in pairs( parent:GetChildren() ) do
        if babypanel:GetClassName() == "Label" then    
            local textLength = #babyPanel:GetText()

            -- What happens if mulmod ends up being 0? Will MaxSize remain 0?
            if textLength > MaxSize then MaxSize = textLength * mulmod end

            babypanel:SetWide( MaxSize )
        end
    end
end

--Resizes a parent based on total size of children
function cfcFactions:ResizeParentFromChildren(parent)
    local MaxSize = 0

    if isInvalidParent( parent ) then return end

    for k, babypanel in pairs(parent:GetChildren()) do
        MaxSize = MaxSize + (babypanel:GetWide())
    end

    parent:SetWide(MaxSize)
end

function cfcFactions:createDermaItem(dtype, parent, arg)
    if dtype == nil then return end

    local item = vgui.Create( dtype, parent )
    
    if arg.text   then item:SetText( arg.text ) end
    if arg.dock   then item:Dock( arg.dock ) end
    if arg.color  then item:SetBackgroundColor( arg.color ) end
    if arg.inval  then item:InvalidateParent( arg.inval ) end
    if arg.margin then item:SetDockMargin( arg.margin ) end
    if arg.tall   then item:SetTall( arg.tall ) end
    if arg.wide   then item:SetWide( arg.wide ) end
    if arg.font   then item:SetFOnt( arg.font ) end

    return item
end

function cfcFactions:createDPanel(parent, arg)
    return createDermaItem( "DType", parent, arg )
end

function cfcFactions:createDButton(parent, arg)
    return createDermaItem( "DButton", parent, arg )
end

function cfcFactions:createDListView(parent, arg)
    return createDermaItem( "DListView", parent, arg )
end

function cfcFactions:createDLabel(parent, arg)
    return createDermaItem( "DLabel", parent, arg )
end
