-- ============================================================
--  HoloLib  |  Hologram GUI Library
--  loadstring 対応ライブラリ
-- ============================================================

local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")

local LP         = Players.LocalPlayer
local PlayerGui  = LP:WaitForChild("PlayerGui")

-- ============================================================
--  内部ユーティリティ
-- ============================================================

local function MakeCorner(parent, xScale, yScale)
	local H = Instance.new("Frame")
	H.BorderSizePixel = 0
	H.Size = UDim2.fromOffset(35, 3)
	H.Position = UDim2.new(
		xScale, xScale == 1 and -35 or 0,
		yScale, yScale == 1 and -3  or 0
	)
	H.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
	H.Parent = parent

	local V = Instance.new("Frame")
	V.BorderSizePixel = 0
	V.Size = UDim2.fromOffset(3, 35)
	V.Position = UDim2.new(
		xScale, xScale == 1 and -3  or 0,
		yScale, yScale == 1 and -35 or 0
	)
	V.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
	V.Parent = parent
end

-- ============================================================
--  ライブラリ本体
-- ============================================================

local HoloLib = {}
HoloLib.__index = HoloLib

-- ------------------------------------------------------------
--  CreateWindow(titleText)
--    ウィンドウ・ヘッダー・スキャンアニメ・ドラッグを生成する
-- ------------------------------------------------------------
function HoloLib:CreateWindow(titleText)

	-- ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "HologramGUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	-- Main フレーム
	local Main = Instance.new("Frame")
	Main.Size = UDim2.fromOffset(600, 380)
	Main.Position = UDim2.fromScale(0.5, 0.5)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
	Main.BackgroundTransparency = 0.93
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Parent = ScreenGui

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(0, 255, 255)
	Stroke.Thickness = 2
	Stroke.Parent = Main

	local Inner = Instance.new("Frame")
	Inner.Size = UDim2.new(1, -12, 1, -12)
	Inner.Position = UDim2.fromOffset(6, 6)
	Inner.BackgroundTransparency = 1
	Inner.BorderSizePixel = 0
	Inner.Parent = Main

	local InnerStroke = Instance.new("UIStroke")
	InnerStroke.Color = Color3.fromRGB(150, 255, 255)
	InnerStroke.Thickness = 1
	InnerStroke.Parent = Inner

	MakeCorner(Main, 0, 0)
	MakeCorner(Main, 1, 0)
	MakeCorner(Main, 0, 1)
	MakeCorner(Main, 1, 1)

	-- スキャンライン
	local ScanLayer = Instance.new("Frame")
	ScanLayer.Size = UDim2.fromScale(1, 1)
	ScanLayer.BackgroundTransparency = 1
	ScanLayer.ClipsDescendants = true
	ScanLayer.Parent = Main

	for i = 0, 75 do
		local Scan = Instance.new("Frame")
		Scan.BorderSizePixel = 0
		Scan.Size = UDim2.new(1, 0, 0, 1)
		Scan.Position = UDim2.new(0, 0, 0, i * 5)
		Scan.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
		Scan.BackgroundTransparency = 0.97
		Scan.Parent = ScanLayer
	end

	local Sweep = Instance.new("Frame")
	Sweep.BorderSizePixel = 0
	Sweep.Size = UDim2.new(1, 0, 0, 40)
	Sweep.BackgroundColor3 = Color3.fromRGB(180, 255, 255)
	Sweep.BackgroundTransparency = 0.95
	Sweep.Parent = ScanLayer

	task.spawn(function()
		while ScreenGui.Parent do
			Sweep.Position = UDim2.new(0, 0, 0, -40)
			local Tween = TweenService:Create(
				Sweep,
				TweenInfo.new(3, Enum.EasingStyle.Linear),
				{ Position = UDim2.new(0, 0, 1, 40) }
			)
			Tween:Play()
			Tween.Completed:Wait()
			task.wait(0.5)
		end
	end)

	-- データストリーム
	local DataLayer = Instance.new("Frame")
	DataLayer.Size = UDim2.fromScale(1, 1)
	DataLayer.BackgroundTransparency = 1
	DataLayer.ClipsDescendants = true
	DataLayer.Parent = Main

	task.spawn(function()
		while ScreenGui.Parent do
			local Len = math.random(30, 80)
			local Line = Instance.new("Frame")
			Line.BorderSizePixel = 0
			Line.Size = UDim2.fromOffset(Len, 2)
			Line.Position = UDim2.new(0, -Len, 0, math.random(60, 360))
			Line.BackgroundColor3 = Color3.fromRGB(150, 255, 255)
			Line.Parent = DataLayer

			local G = Instance.new("UIGradient")
			G.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0,    1),
				NumberSequenceKeypoint.new(0.25, 0),
				NumberSequenceKeypoint.new(0.75, 0),
				NumberSequenceKeypoint.new(1,    1),
			}
			G.Parent = Line

			local MT = TweenService:Create(
				Line,
				TweenInfo.new(math.random(20, 40) / 10, Enum.EasingStyle.Linear),
				{ Position = UDim2.new(0, 650, 0, Line.Position.Y.Offset) }
			)
			MT:Play()
			MT.Completed:Connect(function() Line:Destroy() end)
			task.wait(0.12)
		end
	end)

	-- ヘッダー：タイトル
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -120, 0, 40)
	TitleLabel.Position = UDim2.fromOffset(15, 10)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = ""
	TitleLabel.Font = Enum.Font.Code
	TitleLabel.TextSize = 28
	TitleLabel.TextColor3 = Color3.fromRGB(200, 255, 255)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.ZIndex = 10
	TitleLabel.Parent = Main

	local Cursor = Instance.new("TextLabel")
	Cursor.Size = UDim2.fromOffset(20, 40)
	Cursor.Position = UDim2.fromOffset(15, 10)
	Cursor.BackgroundTransparency = 1
	Cursor.Text = "_"
	Cursor.Font = Enum.Font.Code
	Cursor.TextSize = 28
	Cursor.TextColor3 = Color3.fromRGB(200, 255, 255)
	Cursor.ZIndex = 10
	Cursor.Parent = Main

	-- ヘッダー：最小化ボタン
	local Minimize = Instance.new("TextButton")
	Minimize.Size = UDim2.fromOffset(35, 35)
	Minimize.Position = UDim2.new(1, -85, 0, 10)
	Minimize.BackgroundTransparency = 1
	Minimize.Text = "-"
	Minimize.Font = Enum.Font.Code
	Minimize.TextSize = 24
	Minimize.TextColor3 = Color3.fromRGB(180, 255, 255)
	Minimize.ZIndex = 10
	Minimize.Parent = Main

	-- ヘッダー：閉じるボタン
	local Close = Instance.new("TextButton")
	Close.Size = UDim2.fromOffset(35, 35)
	Close.Position = UDim2.new(1, -45, 0, 10)
	Close.BackgroundTransparency = 1
	Close.Text = "X"
	Close.Font = Enum.Font.Code
	Close.TextSize = 24
	Close.TextColor3 = Color3.fromRGB(255, 120, 120)
	Close.ZIndex = 10
	Close.Parent = Main

	-- ヘッダーライン
	local HeaderLine = Instance.new("Frame")
	HeaderLine.Name = "HeaderLine"
	HeaderLine.BorderSizePixel = 0
	HeaderLine.Size = UDim2.new(1, -20, 0, 2)
	HeaderLine.Position = UDim2.new(0, 10, 0, 50)
	HeaderLine.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
	HeaderLine.Parent = Main

	local HeaderGradient = Instance.new("UIGradient")
	HeaderGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0,    1),
		NumberSequenceKeypoint.new(0.15, 0),
		NumberSequenceKeypoint.new(0.85, 0),
		NumberSequenceKeypoint.new(1,    1),
	}
	HeaderGradient.Parent = HeaderLine

	local CenterMark = Instance.new("Frame")
	CenterMark.Name = "CenterMark"
	CenterMark.BorderSizePixel = 0
	CenterMark.Size = UDim2.fromOffset(60, 4)
	CenterMark.AnchorPoint = Vector2.new(0.5, 0)
	CenterMark.Position = UDim2.new(0.5, 0, 0, 49)
	CenterMark.BackgroundColor3 = Color3.fromRGB(180, 255, 255)
	CenterMark.ZIndex = 11
	CenterMark.Parent = Main

	local MarkGradient = Instance.new("UIGradient")
	MarkGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0,   1),
		NumberSequenceKeypoint.new(0.2, 0),
		NumberSequenceKeypoint.new(0.8, 0),
		NumberSequenceKeypoint.new(1,   1),
	}
	MarkGradient.Parent = CenterMark

	-- タブバー（ヘッダー直下）
	local TabBar = Instance.new("Frame")
	TabBar.Name = "TabBar"
	TabBar.Size = UDim2.new(1, -20, 0, 30)
	TabBar.Position = UDim2.new(0, 10, 0, 56)
	TabBar.BackgroundTransparency = 1
	TabBar.BorderSizePixel = 0
	TabBar.ClipsDescendants = false
	TabBar.ZIndex = 10
	TabBar.Parent = Main

	-- コンテンツ領域
	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, -20, 1, -100)
	ContentArea.Position = UDim2.new(0, 10, 0, 92)
	ContentArea.BackgroundTransparency = 1
	ContentArea.BorderSizePixel = 0
	ContentArea.ClipsDescendants = true
	ContentArea.Parent = Main

	-- タイトルタイプライター
	task.spawn(function()
		for i = 1, #titleText do
			TitleLabel.Text = string.sub(titleText, 1, i)
			task.wait(0.08)
		end
	end)

	-- カーソル点滅
	task.spawn(function()
		while ScreenGui.Parent do
			Cursor.Visible = not Cursor.Visible
			task.wait(0.5)
		end
	end)

	RunService.RenderStepped:Connect(function()
		if TitleLabel.Parent then
			Cursor.Position = UDim2.fromOffset(15 + TitleLabel.TextBounds.X, 10)
		end
	end)

	-- 最小化
	local FullSize = Main.Size
	local Minimized = false

	Minimize.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		Main.Size = Minimized
			and UDim2.new(FullSize.X.Scale, FullSize.X.Offset, 0, 60)
			or FullSize
	end)

	-- 閉じる
	Close.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	-- ドラッグ
	local Dragging = false
	local DragStart, StartPos

	Main.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPos = Main.Position
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Dragging and (
			Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch
		) then
			local Delta = Input.Position - DragStart
			Main.Position = UDim2.new(
				StartPos.X.Scale, StartPos.X.Offset + Delta.X,
				StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
			)
		end
	end)

	-- ============================================================
	--  Window オブジェクト
	-- ============================================================
	local Window = {}
	Window._ScreenGui   = ScreenGui
	Window._Main        = Main
	Window._TabBar      = TabBar
	Window._ContentArea = ContentArea
	Window._Tabs        = {}      -- { button, page, underline }
	Window._ActiveTab   = nil
	Window._TabOffset   = 0       -- タブボタンの横並びオフセット

	-- ----------------------------------------------------------
	--  内部：タブ切り替え
	-- ----------------------------------------------------------
	local function SwitchTab(target)
		for _, t in ipairs(Window._Tabs) do
			local active = (t == target)
			t.Page.Visible = active
			t.Underline.Visible = active
			t.Button.TextColor3 = active
				and Color3.fromRGB(180, 255, 255)
				or  Color3.fromRGB(80,  120, 120)
		end
		Window._ActiveTab = target
	end

	-- ----------------------------------------------------------
	--  Window:CreateTab(name)
	-- ----------------------------------------------------------
	function Window:CreateTab(name)

		local TAB_W = 90
		local TAB_H = 28

		-- タブボタン
		local Btn = Instance.new("TextButton")
		Btn.Size = UDim2.fromOffset(TAB_W, TAB_H)
		Btn.Position = UDim2.fromOffset(self._TabOffset, 0)
		Btn.BackgroundTransparency = 1
		Btn.Text = name
		Btn.Font = Enum.Font.Code
		Btn.TextSize = 16
		Btn.TextColor3 = Color3.fromRGB(80, 120, 120)
		Btn.ZIndex = 10
		Btn.Parent = self._TabBar

		local Underline = Instance.new("Frame")
		Underline.Size = UDim2.new(1, 0, 0, 2)
		Underline.Position = UDim2.new(0, 0, 1, -2)
		Underline.BorderSizePixel = 0
		Underline.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
		Underline.Visible = false
		Underline.ZIndex = 10
		Underline.Parent = Btn

		-- ページ（ScrollingFrame）
		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.fromScale(1, 1)
		Page.Position = UDim2.fromOffset(0, 0)
		Page.BackgroundTransparency = 1
		Page.BorderSizePixel = 0
		Page.ScrollBarThickness = 3
		Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
		Page.CanvasSize = UDim2.fromOffset(0, 0)
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.Visible = false
		Page.Parent = self._ContentArea

		local ListLayout = Instance.new("UIListLayout")
		ListLayout.Padding = UDim.new(0, 8)
		ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ListLayout.Parent = Page

		local Padding = Instance.new("UIPadding")
		Padding.PaddingTop = UDim.new(0, 4)
		Padding.PaddingBottom = UDim.new(0, 8)
		Padding.Parent = Page

		local tabEntry = {
			Button    = Btn,
			Page      = Page,
			Underline = Underline,
			_Order    = 0,
		}

		table.insert(self._Tabs, tabEntry)
		self._TabOffset = self._TabOffset + TAB_W + 8

		-- 最初のタブは自動でアクティブ
		if #self._Tabs == 1 then
			SwitchTab(tabEntry)
		end

		Btn.MouseButton1Click:Connect(function()
			SwitchTab(tabEntry)
		end)

		-- ============================================================
		--  Tab オブジェクト
		-- ============================================================
		local Tab = {}
		Tab._Entry = tabEntry

		local function NextOrder()
			tabEntry._Order = tabEntry._Order + 1
			return tabEntry._Order
		end

		-- --------------------------------------------------------
		--  Tab:AddToggle(labelText, default, callback)
		-- --------------------------------------------------------
		function Tab:AddToggle(labelText, default, callback)

			local Enabled = (default == true)

			local Toggle = Instance.new("TextButton")
			Toggle.Size = UDim2.new(1, 0, 0, 30)
			Toggle.BackgroundTransparency = 1
			Toggle.Text = ""
			Toggle.LayoutOrder = NextOrder()
			Toggle.Parent = tabEntry.Page

			local NameLabel = Instance.new("TextLabel")
			NameLabel.BackgroundTransparency = 1
			NameLabel.Size = UDim2.new(0.7, 0, 1, 0)
			NameLabel.Text = labelText
			NameLabel.Font = Enum.Font.Code
			NameLabel.TextSize = 18
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.TextColor3 = Color3.fromRGB(180, 255, 255)
			NameLabel.Parent = Toggle

			local StateLabel = Instance.new("TextLabel")
			StateLabel.BackgroundTransparency = 1
			StateLabel.Size = UDim2.new(0.3, 0, 1, 0)
			StateLabel.Position = UDim2.new(0.7, 0, 0, 0)
			StateLabel.Font = Enum.Font.Code
			StateLabel.TextSize = 18
			StateLabel.Parent = Toggle

			local function UpdateToggle()
				StateLabel.Text = Enabled and "ON" or "OFF"
				StateLabel.TextColor3 = Enabled
					and Color3.fromRGB(0,  255, 255)
					or  Color3.fromRGB(80, 120, 120)
			end

			Toggle.MouseButton1Click:Connect(function()
				Enabled = not Enabled
				UpdateToggle()
				if callback then callback(Enabled) end
			end)

			UpdateToggle()

			-- 戻り値でON/OFFを外部から操作可能
			local obj = {}
			function obj:Set(v)
				Enabled = v
				UpdateToggle()
				if callback then callback(Enabled) end
			end
			function obj:Get() return Enabled end
			return obj
		end

		-- --------------------------------------------------------
		--  Tab:AddSlider(labelText, options, callback)
		--    options = { Min, Max, Default }
		-- --------------------------------------------------------
		function Tab:AddSlider(labelText, options, callback)

			local Min     = options.Min     or 0
			local Max     = options.Max     or 100
			local Value   = options.Default or Min

			local Container = Instance.new("Frame")
			Container.Size = UDim2.new(1, 0, 0, 50)
			Container.BackgroundTransparency = 1
			Container.LayoutOrder = NextOrder()
			Container.Parent = tabEntry.Page

			local NameLabel = Instance.new("TextLabel")
			NameLabel.Size = UDim2.new(1, 0, 0, 20)
			NameLabel.BackgroundTransparency = 1
			NameLabel.Text = labelText
			NameLabel.Font = Enum.Font.Code
			NameLabel.TextSize = 16
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.TextColor3 = Color3.fromRGB(180, 255, 255)
			NameLabel.Parent = Container

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, 0, 0, 30)
			SliderFrame.Position = UDim2.fromOffset(0, 20)
			SliderFrame.BackgroundTransparency = 1
			SliderFrame.Parent = Container

			local Track = Instance.new("Frame")
			Track.Size = UDim2.new(1, -40, 0, 2)
			Track.Position = UDim2.new(0, 0, 0.5, -1)
			Track.BorderSizePixel = 0
			Track.BackgroundColor3 = Color3.fromRGB(40, 120, 120)
			Track.Parent = SliderFrame

			local Fill = Instance.new("Frame")
			Fill.BorderSizePixel = 0
			Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
			Fill.Parent = Track

			local Knob = Instance.new("Frame")
			Knob.Size = UDim2.fromOffset(10, 10)
			Knob.AnchorPoint = Vector2.new(0.5, 0.5)
			Knob.BorderSizePixel = 0
			Knob.BackgroundColor3 = Color3.fromRGB(180, 255, 255)
			Knob.Parent = SliderFrame

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.fromOffset(35, 20)
			ValueLabel.Position = UDim2.new(1, -35, 0, 0)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Font = Enum.Font.Code
			ValueLabel.TextSize = 16
			ValueLabel.TextColor3 = Color3.fromRGB(180, 255, 255)
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderFrame

			local SliderDragging = false

			local function UpdateSlider()
				local Percent = (Value - Min) / (Max - Min)
				Fill.Size = UDim2.new(Percent, 0, 1, 0)
				Knob.Position = UDim2.new(Percent, 0, 0.5, 0)
				ValueLabel.Text = tostring(math.floor(Value + 0.5))
			end

			local function SetFromPosition(X)
				local TrackStart = Track.AbsolutePosition.X
				local TrackWidth = Track.AbsoluteSize.X
				local Percent = math.clamp((X - TrackStart) / TrackWidth, 0, 1)
				Value = Min + (Max - Min) * Percent
				UpdateSlider()
				if callback then callback(Value) end
			end

			Knob.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch then
					SliderDragging = true
				end
			end)

			Knob.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch then
					SliderDragging = false
				end
			end)

			Track.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch then
					SetFromPosition(Input.Position.X)
					SliderDragging = true
				end
			end)

			UserInputService.InputChanged:Connect(function(Input)
				if not SliderDragging then return end
				if Input.UserInputType ~= Enum.UserInputType.MouseMovement
				and Input.UserInputType ~= Enum.UserInputType.Touch then return end
				SetFromPosition(Input.Position.X)
			end)

			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch then
					SliderDragging = false
				end
			end)

			UpdateSlider()

			local obj = {}
			function obj:Set(v)
				Value = math.clamp(v, Min, Max)
				UpdateSlider()
				if callback then callback(Value) end
			end
			function obj:Get() return Value end
			return obj
		end

		-- --------------------------------------------------------
		--  Tab:AddLabel(text)
		--    リアルタイム更新向きテキストラベル
		-- --------------------------------------------------------
		function Tab:AddLabel(text)

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, 0, 0, 25)
			Label.BackgroundTransparency = 1
			Label.Text = text or ""
			Label.Font = Enum.Font.Code
			Label.TextSize = 16
			Label.TextColor3 = Color3.fromRGB(180, 255, 255)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.LayoutOrder = NextOrder()
			Label.Parent = tabEntry.Page

			local obj = {}
			function obj:Set(v) Label.Text = tostring(v) end
			function obj:Get() return Label.Text end
			return obj
		end

		-- --------------------------------------------------------
		--  Tab:AddParagraph(title, description)
		--    説明用ブロック（自動高さ調整）
		-- --------------------------------------------------------
		function Tab:AddParagraph(titleText, descText)

			local Para = Instance.new("Frame")
			Para.Size = UDim2.fromOffset(560, 60)
			Para.BackgroundTransparency = 1
			Para.LayoutOrder = NextOrder()
			Para.Parent = tabEntry.Page

			local TopLine = Instance.new("Frame")
			TopLine.Size = UDim2.new(1, 0, 0, 2)
			TopLine.BorderSizePixel = 0
			TopLine.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
			TopLine.Parent = Para

			local BottomLine = Instance.new("Frame")
			BottomLine.BorderSizePixel = 0
			BottomLine.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
			BottomLine.Parent = Para

			local TitleLbl = Instance.new("TextLabel")
			TitleLbl.Size = UDim2.new(1, 0, 0, 20)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = titleText or ""
			TitleLbl.Font = Enum.Font.Code
			TitleLbl.TextSize = 16
			TitleLbl.TextColor3 = Color3.fromRGB(180, 255, 255)
			TitleLbl.Parent = Para

			local Desc = Instance.new("TextLabel")
			Desc.Size = UDim2.new(1, -10, 0, 0)
			Desc.Position = UDim2.fromOffset(5, 25)
			Desc.BackgroundTransparency = 1
			Desc.AutomaticSize = Enum.AutomaticSize.Y
			Desc.TextWrapped = true
			Desc.TextYAlignment = Enum.TextYAlignment.Top
			Desc.TextXAlignment = Enum.TextXAlignment.Left
			Desc.Font = Enum.Font.Code
			Desc.TextSize = 14
			Desc.TextColor3 = Color3.fromRGB(180, 255, 255)
			Desc.Text = descText or ""
			Desc.Parent = Para

			local function UpdateSize()
				local H = 30 + Desc.TextBounds.Y + 10
				Para.Size = UDim2.fromOffset(560, H)
				BottomLine.Position = UDim2.new(0, 0, 1, -2)
				BottomLine.Size = UDim2.new(1, 0, 0, 2)
			end

			Desc:GetPropertyChangedSignal("TextBounds"):Connect(UpdateSize)
			UpdateSize()

			local obj = {}
			function obj:SetTitle(v) TitleLbl.Text = tostring(v) end
			function obj:SetDesc(v)
				Desc.Text = tostring(v)
				UpdateSize()
			end
			return obj
		end

		return Tab
	end

	-- ----------------------------------------------------------
	--  Window:Notify(title, message, duration)
	-- ----------------------------------------------------------
	function Window:Notify(title, message, duration)

		duration = duration or 3

		local Notification = Instance.new("Frame")
		Notification.Size = UDim2.fromOffset(250, 70)
		Notification.Position = UDim2.new(1, 260, 0, 20)
		Notification.BackgroundTransparency = 0.92
		Notification.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
		Notification.Parent = self._ScreenGui

		local NStroke = Instance.new("UIStroke")
		NStroke.Color = Color3.fromRGB(0, 255, 255)
		NStroke.Parent = Notification

		local TitleLbl = Instance.new("TextLabel")
		TitleLbl.Size = UDim2.new(1, -10, 0, 25)
		TitleLbl.Position = UDim2.fromOffset(5, 0)
		TitleLbl.BackgroundTransparency = 1
		TitleLbl.Text = title
		TitleLbl.Font = Enum.Font.Code
		TitleLbl.TextSize = 18
		TitleLbl.TextColor3 = Color3.fromRGB(180, 255, 255)
		TitleLbl.Parent = Notification

		local MsgLbl = Instance.new("TextLabel")
		MsgLbl.Size = UDim2.new(1, -10, 1, -25)
		MsgLbl.Position = UDim2.fromOffset(5, 25)
		MsgLbl.BackgroundTransparency = 1
		MsgLbl.Text = message
		MsgLbl.Font = Enum.Font.Code
		MsgLbl.TextSize = 14
		MsgLbl.TextColor3 = Color3.fromRGB(180, 255, 255)
		MsgLbl.Parent = Notification

		TweenService:Create(
			Notification,
			TweenInfo.new(0.25),
			{ Position = UDim2.new(1, -260, 0, 20) }
		):Play()

		task.delay(duration, function()
			local T = TweenService:Create(
				Notification,
				TweenInfo.new(0.25),
				{ Position = UDim2.new(1, 260, 0, 20) }
			)
			T:Play()
			T.Completed:Wait()
			if Notification then Notification:Destroy() end
		end)
	end

	return Window
end

-- ============================================================
--  エントリーポイント：loadstring(...)(） で返るテーブル
-- ============================================================
return HoloLib
