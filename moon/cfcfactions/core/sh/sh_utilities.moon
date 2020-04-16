cfcFactions.colorToInt = ( c ) ->
    ( bit.lshift c.r, 16 ) + ( bit.lshift c.g, 8 ) + c.b

cfcFactions.intToColor = ( n ) ->
    Color ( bit.band ( bit.rshift n, 16 ), 0xFF ),
          ( bit.band ( bit.rshift n, 8 ), 0xFF ),
          ( bit.band n, 0xFF ),
          255

table.map = ( tab, f ) ->
    { k, f v for k, v in pairs tab }

table.filter = ( tab, f ) ->
    { k, v for k, v in pairs tab when f v }

table.mapFilter = ( tab, f ) ->
    out = {}
    for k, v in pairs tab
        val = f v
        if val ~= nil then table.insert out, val
    out

table.all = ( tab ) ->
    for k, v in pairs tab
        return false if not v
    true

table.any = ( tab ) ->
    for k, v in pairs tab
        return true if v
    false

table.reduce = ( tab, f, start ) ->
    total = start
    table.map tab, ( x ) ->
        total = f total, x
    total

table.head = ( tab ) ->
    return tab[1]

table.tail = ( tab ) ->
    tabCopy = table.Copy tab
    table.remove tabCopy, 1
    tabCopy