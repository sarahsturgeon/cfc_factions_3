--Alert box to display realtime alerts/messages to users apart of cfcfactions
local Panel = {}

local ErrMsg = nil
local ErrType = nil
local AlertInc = 0
function Panel:Init()


	if not type(msgtype) == "table" then msgtype = cfcFactions.Config.MsgType.Msg end

	local MiniPanel = vgui.Create("DPanel",self)
	

	self.err_icon = vgui.Create( "DImage",MiniPanel)	-- Add image to Frame
	self.err_icon:SetPos( 10, 35 )	-- Move it into frame
	self.err_icon:SetSize( 555, 150 )	
	self.err_icon:Dock(FILL)

	self.ErrMsg = vgui.Create("DLabel",MiniPanel)
	self.ErrMsg:Dock(FILL)
	self.ErrMsg:SetColor(msgtype and msgtype ~= nil or Color(255,0,0))
	self.ErrMsg:SetText(msg and msg ~= nil or cfcFactions.ErrorTypes[0])
	self.CreationTime = CurTime()
	MiniPanel:SetWide(#self.ErrMsg:GetText()*6)

end
function Panel:Paint()
	if CurTime() >= self.CreationTime + 5 then self.CreationTime = CurTime()  self:Remove() else return end
	AlertInc = AlertInc +1

end

--ui/chat_display_text.wav
vgui.Register('D_cfcalertboxpanel', Panel)



