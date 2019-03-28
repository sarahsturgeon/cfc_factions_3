cfcFactions.Dermas = {}
cfcFactions.Alerts = {}
cfcFactions.Logs = {}
cfcFactions.IsOpen = false
cfcFactions.MainDerma = nil
cfcFactions.CurrentTab = nil
cfcFactions.News = ""

--Registers items to be placed into the menubar at loadtime
--TODO: possibly rework cl_init so this is completely clientside
function cfcFactions:RegisterDermaMenu(name, panel, ranking)
    if not CLIENT then return end

    if name == nil then name = "No Text Set" end
    if panel == nil then panel = {} end
    if ranking == nil then ranking = 99 end
    table.insert(cfcFactions.Dermas, {
        internal_name=name, internal_panel=panel, internal_ranking=ranking, internal_button={}
    })
end

function cfcFactions:AddAlert(msg, mtype)
    if mtype == nil then mtype = MsgType.Msg end
    table.insert(cfcFactions.Alerts, {["Message"]=msg, ["Type"]=mtype, ["Time"]=os.date( "%T ", os.time() )})
    cfcFactions:AddToAlertPanel(msg, mtype)
    hook.Call("CFC_FAC_AlertAdded", _, msg, mtype)
end

--Displays and handles closing (an already open) menu derma. 
function cfcFactions:DisplayMenu()
    if not cfcFactions.MainDerma or cfcFactions.MainDerma == nil then
        cfcFactions.MainDerma = vgui.Create("D_cfcmainderma")
        cfcFactions.MainDerma:SetVisible(false)
    end

    if not cfcFactions.MainDerma:IsVisible() then
        cfcFactions.MainDerma:ClearAlerts()
        cfcFactions.MainDerma:Show()
        gui.EnableScreenClicker(true)
    else
        cfcFactions.MainDerma:Hide()
        gui.EnableScreenClicker(false)
    end 
end

--If the defined key is properly set, users can use that specific key to also open/close the derma
local function menuKeyDown(ply, button)
	if input.GetKeyName(button) == cfcFactions.Config.CLIENT_KEY then
        cfcFactions:DisplayMenu()
    end
end

hook.Add("PlayerButtonDown", "CFC_FAC_MENUKEYDOWN", menuKeyDown)

--If a user requests to display the derma from serverside
local function toogleDerma(len, ply)

end

net.Receive('CFC_Fac_ToggleDerma', toogleDerma)

local function sendMessage(len, ply)

end

net.Receive('CFC_Fac_SendMessage', sendMessage)

local function sendServerTextAlert(len, ply)
	local msg = net.ReadString()
    local mtype = net.ReadInt(4)
    local ment = net.ReadEntity()

    if cfcFactions.MainDerma ~= nil then
        cfcFactions.MainDerma:CreateAlert(msg, mtype)
    end
end

net.Receive('CFC_Fac_SendServerTextAlert', sendServerTextAlert)
