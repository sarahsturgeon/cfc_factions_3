surface.CreateFont("CFC_Normal", { font = "Arial",size = 18,weight = 500,antialias = true } )
surface.CreateFont("CFC_Special",{ font = "coolvetica",size = 40,weight = 500,antialias = true } )
surface.CreateFont("CFC_Alert", {font="Arial",size=23,weight=100})

local cfg = cfcFactions.Config.Client
local Panel = {}
local menutabs = {}

--local self.mainview = nil
--"View Factions" = {"View Factions", {}}

--Adds the menu bars and handles adding any extras that aren't apart of hard coded items
function Panel:SetupMenubars(menubar)

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

					for K=1, table.Count(cfcFactions.Dermas) do
						local otherbuttons = cfcFactions.Dermas[K]

						--If current tab == button clicked
						if cfcFactions.CurrentTab == otherbuttons.internal_button then
							cfcFactions.CurrentTab:SetEnabled(false)
						else
							otherbuttons.internal_button:SetEnabled(true)
						end
						
					end
					

					--[[
						Logic to handle showing the Panel table to subself.container to view, use and interact with the client
						Should be parented and docked. Clicking on another tab will reset this view
					]]--
					self:SetMainView(Entry.internal_panel)
				end
		else
				MsgN("Unable to create a self.menubar button!")
			end
		end
end




--cfcFactions:RegisterDermaMenu("Main Menu", Panel)

function Panel:Init()
	

	self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ) )
	self:SetPos( ( (ScrW() / 2) - (self:GetWide() / 2) ), ((ScrH() / 2) - (self:GetTall() / 2) ) )

	--print("Size: " .. self:GetSize())
	--self:SetTitle( "cfcFactions - Main Menu" )
	-- self:SetVisible(true)
	-- self:SetDraggable(false)
	-- self:Showself.closeButton(true)
	-- self:MakePopup()

	--window buttons
	self.closeButton = vgui.Create('DButton', self)
	self.closeButton:SetFont('CFC_Normal')
	self.closeButton:SetText('[X]')
	self.closeButton.Paint = function() end
	self.closeButton:SetColor(Color(255, 255, 255))
	self.closeButton:SetSize(32, 32)
	self.closeButton:SetPos(self:GetWide() - 35, 5)
	self.closeButton.DoClick = function()
		cfcFactions:DisplayMenu()
	end
	
	--self.menubar : Contains the autoloaded elements defined in 
	--	cfcFactions:RegisterDermaMenu(string)
	--		cfcFactions.Dermas
	self.menubar = vgui.Create("DPanel", self)
	self.menubar:DockMargin(0,45,0,0)
	self.menubar:Dock(TOP)
	self.menubar:SetSize(self:GetWide() - 0.1, self:GetTall() - 745)
	self.menubar:SetBackgroundColor(Color(44, 62, 80,200))

	--Load the registered dermas into the menubar
	self:SetupMenubars(self.menubar)


	--Main self.container
	self.container = vgui.Create("DPanel", self)
	self.container:DockMargin(0, 0, 0, 0)
	self.container:Dock(TOP)
	self.container:SetSize(self:GetWide() - 60, self:GetTall() - 150)
	self.container:SetPos((self:GetWide() / 2) - (self.container:GetWide() / 2), 120)
	self.container:SetBackgroundColor(Color(0,0,0,0))

	--Status Bar
	self.statusbar = vgui.Create("DPanel", self)
	self.statusbar:DockMargin(0,0,0,0)
	self.statusbar:Dock(BOTTOM)
	self.statusbar:SetSize(self:GetWide(), self:GetTall()-750)
	self.statusbar:SetBackgroundColor(Color(0,0,0,0))


	--alertbox
	if self.alertPanel == nil then
		self.alertPanel = vgui.Create('DPanel', self.container)
		self.alertPanel:Dock(TOP)
		self.alertPanel:SetSize(self.container:GetWide(),55)
		self.alertPanel:SetBackgroundColor(Color(0,0,0,0))
	end


	--sub_self.container
	self.mainview = vgui.Create("DPanel",self.container)
	self.mainview:DockMargin(15, 15, 15, 15)
	self.mainview:Dock(TOP)
	self.mainview:SetSize(self:GetWide() - 60, self:GetTall() - 230)
	self.mainview:SetPos((self:GetWide() / 2) - (self.mainview:GetWide() / 2), 120)
	self.mainview:SetBackgroundColor(Color(0,0,0,0))
		--set main view to whatever the first menubar item is
	if cfcFactions.Dermas[1].internal_panel ~= nil then
		self:SetMainView(cfcFactions.Dermas[1].internal_panel)
		--cfcFactions.Dermas[1].internal_button:SetToggle(true)
		cfcFactions.Dermas[1].internal_button:SetEnabled(false)
	end

	--Debug Status
	self.StatusLabel = vgui.Create("DLabel", self.statusbar)
	self.StatusLabel:Dock(RIGHT)
	self.StatusLabel:SetText("Online")
end


function Panel:Paint(w, h)
		Derma_DrawBackgroundBlur(self)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 55, 55, 55, 220 ) )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect(0, 0, w, h)

		--surface.DrawOutlinedRect(0, 0, w, h)
		draw.SimpleText(string.format(cfg.DermaHeaderTitle,LocalPlayer():Nick()), "CFC_Special", 5, 5, cfg.ColorSchemes.HeaderText)	
end
function Panel:Think()

end

function Panel:ClearAlerts(panel)
	if self.alertPanel == nil then return end
	if #self.alertPanel:GetChildren() == 0 then return end
	for _,panel in pairs(self.alertPanel:GetChildren()) do
		panel:Remove()
	end
end

function Panel:SetMainView(panel)
	--fetch children first

	for k, v in pairs(self.mainview:GetChildren()) do
		v:Clear()
	end

	local mview = vgui.CreateFromTable(panel, self.mainview,nil)
	mview:SetSize(self.mainview:GetWide(), self.mainview:GetTall())
end

function Panel:AddAlert(msg, type)

	if self.alertPanel == nil then return end
	if #self.alertPanel:GetChildren() > 0 then cfcFactions:ClearAlerts() end
	local Alert = vgui.Create("D_cfcalertboxpanel", self.alertPanel)
	Alert.ErrMsg:SetText(msg)
	Alert.ErrMsg:SetColor(cfcFactions.Config.MsgType[type])
	Alert:Dock(FILL)




end


vgui.Register('D_cfcmainderma', Panel)











