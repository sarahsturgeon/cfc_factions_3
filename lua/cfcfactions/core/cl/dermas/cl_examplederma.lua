--if not on client, lets not run this
if not CLIENT then return end

--Our master panel table
local Panel = {}

--Registers the panel to be loaded into the menubar if desired
--change tab_name and index to be desired. index being where you wish the tab to appear

--cfcFactions:RegisterDermaMenu(tab_name, Panel, index)

--main function to init the panel when it is called
function Panel:Init()

end

--Needed to actually register this derma to be used
--vgui.Register('D_cfcexamplederma', Panel)
