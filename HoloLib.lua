-- ============================================================
--  HoloLib  |  Hologram GUI Library
--  loadstring 対応ライブラリ
-- ============================================================

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local LP        = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- ============================================================
--  共通カラー定数
-- ============================================================
local C_CYAN       = Color3.fromRGB(0,   255, 255)
local C_CYAN_MID   = Color3.fromRGB(150, 255, 255)
local C_CYAN_LIGHT = Color3.fromRGB(180, 255, 255)
local C_CYAN_TEXT  = Color3.fromRGB(200, 255, 255)
local C_DARK       = Color3.fromRGB(80,  120, 120)
-- 半透明バック用：暗い青黒
local C_BG         = Color3.fromRGB(4,   18,  22)

-- ============================================================
--  内部ユーティリティ
-- ============================================================

-- コーナー装飾
local function MakeCorner(parent, xScale, yScale)
	local H = Instance.new("Frame")
	H.BorderSizePixel = 0
	H.Size = UDim2.fromOffset(35, 3)
	H.Position = UDim2.new(
		xScale, xScale == 1 and -35 or 0,
		yScale, yScale == 1 and -3  or 0
	)
	H.BackgroundColor3 = C_CYAN
	H.Parent = parent

	local V = Instance.new("Frame")
	V.BorderSizePixel = 0
	V.Size = UDim2.fromOffset(3, 35)
	V.Position = UDim2.new(
		xScale, xScale == 1 and -3  or 0,
		yScale, yScale == 1 and -35 or 0
	)
	V.BackgroundColor3 = C_CYAN
	V.Parent = parent
end

-- 半透明バック＋細枠を持つ汎用コンテナを生成する
-- parent    : 親インスタンス
-- size      : UDim2
-- layoutOrder : number
-- returns   : Frame (内側に子を追加する対象)
local function MakeBgFrame(parent, size, layoutOrder)
	local Bg = Instance.new("Frame")
	Bg.Size = size
	Bg.BackgroundColor3 = C_BG
	Bg.BackgroundTransparency = 0.45
	Bg.BorderSizePixel = 0
	Bg.LayoutOrder = layoutOrder
	Bg.Parent = parent

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = C_CYAN
	Stroke.Thickness = 1
	Stroke.Transparency = 0.7
	Stroke.Parent = Bg

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 4)
	Corner.Parent = Bg

	return Bg
end

-- ============================================================
--  ライブラリ本体
-- ============================================================

local HoloLib = {}
HoloLib.__index = HoloLib

-- ------------------------------------------------------------
--  CreateWindow(titleText)
-- ------------------------------------------------------------
function HoloLib:CreateWindow(titleText)

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "HologramGUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.fromOffset(600, 380)
	Main.Position = UDim2.fromScale(0.5, 0.5)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = C_CYAN
	Main.BackgroundTransparency = 0.93
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Parent = ScreenGui

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = C_CYAN
	Stroke.Thickness = 2
	Stroke.Parent = Main

	local Inner = Instance.new("Frame")
	Inner.Size = UDim2.new(1, -12, 1, -12)
	Inner.Position = UDim2.fromOffset(6, 6)
	Inner.BackgroundTransparency = 1
	Inner.BorderSizePixel = 0
	Inner.Parent = Main

	local InnerStroke = Instance.new("UIStroke")
	InnerStroke.Color = C_CYAN_MID
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
		Scan.BackgroundColor3 = C_CYAN
		Scan.BackgroundTransparency = 0.97
		Scan.Parent = ScanLayer
	end

	local Sweep = Instance.new("Frame")
	Sweep.BorderSizePixel = 0
	Sweep.Size = UDim2.new(1, 0, 0, 40)
	Sweep.BackgroundColor3 = C_CYAN_LIGHT
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
			Line.BackgroundColor3 = C_CYAN_MID
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
	TitleLabel.TextColor3 = C_CYAN_TEXT
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
	Cursor.TextColor3 = C_CYAN_TEXT
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
	Minimize.TextColor3 = C_CYAN_LIGHT
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
	HeaderLine.BackgroundColor3 = C_CYAN
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
	CenterMark.BackgroundColor3 = C_CYAN_LIGHT
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

	-- タブバー
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

	-- タイプライター
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
	Window._Tabs        = {}
	Window._ActiveTab   = nil
	Window._TabOffset   = 0

	local function SwitchTab(target)
		for _, t in ipairs(Window._Tabs) do
			local active = (t == target)
			t.Page.Visible = active
			t.Underline.Visible = active
			t.Button.TextColor3 = active and C_CYAN_LIGHT or C_DARK
		end
		Window._ActiveTab = target
	end

	-- ----------------------------------------------------------
	--  Window:CreateTab(name)
	-- ----------------------------------------------------------
	function Window:CreateTab(name)

		local TAB_W = 90
		local TAB_H = 28

		local Btn = Instance.new("TextButton")
		Btn.Size = UDim2.fromOffset(TAB_W, TAB_H)
		Btn.Position = UDim2.fromOffset(self._TabOffset, 0)
		Btn.BackgroundTransparency = 1
		Btn.Text = name
		Btn.Font = Enum.Font.Code
		Btn.TextSize = 16
		Btn.TextColor3 = C_DARK
		Btn.ZIndex = 10
		Btn.Parent = self._TabBar

		local Underline = Instance.new("Frame")
		Underline.Size = UDim2.new(1, 0, 0, 2)
		Underline.Position = UDim2.new(0, 0, 1, -2)
		Underline.BorderSizePixel = 0
		Underline.BackgroundColor3 = C_CYAN
		Underline.Visible = false
		Underline.ZIndex = 10
		Underline.Parent = Btn

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.fromScale(1, 1)
		Page.BackgroundTransparency = 1
		Page.BorderSizePixel = 0
		Page.ScrollBarThickness = 3
		Page.ScrollBarImageColor3 = C_CYAN
		Page.CanvasSize = UDim2.fromOffset(0, 0)
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.Visible = false
		Page.Parent = self._ContentArea

		local ListLayout = Instance.new("UIListLayout")
		ListLayout.Padding = UDim.new(0, 6)
		ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ListLayout.Parent = Page

		local Padding = Instance.new("UIPadding")
		Padding.PaddingTop = UDim.new(0, 4)
		Padding.PaddingBottom = UDim.new(0, 8)
		Padding.PaddingLeft = UDim.new(0, 2)
		Padding.PaddingRight = UDim.new(0, 2)
		Padding.Parent = Page

		local tabEntry = {
			Button    = Btn,
			Page      = Page,
			Underline = Underline,
			_Order    = 0,
		}

		table.insert(self._Tabs, tabEntry)
		self._TabOffset = self._TabOffset + TAB_W + 8

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

			-- 半透明バック
			local Bg = MakeBgFrame(tabEntry.Page, UDim2.new(1, 0, 0, 36), NextOrder())

			local Toggle = Instance.new("TextButton")
			Toggle.Size = UDim2.fromScale(1, 1)
			Toggle.BackgroundTransparency = 1
			Toggle.Text = ""
			Toggle.Parent = Bg

			-- 左：ラベル
			local NameLabel = Instance.new("TextLabel")
			NameLabel.BackgroundTransparency = 1
			NameLabel.Size = UDim2.new(0.7, -8, 1, 0)
			NameLabel.Position = UDim2.fromOffset(10, 0)
			NameLabel.Text = labelText
			NameLabel.Font = Enum.Font.Code
			NameLabel.TextSize = 17
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.TextColor3 = C_CYAN_LIGHT
			NameLabel.Parent = Toggle

			-- 右：ON/OFF バッジ
			local BadgeBg = Instance.new("Frame")
			BadgeBg.Size = UDim2.fromOffset(52, 22)
			BadgeBg.AnchorPoint = Vector2.new(1, 0.5)
			BadgeBg.Position = UDim2.new(1, -10, 0.5, 0)
			BadgeBg.BackgroundColor3 = C_BG
			BadgeBg.BackgroundTransparency = 0.3
			BadgeBg.BorderSizePixel = 0
			BadgeBg.Parent = Toggle

			local BadgeCorner = Instance.new("UICorner")
			BadgeCorner.CornerRadius = UDim.new(0, 4)
			BadgeCorner.Parent = BadgeBg

			local BadgeStroke = Instance.new("UIStroke")
			BadgeStroke.Thickness = 1
			BadgeStroke.Transparency = 0.5
			BadgeStroke.Parent = BadgeBg

			local StateLabel = Instance.new("TextLabel")
			StateLabel.Size = UDim2.fromScale(1, 1)
			StateLabel.BackgroundTransparency = 1
			StateLabel.Font = Enum.Font.Code
			StateLabel.TextSize = 16
			StateLabel.Parent = BadgeBg

			local function UpdateToggle()
				if Enabled then
					StateLabel.Text = "ON"
					StateLabel.TextColor3 = C_CYAN
					BadgeStroke.Color = C_CYAN
				else
					StateLabel.Text = "OFF"
					StateLabel.TextColor3 = C_DARK
					BadgeStroke.Color = C_DARK
				end
			end

			Toggle.MouseButton1Click:Connect(function()
				Enabled = not Enabled
				UpdateToggle()
				if callback then callback(Enabled) end
			end)

			UpdateToggle()

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
		-- --------------------------------------------------------
		function Tab:AddSlider(labelText, options, callback)

			local Min   = options.Min     or 0
			local Max   = options.Max     or 100
			local Value = options.Default or Min

			-- 半透明バック（ラベル行 + スライダー行）
			local Bg = MakeBgFrame(tabEntry.Page, UDim2.new(1, 0, 0, 56), NextOrder())

			-- ラベル行
			local NameLabel = Instance.new("TextLabel")
			NameLabel.Size = UDim2.new(0.65, 0, 0, 24)
			NameLabel.Position = UDim2.fromOffset(10, 4)
			NameLabel.BackgroundTransparency = 1
			NameLabel.Text = labelText
			NameLabel.Font = Enum.Font.Code
			NameLabel.TextSize = 16
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.TextColor3 = C_CYAN_LIGHT
			NameLabel.Parent = Bg

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.new(0.3, -10, 0, 24)
			ValueLabel.Position = UDim2.new(0.7, 0, 0, 4)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Font = Enum.Font.Code
			ValueLabel.TextSize = 16
			ValueLabel.TextColor3 = C_CYAN
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = Bg

			-- トラック行
			local TrackBg = Instance.new("Frame")
			TrackBg.Size = UDim2.new(1, -20, 0, 6)
			TrackBg.Position = UDim2.new(0, 10, 0, 34)
			TrackBg.BackgroundColor3 = Color3.fromRGB(20, 60, 60)
			TrackBg.BackgroundTransparency = 0.2
			TrackBg.BorderSizePixel = 0
			TrackBg.Parent = Bg

			local TrackCorner = Instance.new("UICorner")
			TrackCorner.CornerRadius = UDim.new(1, 0)
			TrackCorner.Parent = TrackBg

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new(0, 0, 1, 0)
			Fill.BackgroundColor3 = C_CYAN
			Fill.BorderSizePixel = 0
			Fill.Parent = TrackBg

			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = Fill

			local Knob = Instance.new("Frame")
			Knob.Size = UDim2.fromOffset(14, 14)
			Knob.AnchorPoint = Vector2.new(0.5, 0.5)
			Knob.Position = UDim2.new(0, 0, 0.5, 0)
			Knob.BackgroundColor3 = C_CYAN_LIGHT
			Knob.BorderSizePixel = 0
			Knob.ZIndex = 2
			Knob.Parent = TrackBg

			local KnobCorner = Instance.new("UICorner")
			KnobCorner.CornerRadius = UDim.new(1, 0)
			KnobCorner.Parent = Knob

			local SliderDragging = false

			local function UpdateSlider()
				local Percent = (Value - Min) / (Max - Min)
				Fill.Size = UDim2.new(Percent, 0, 1, 0)
				Knob.Position = UDim2.new(Percent, 0, 0.5, 0)
				ValueLabel.Text = tostring(math.floor(Value + 0.5))
			end

			local function SetFromPosition(X)
				local TrackStart = TrackBg.AbsolutePosition.X
				local TrackWidth = TrackBg.AbsoluteSize.X
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

			TrackBg.InputBegan:Connect(function(Input)
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
		--  Tab:AddDropdown(titleText, options, callback)
		-- --------------------------------------------------------
		function Tab:AddDropdown(titleText, options, callback)

			local Selected = nil
			local Open     = false

			-- 外枠（ClipsDescendants=false でリストが外にはみ出せる）
			local Container = Instance.new("Frame")
			Container.Size = UDim2.new(1, 0, 0, 36)
			Container.BackgroundTransparency = 1
			Container.BorderSizePixel = 0
			Container.ClipsDescendants = false
			Container.LayoutOrder = NextOrder()
			Container.ZIndex = 20
			Container.Parent = tabEntry.Page

			-- メインボタン（半透明バック）
			local MainButton = Instance.new("TextButton")
			MainButton.Size = UDim2.new(1, 0, 0, 36)
			MainButton.BackgroundColor3 = C_BG
			MainButton.BackgroundTransparency = 0.45
			MainButton.BorderSizePixel = 0
			MainButton.Text = ""
			MainButton.ZIndex = 20
			MainButton.Parent = Container

			local MBCorner = Instance.new("UICorner")
			MBCorner.CornerRadius = UDim.new(0, 4)
			MBCorner.Parent = MainButton

			local MBStroke = Instance.new("UIStroke")
			MBStroke.Color = C_CYAN
			MBStroke.Thickness = 1
			MBStroke.Transparency = 0.5
			MBStroke.Parent = MainButton

			local Header = Instance.new("TextLabel")
			Header.Size = UDim2.new(1, -10, 1, 0)
			Header.Position = UDim2.fromOffset(10, 0)
			Header.BackgroundTransparency = 1
			Header.Font = Enum.Font.Code
			Header.TextSize = 16
			Header.TextColor3 = C_CYAN_LIGHT
			Header.TextXAlignment = Enum.TextXAlignment.Left
			Header.Text = titleText .. "  ▼"
			Header.ZIndex = 21
			Header.Parent = MainButton

			-- リストフレーム（展開時に下へ伸びる）
			local ListFrame = Instance.new("Frame")
			ListFrame.Size = UDim2.new(1, 0, 0, 0)
			ListFrame.Position = UDim2.new(0, 0, 1, 2)
			ListFrame.BackgroundColor3 = C_BG
			ListFrame.BackgroundTransparency = 0.3
			ListFrame.BorderSizePixel = 0
			ListFrame.ClipsDescendants = true
			ListFrame.ZIndex = 22
			ListFrame.Parent = Container

			local LFCorner = Instance.new("UICorner")
			LFCorner.CornerRadius = UDim.new(0, 4)
			LFCorner.Parent = ListFrame

			local LFStroke = Instance.new("UIStroke")
			LFStroke.Color = C_CYAN
			LFStroke.Thickness = 1
			LFStroke.Transparency = 0.5
			LFStroke.Parent = ListFrame

			local Layout = Instance.new("UIListLayout")
			Layout.SortOrder = Enum.SortOrder.LayoutOrder
			Layout.Parent = ListFrame

			local function UpdateHeader()
				Header.Text = (Selected and tostring(Selected) or titleText) .. "  ▼"
				Header.TextColor3 = Selected and C_CYAN or C_CYAN_LIGHT
				MBStroke.Color = Selected and C_CYAN or C_CYAN
			end

			local function RefreshList()
				TweenService:Create(
					ListFrame,
					TweenInfo.new(0.18, Enum.EasingStyle.Quad),
					{ Size = UDim2.new(1, 0, 0, Open and #options * 28 or 0) }
				):Play()
			end

			local function BuildOptions()
				for _, child in ipairs(ListFrame:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				for i, optName in ipairs(options) do
					local Opt = Instance.new("TextButton")
					Opt.Size = UDim2.new(1, 0, 0, 28)
					Opt.BackgroundTransparency = 1
					Opt.BorderSizePixel = 0
					Opt.Font = Enum.Font.Code
					Opt.TextSize = 15
					Opt.TextColor3 = C_CYAN_LIGHT
					Opt.TextXAlignment = Enum.TextXAlignment.Left
					Opt.Text = "  " .. tostring(optName)
					Opt.LayoutOrder = i
					Opt.ZIndex = 23
					Opt.Parent = ListFrame

					-- ホバー時に薄く光る
					Opt.MouseEnter:Connect(function()
						Opt.TextColor3 = C_CYAN
					end)
					Opt.MouseLeave:Connect(function()
						Opt.TextColor3 = C_CYAN_LIGHT
					end)

					Opt.MouseButton1Click:Connect(function()
						Selected = optName
						UpdateHeader()
						Open = false
						RefreshList()
						if callback then callback(optName) end
					end)
				end
			end

			MainButton.MouseButton1Click:Connect(function()
				Open = not Open
				RefreshList()
			end)

			BuildOptions()
			UpdateHeader()

			local obj = {}
			function obj:Set(v)
				Selected = v
				UpdateHeader()
				if callback then callback(v) end
			end
			function obj:Get() return Selected end
			function obj:Refresh(newOptions)
				options = newOptions
				BuildOptions()
			end
			return obj
		end

		-- --------------------------------------------------------
		--  Tab:AddLabel(text)
		-- --------------------------------------------------------
		function Tab:AddLabel(text)

			local Bg = MakeBgFrame(tabEntry.Page, UDim2.new(1, 0, 0, 30), NextOrder())

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -10, 1, 0)
			Label.Position = UDim2.fromOffset(10, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text or ""
			Label.Font = Enum.Font.Code
			Label.TextSize = 15
			Label.TextColor3 = C_CYAN_LIGHT
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Bg

			local obj = {}
			function obj:Set(v) Label.Text = tostring(v) end
			function obj:Get() return Label.Text end
			return obj
		end

		-- --------------------------------------------------------
		--  Tab:AddParagraph(titleText, descText)
		-- --------------------------------------------------------
		function Tab:AddParagraph(titleText, descText)

			-- 外枠（高さは後で自動調整）
			local Bg = Instance.new("Frame")
			Bg.Size = UDim2.new(1, 0, 0, 60)
			Bg.BackgroundColor3 = C_BG
			Bg.BackgroundTransparency = 0.55
			Bg.BorderSizePixel = 0
			Bg.LayoutOrder = NextOrder()
			Bg.Parent = tabEntry.Page

			local BgCorner = Instance.new("UICorner")
			BgCorner.CornerRadius = UDim.new(0, 4)
			BgCorner.Parent = Bg

			local TopLine = Instance.new("Frame")
			TopLine.Size = UDim2.new(1, 0, 0, 2)
			TopLine.BorderSizePixel = 0
			TopLine.BackgroundColor3 = C_CYAN
			TopLine.Parent = Bg

			local BottomLine = Instance.new("Frame")
			BottomLine.BorderSizePixel = 0
			BottomLine.BackgroundColor3 = C_CYAN
			BottomLine.Parent = Bg

			local TitleLbl = Instance.new("TextLabel")
			TitleLbl.Size = UDim2.new(1, -10, 0, 22)
			TitleLbl.Position = UDim2.fromOffset(8, 2)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = titleText or ""
			TitleLbl.Font = Enum.Font.Code
			TitleLbl.TextSize = 15
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
			TitleLbl.TextColor3 = C_CYAN_LIGHT
			TitleLbl.Parent = Bg

			local Desc = Instance.new("TextLabel")
			Desc.Size = UDim2.new(1, -16, 0, 0)
			Desc.Position = UDim2.fromOffset(8, 26)
			Desc.BackgroundTransparency = 1
			Desc.AutomaticSize = Enum.AutomaticSize.Y
			Desc.TextWrapped = true
			Desc.TextYAlignment = Enum.TextYAlignment.Top
			Desc.TextXAlignment = Enum.TextXAlignment.Left
			Desc.Font = Enum.Font.Code
			Desc.TextSize = 13
			Desc.TextColor3 = C_CYAN_MID
			Desc.Text = descText or ""
			Desc.Parent = Bg

			local function UpdateSize()
				local H = 30 + Desc.TextBounds.Y + 10
				Bg.Size = UDim2.new(1, 0, 0, H)
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
		Notification.Size = UDim2.fromOffset(260, 72)
		Notification.Position = UDim2.new(1, 270, 0, 20)
		Notification.BackgroundColor3 = C_BG
		Notification.BackgroundTransparency = 0.35
		Notification.BorderSizePixel = 0
		Notification.Parent = self._ScreenGui

		local NCorner = Instance.new("UICorner")
		NCorner.CornerRadius = UDim.new(0, 6)
		NCorner.Parent = Notification

		local NStroke = Instance.new("UIStroke")
		NStroke.Color = C_CYAN
		NStroke.Thickness = 1
		NStroke.Parent = Notification

		-- タイトル上部アクセントライン
		local AccentLine = Instance.new("Frame")
		AccentLine.Size = UDim2.new(1, 0, 0, 2)
		AccentLine.BorderSizePixel = 0
		AccentLine.BackgroundColor3 = C_CYAN
		AccentLine.Parent = Notification

		local TitleLbl = Instance.new("TextLabel")
		TitleLbl.Size = UDim2.new(1, -10, 0, 26)
		TitleLbl.Position = UDim2.fromOffset(8, 4)
		TitleLbl.BackgroundTransparency = 1
		TitleLbl.Text = title
		TitleLbl.Font = Enum.Font.Code
		TitleLbl.TextSize = 17
		TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
		TitleLbl.TextColor3 = C_CYAN_LIGHT
		TitleLbl.Parent = Notification

		local MsgLbl = Instance.new("TextLabel")
		MsgLbl.Size = UDim2.new(1, -10, 0, 36)
		MsgLbl.Position = UDim2.fromOffset(8, 32)
		MsgLbl.BackgroundTransparency = 1
		MsgLbl.Text = message
		MsgLbl.Font = Enum.Font.Code
		MsgLbl.TextSize = 13
		MsgLbl.TextXAlignment = Enum.TextXAlignment.Left
		MsgLbl.TextWrapped = true
		MsgLbl.TextColor3 = C_CYAN_MID
		MsgLbl.Parent = Notification

		TweenService:Create(
			Notification,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Position = UDim2.new(1, -270, 0, 20) }
		):Play()

		task.delay(duration, function()
			local T = TweenService:Create(
				Notification,
				TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{ Position = UDim2.new(1, 270, 0, 20) }
			)
			T:Play()
			T.Completed:Wait()
			if Notification then Notification:Destroy() end
		end)
	end

	return Window
end

-- ============================================================
--  エントリーポイント
-- ============================================================
return HoloLib
