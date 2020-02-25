local PANEL = {}
local cfg = ColorSchemes

function PANEL:Init()
	self.pageCount = 10
	self.page = 1
	self.btnsLoaded = false
	self:SetSize( 300, 50 )
end

function PANEL:ClearButtons()
	if not self.btns or #table.GetKeys(self.btns) == 0 then
		self.btns = {}
		return
	end
	for k, v in pairs(self.btns.nums) do
		v:Remove()
	end
	self.btns.first:Remove()
	self.btns.prev:Remove()
	self.btns.next:Remove()
	self.btns.last:Remove()
	self.btnsLoaded = false
	self.btns = {}
end

local function formatBtn(btn)
	function btn:SetBackgroundColor(col)
		self.bgCol = col
	end
	btn:SetBackgroundColor(cfg.PaginationUnselectedBg)
	function btn:Paint(w, h)
		local disabled = self:GetDisabled()
		surface.SetDrawColor(disabled and Color(100, 100, 100) or self.bgCol)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0,0,0)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	btn:SetTextColor(cfg.PaginationUnselectedText)
	local oldDisabled = btn.SetDisabled
	function btn:SetDisabled(d)
		self:SetTextColor(d and Color(0,0,0) or cfg.PaginationUnselectedText)
		oldDisabled(self, d)
	end
	btn:SetFont("CFC_Normal")
end

function PANEL:PerformLayout()
	local w, h = self:GetSize()

	if w == self.prevW and h == self.prevH and self:GetPageCount() == self.prevPageCount then -- Nothing changed, no need to recreate
		return
	end

	self:ClearButtons()
	local btns = self.btns

	local maxBtns = math.floor(w / h)
	local maxNumBtns = maxBtns - 6 -- First and Last buttons are 2 each, then < and >

	if maxNumBtns < 3 then
		return -- Its size bad, just give up
	end

	local numBtnCount = math.min(self:GetPageCount(), maxNumBtns)

	local btnCount = numBtnCount + 6
	local btnSize = h
	local leftOffset = (w - (btnSize * btnCount)) / 2

	local function addBtn(txt, f, sizeMult)
		sizeMult = sizeMult or 1
		local btn = vgui.Create( "DButton", self )
		btn:SetText( txt )
		btn:SetPos( leftOffset, 0 )
		btn:SetSize( btnSize * sizeMult, btnSize )
		btn.DoClick = f
		formatBtn(btn)
		leftOffset = leftOffset + btnSize * sizeMult
		return btn
	end

	local this = self

	btns.first = addBtn("First", function() 
		this:SetPage( 1 )
	end, 2)

	btns.prev = addBtn("«", function() 
		this:SetPage( this:GetPage() - 1 )
	end)

	btns.nums = {}
	for k = 1, numBtnCount do
		btns.nums[k] = addBtn("", function(self)
			if not self.num then return end
			this:SetPage( self.num )
		end)
	end

	btns.next = addBtn("»", function() 
		this:SetPage( this:GetPage() + 1 )
	end)

	btns.last = addBtn("Last", function() 
		this:SetPage( this:GetPageCount() )
	end, 2)

	self.btnsLoaded = true

	self:SetPage(self:GetPage(), true)
	self.prevW = w
	self.prevH = h
	self.prevPageCount = self.pageCount
end

function PANEL:SetPageCount(c)
	if self.pageCount == c then return end
	self.pageCount = c
	self:InvalidateLayout( true )
end

function PANEL:GetPageCount()
	return self.pageCount
end

function PANEL:SetPage(p, noCb)
	p = math.Clamp(p, 1, self.pageCount)
	local oldPage = self.page
	self.page = p

	if not self.btnsLoaded then return end

	local showLeft = p ~= 1
	local showRight = p ~= self.pageCount
	self.btns.first:SetEnabled( showLeft )
	self.btns.prev:SetEnabled( showLeft )

	self.btns.next:SetEnabled( showRight )
	self.btns.last:SetEnabled( showRight )

	local numBtnCount = #self.btns.nums
	local numOffset = math.Clamp( ( p - 1 ) - ( math.floor( numBtnCount / 2 ) ), 0, self.pageCount - numBtnCount )
	for k = 1, numBtnCount do
		local btn = self.btns.nums[k]
		local btnPage = k + numOffset
		btn:SetText("" .. btnPage)
		btn.num = btnPage
		if p == btnPage then
			btn:SetBackgroundColor(cfg.PaginationSelectedBg)
			btn:SetTextColor(cfg.PaginationSelectedText)
		else
			btn:SetBackgroundColor(cfg.PaginationUnselectedBg)
			btn:SetTextColor(cfg.PaginationUnselectedText)
		end
	end

	if self.OnPageChange and not noCb and p ~= oldPage then
		self:OnPageChange(oldPage, self.page)
	end
end

function PANEL:GetPage()
	return self.page
end

vgui.Register("DPaginationBar", PANEL)