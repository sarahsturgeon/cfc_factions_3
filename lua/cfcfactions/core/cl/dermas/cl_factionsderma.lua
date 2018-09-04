if not CLIENT then return end

cfcFactions.FactionsView = nil

local Panel = {}

cfcFactions:RegisterDermaMenu("View Factions", Panel, 1)


local function addFactions(panel, locked, name, description, owner, kd, id)
	--no need to constantly add to the view if factions remains the same
	local tmpLock
	if locked == 1 then
		--tmpLock = vgui.Create("DImage", panel)
		tmpLock = "L"
	else 
		tmpLock = ""
	end

	panel.Factionsview:AddLine(tmpLock, name, description, owner, kd, id)
	panel.Factionsview:DataLayout()
end

function Panel:Init()
	cfcFactions.FactionsView=1
	self:SetSize(math.Clamp( 1024, 0, ScrW() ), math.Clamp( 800, 0, ScrH() ))
	self.MainContainer = vgui.Create("DPanel",self)
	self.MainContainer:Dock(FILL)


	self.Factionsview = vgui.Create("DListView", self.MainContainer)
	self.Factionsview:Dock(FILL)
	
	
	self.BottomPanel = vgui.Create("DPanel",self.MainContainer)
	self.BottomPanel:Dock(BOTTOM)
	self.BottomPanel:SetBackgroundColor(Color(0,0,0,0))
	self.BottomPanel:SetWide(self:GetWide())
	self.BottomPanel:InvalidateParent(true)
	--[[
		Panel
		{
			MainContainer
			{
				Factionsview {}

				BottomPanel				{LEFT | RIGHT}
			}
		}					
	]]--

	self.ButtonsContainer = vgui.Create("DPanel", self.BottomPanel)
	self.ButtonsContainer:Dock(RIGHT)
	self.ButtonsContainer:InvalidateParent(true)
	-- self.ButtonsContainer:SetWide(210)

	self.ButtonsPanelLeft = vgui.Create("DPanel", self.ButtonsContainer)
	self.ButtonsPanelLeft:Dock(LEFT)
	self.ButtonsPanelLeft:InvalidateParent(true)
	self.ButtonsPanelRight = vgui.Create("DPanel", self.ButtonsContainer)
	self.ButtonsPanelRight:Dock(RIGHT)
	self.ButtonsPanelRight:InvalidateParent(true)
	-- self.ButtonsPanelLeft:SetWide(100)
	-- self.ButtonsPanelRight:SetWide(100)

	self.BottomPanel:SetBackgroundColor(Color(44, 62, 80, 255))

--First Page, Previous Page, Next Page, Last Page
	self.FirstPage = vgui.Create("DButton", self.ButtonsPanelLeft)
	self.FirstPage:SetText("<<")
	self.FirstPage:Dock(LEFT)

	self.PreviousPage = vgui.Create("DButton", self.ButtonsPanelLeft)
	self.PreviousPage:SetText("<")
	self.PreviousPage:Dock(RIGHT)

	self.NextPage = vgui.Create("DButton", self.ButtonsPanelRight)
	self.NextPage:SetText(">")
	self.NextPage:Dock(LEFT)

	self.LastPage = vgui.Create("DButton", self.ButtonsPanelRight) 
	self.LastPage:SetText(">>")
	self.LastPage:Dock(RIGHT)

	self.ButtonsPanelLeft:SetWide(self.FirstPage:GetWide() + self.NextPage:GetWide())
	self.ButtonsPanelRight:SetWide(self.NextPage:GetWide() + self.LastPage:GetWide())
	self.ButtonsContainer:SetWide(self.FirstPage:GetWide() + self.PreviousPage:GetWide() + self.NextPage:GetWide() + self.LastPage:GetWide())
	--[[

		--Container [  Container[Name] Container[Description] -... ]
	]]--

	--id  - name - description - owner - InviteOnly - kills - deaths
	self.privcol = self.Factionsview:AddColumn(" ", 1)
	self.namecol = self.Factionsview:AddColumn("Name", 2)
	self.desccol = self.Factionsview:AddColumn("Description", 3)
	self.owncol = self.Factionsview:AddColumn("owner", 4)
	self.killcol = self.Factionsview:AddColumn("Kills/Deaths", 5)
	self.idcol = self.Factionsview:AddColumn("ID", 6)

	--sizing
	self.privcol:SetWide(5)




	--debug code to sample how factions is displayed
	for K=1, 10 do
		local ID = cfcFactions:UUID()
		local name = "MyTestFaction"
		addFactions(self, math.random(0,1), (name .. ID), string.reverse(string.lower(name)),"Test User", (math.random(0,100) .. "/"..math.random(0,100)), cfcFactions:UUID())

	end
end
function Panel:Paint(w, h)

end
function Panel:Think()
end

vgui.Register('D_cfcfactionsderma', Panel)


--todo: FactionRemoved


--todo: 
net.Receive("FactionCreated", function()

end)
