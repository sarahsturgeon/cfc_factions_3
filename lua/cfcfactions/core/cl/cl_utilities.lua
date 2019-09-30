local cfcFactions = cfcFactions or {}
if not CLIENT then return end

--Used to clean a string in order to properly use it as a 
--dynamic variable name
function cfcFactions:SanitizeLuaVariableName( inputstring )
    if inputstring == nil then return "" end
    local tmp = ""

    for k=1, #inputstring do
        tmp = string.Replace(inputstring, " ", "_")
    end
    return string.lower( tmp )
end

--Resizes all buttons inside a parent equally (Highest text length is what is used to determine all button's size)
--Modifier adds onto size for a fixed amount 
function cfcFactions:ResizeChildrenEqually(parent, modifer)
    local mulmod = modifer and modifer or 0
    local MaxSize = 0
    if parent ~= nil and parent:HasChildren() then
        for k, babypanel in pairs( parent:GetChildren() ) do
            
            if babypanel:GetClassName() == "Label" then
                --print(string.format("Looping on: %s with size of %s",babypanel:GetText(), #babypanel:GetText( )) )
                if #babypanel:GetText() > MaxSize then
                    MaxSize = ( ( #babypanel:GetText() ) * mulmod )
                end
                --print( MaxSize )
                babypanel:SetWide( MaxSize )
            end
        end
    end
end

--Resizes a parent based on total size of children
function cfcFactions:ResizeParentFromChildren( parent )
    local MaxSize = 0
    if parent ~= nil and parent:HasChildren() then
        for k, babypanel in pairs( parent:GetChildren() ) do
            MaxSize = MaxSize + ( babypanel:GetWide() )
        end
    end

    parent:SetWide( MaxSize )
end
