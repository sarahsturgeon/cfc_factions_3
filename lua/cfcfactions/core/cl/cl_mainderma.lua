
-- surface.CreateFont('CFC_Heading', { font = 'Trebuchet24', size = 32 })
-- surface.CreateFont('CFC_Heading1', { font = 'Trebuchet24', size = 24 })
-- surface.CreateFont('CFC_Heading2', { font = 'Trebuchet24', size = 16 })
surface.CreateFont("CFC_Normal", { font = "Arial",size = 18,weight = 500,antialias = true } )
surface.CreateFont("CFC_Special",{ font = "coolvetica",size = 40,weight = 500,antialias = true } )
surface.CreateFont("CFC_Alert", {font="Arial",size=23,weight=100})
local menutabs = {}
local alertPanel = nil

--"View Factions" = {"View Factions", {}}

--Adds the menu bars and handles adding any extras that aren't apart of hard coded items
local function SetupMenuBars(menubar,maincontainer)

		--Sort by ranking
		table.sort(cfcFactions.Dermas, function(a,b) return a.internal_ranking < b.internal_ranking end)
		--loop through tmpsorttable in order to take advantage of the internal ranking of tabs
		for N=1, table.Count(cfcFactions.Dermas) do
			local Entry = cfcFactions.Dermas[N]
			if Entry.internal_button ~= nil then

				--assign a button to a stripped down cleaned name
				Entry.internal_button = vgui.Create("DButton", menubar)
				Entry.internal_button:Dock(LEFT)
				Entry.internal_button:SetText(Entry.internal_name)
				Entry.internal_button:SetWide(#Entry.internal_name*6)
				Entry.internal_button:SetTall(menubar:GetTall()+0.5)

				Entry.internal_button.DoClick = function()
					cfcFactions.CurrentTab = Entry.internal_button
					--cfcFactions.CurrentTab:SetParent()
					--menutabs[3]:SetParent(maincontainer)
					--menutabs[3]:SetVisible(true)
					for K=1, table.Count(cfcFactions.Dermas) do
						local otherbuttons = cfcFactions.Dermas[K]

						--If current tab == button clicked
						if cfcFactions.CurrentTab == otherbuttons.internal_button then
							cfcFactions.CurrentTab:SetEnabled(false)
						else
							otherbuttons.internal_button:SetEnabled(true)
						end
						
					end
					cfcFactions:AddToAlertPanel(string.format("Pressed %s",Entry.internal_name),cfcFactions.Config.MsgType.Msg)
				end
		else
				MsgN("Unable to create a menubar button!")
			end
		end
end


local Panel = {}

--cfcFactions:RegisterDermaMenu("Main Menu", Panel)

function Panel:Init()
	

	self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
	self:SetPos( ( (ScrW() / 2) - (self:GetWide() / 2) ), ((ScrH() / 2) - (self:GetTall() / 2) ) )

	--print("Size: " .. self:GetSize())
	--self:SetTitle( "cfcFactions - Main Menu" )
	-- self:SetVisible(true)
	-- self:SetDraggable(false)
	-- self:ShowCloseButton(true)
	-- self:MakePopup()

	--window buttons
	local closeButton = vgui.Create('DButton', self)
	closeButton:SetFont('CFC_Normal')
	closeButton:SetText('[X]')
	closeButton.Paint = function() end
	closeButton:SetColor(Color(255, 255, 255))
	closeButton:SetSize(32, 32)
	closeButton:SetPos(self:GetWide() - 35, 5)
	closeButton.DoClick = function()
		cfcFactions:DisplayMenu()
	end
	
	--menubar : autoloads elements defined in 
	--	cfcFactions:RegisterDermaMenu(string)
	--		cfcFactions.Dermas
	local menubar = vgui.Create("DPanel", self)
	menubar:DockMargin(0,45,0,0)
	menubar:Dock(TOP)
	menubar:SetSize(self:GetWide() - 0.1, self:GetTall() - 745)
	menubar:SetBackgroundColor(Color(255,0,0,255))
	SetupMenuBars(menubar)


	--Main container
	local container = vgui.Create("DPanel", self)
	container:DockMargin(0, 0, 0, 0)
	container:Dock(TOP)
	container:SetSize(self:GetWide() - 60, self:GetTall() - 150)
	container:SetPos((self:GetWide() / 2) - (container:GetWide() / 2), 120)
	container:SetBackgroundColor(Color(0,0,0,255))

	--Status Bar
	local statusbar = vgui.Create("DPanel", self)
	statusbar:DockMargin(0,0,0,0)
	statusbar:Dock(BOTTOM)
	statusbar:SetSize(self:GetWide(), self:GetTall()-750)
	statusbar:SetBackgroundColor(Color(0,255,0,255))


	--alertbox
	if alertpanel == nil then
		alertPanel = vgui.Create('DPanel', container)
		alertPanel:Dock(TOP)
		alertPanel:SetSize(container:GetWide(),55)
		alertPanel:SetBackgroundColor(Color(0,0,255,255))
	end


	--sub_container
	local subcontainer = vgui.Create("DPanel",container)
	subcontainer:DockMargin(15, 15, 15, 15)
	subcontainer:Dock(TOP)
	subcontainer:SetSize(self:GetWide() - 60, self:GetTall() - 230)
	subcontainer:SetPos((self:GetWide() / 2) - (subcontainer:GetWide() / 2), 120)
	subcontainer:SetBackgroundColor(Color(255,0,255,255))
	


end
function Panel:OnCursorEntered()
	--cfcFactions:AddAlert("Cursor has entered window", cfcFactions.Config.MsgType.Alert)
	cfcFactions:AddToAlertPanel("Cursor has entered window", cfcFactions.Config.MsgType.Alert)
	print("Alerts is now at #" .. table.Count(cfcFactions.Alerts))
end
function Panel:Paint(w, h)
		Derma_DrawBackgroundBlur(self)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 55, 55, 55, 220 ) )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect(0, 0, w, h)

		--surface.DrawOutlinedRect(0, 0, w, h)
		draw.SimpleText(string.format("cfcFactions - %s",LocalPlayer():Nick()), "CFC_Special", 5, 5, color_white)
		draw.RoundedBox(0.1, 0, 40, (w-1), 0.5, color_white )	
end
function Panel:Think()

end

function cfcFactions:ClearAlerts()
	if alertPanel == nil then return end
	if #alertPanel:GetChildren() == 0 then return end
	for _,panel in pairs(alertPanel:GetChildren()) do
		panel:Remove()
	end
end


function cfcFactions:AddToAlertPanel(msg, type)

	if alertPanel == nil then return end
	if #alertPanel:GetChildren() > 0 then cfcFactions:ClearAlerts() end
	local Alert = vgui.Create("D_cfcalertboxpanel", alertPanel)
	Alert.ErrMsg:SetText(msg)
	Alert.ErrMsg:SetColor(cfcFactions.Config.MsgType[type])
	Alert:Dock(FILL)




end


vgui.Register('D_cfcmainderma', Panel)



hook.Add("CFC_FAC_AlertAdded",function(msg,type)
	print("HOOK! Alert Reported")
	cfcFactions:AddToAlertPanel(msg, type)
end)







