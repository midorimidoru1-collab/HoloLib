-- ============================================================
--  Herta IX Library  |  Hologram GUI Library
--  loadstring 対応ライブラリ
-- ============================================================

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local LP        = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- ============================================================
--  カラーテーマ定義
-- ============================================================
local Themes = {
	near_future = {
		accent    = Color3.fromRGB(0,   255, 255),
		accentMid = Color3.fromRGB(150, 255, 255),
		accentLt  = Color3.fromRGB(180, 255, 255),
		text      = Color3.fromRGB(200, 255, 255),
		dark      = Color3.fromRGB(80,  120, 120),
		bg        = Color3.fromRGB(4,   18,  22),
		bgAlpha   = 0.45,
		mainAlpha = 0.93,
		mainBg    = Color3.fromRGB(0,   255, 255),
		rainbow   = false,
	},
	gameboy = {
		accent    = Color3.fromRGB(106, 190, 48),
		accentMid = Color3.fromRGB(80,  160, 30),
		accentLt  = Color3.fromRGB(130, 210, 70),
		text      = Color3.fromRGB(15,  30,  10),
		dark      = Color3.fromRGB(60,  100, 30),
		bg        = Color3.fromRGB(15,  30,  10),
		bgAlpha   = 0.30,
		mainAlpha = 0.92,
		mainBg    = Color3.fromRGB(106, 190, 48),
		rainbow   = false,
	},
	rainbow_B = {
		accent    = Color3.fromRGB(255, 0,   0),
		accentMid = Color3.fromRGB(255, 128, 0),
		accentLt  = Color3.fromRGB(255, 255, 0),
		text      = Color3.fromRGB(10,  10,  10),
		dark      = Color3.fromRGB(80,  80,  80),
		bg        = Color3.fromRGB(10,  10,  10),
		bgAlpha   = 0.30,
		mainAlpha = 0.92,
		mainBg    = Color3.fromRGB(255, 0,   0),
		rainbow   = true,
		textRainbow = false,
	},
	rainbow_W = {
		accent    = Color3.fromRGB(255, 0,   0),
		accentMid = Color3.fromRGB(255, 128, 0),
		accentLt  = Color3.fromRGB(255, 255, 0),
		text      = Color3.fromRGB(255, 255, 255),
		dark      = Color3.fromRGB(180, 180, 180),
		bg        = Color3.fromRGB(10,  10,  10),
		bgAlpha   = 0.30,
		mainAlpha = 0.92,
		mainBg    = Color3.fromRGB(255, 0,   0),
		rainbow   = true,
		textRainbow = false,
	},
	monotone = {
		accent    = Color3.fromRGB(255, 255, 255),
		accentMid = Color3.fromRGB(200, 200, 200),
		accentLt  = Color3.fromRGB(220, 220, 220),
		text      = Color3.fromRGB(10,  10,  10),
		dark      = Color3.fromRGB(100, 100, 100),
		bg        = Color3.fromRGB(10,  10,  10),
		bgAlpha   = 0.35,
		mainAlpha = 0.92,
		mainBg    = Color3.fromRGB(255, 255, 255),
		rainbow   = false,
	},
	undertale = {
		accent    = Color3.fromRGB(10,  10,  10),
		accentMid = Color3.fromRGB(40,  40,  40),
		accentLt  = Color3.fromRGB(60,  60,  60),
		text      = Color3.fromRGB(10,  10,  10),
		dark      = Color3.fromRGB(150, 150, 150),
		bg        = Color3.fromRGB(240, 240, 240),
		bgAlpha   = 0.20,
		mainAlpha = 0.88,
		mainBg    = Color3.fromRGB(10,  10,  10),
		rainbow   = false,
	},
	leaf = {
		accent    = Color3.fromRGB(0,   100, 30),
		accentMid = Color3.fromRGB(80,  200, 80),
		accentLt  = Color3.fromRGB(140, 240, 100),
		text      = Color3.fromRGB(140, 240, 100),
		dark      = Color3.fromRGB(40,  80,  40),
		bg        = Color3.fromRGB(5,   20,  5),
		bgAlpha   = 0.40,
		mainAlpha = 0.92,
		mainBg    = Color3.fromRGB(0,   100, 30),
		rainbow   = false,
	},
	herta = {
		accent    = Color3.fromRGB(180, 120, 220),
		accentMid = Color3.fromRGB(140, 80,  200),
		accentLt  = Color3.fromRGB(200, 160, 240),
		text      = Color3.fromRGB(80,  20,  140),
		dark      = Color3.fromRGB(120, 80,  160),
		bg        = Color3.fromRGB(30,  10,  50),
		bgAlpha   = 0.40,
		mainAlpha = 0.92,
		mainBg    = Color3.fromRGB(180, 120, 220),
		rainbow   = false,
	},
	king = {
		accent    = Color3.fromRGB(200, 160, 0),
		accentMid = Color3.fromRGB(180, 140, 0),
		accentLt  = Color3.fromRGB(220, 180, 20),
		text      = Color3.fromRGB(200, 160, 0),
		dark      = Color3.fromRGB(120, 90,  0),
		bg        = Color3.fromRGB(20,  15,  0),
		bgAlpha   = 0.40,
		mainAlpha = 0.92,
		mainBg    = Color3.fromRGB(200, 160, 0),
		rainbow   = false,
	},
}

-- ============================================================
--  動的カラー変数（テーマ切り替えで上書きされる）
-- ============================================================
local C_ACCENT     = Themes.near_future.accent
local C_ACCENT_MID = Themes.near_future.accentMid
local C_ACCENT_LT  = Themes.near_future.accentLt
local C_TEXT       = Themes.near_future.text
local C_DARK       = Themes.near_future.dark
local C_BG         = Themes.near_future.bg

-- 後方互換エイリアス
local C_CYAN       = C_ACCENT
local C_CYAN_MID   = C_ACCENT_MID
local C_CYAN_LIGHT = C_ACCENT_LT
local C_CYAN_TEXT  = C_TEXT

-- テーマ変更時に更新が必要なオブジェクトを登録するテーブル
local ThemeListeners = {}  -- { type="stroke"|"bg"|"corner"|"text"|"mainbg", obj=Instance, ... }
local RainbowConns   = {}  -- rainbow アニメ用接続

local function RainbowColor(hue)
	return Color3.fromHSV(hue % 1, 1, 1)
end

local function ClearRainbow()
	for _, c in ipairs(RainbowConns) do c:Disconnect() end
	RainbowConns = {}
end

local function ApplyTheme(name)
	local T = Themes[name]
	if not T then return end

	ClearRainbow()

	-- 動的変数を更新
	C_ACCENT     = T.accent
	C_ACCENT_MID = T.accentMid
	C_ACCENT_LT  = T.accentLt
	C_TEXT       = T.text
	C_DARK       = T.dark
	C_BG         = T.bg
	C_CYAN       = C_ACCENT
	C_CYAN_MID   = C_ACCENT_MID
	C_CYAN_LIGHT = C_ACCENT_LT
	C_CYAN_TEXT  = C_TEXT

	-- 登録済みオブジェクトに即時適用
	for _, entry in ipairs(ThemeListeners) do
		local ok, obj = pcall(function() return entry.obj end)
		if not ok or not obj or not obj.Parent then continue end

		if entry.type == "stroke" then
			obj.Color = C_ACCENT
		elseif entry.type == "corner_h" or entry.type == "corner_v" then
			obj.BackgroundColor3 = C_ACCENT
		elseif entry.type == "bg" then
			obj.BackgroundColor3 = C_BG
			obj.BackgroundTransparency = T.bgAlpha
		elseif entry.type == "mainbg" then
			obj.BackgroundColor3 = T.mainBg
			obj.BackgroundTransparency = T.mainAlpha
		elseif entry.type == "text_accent" then
			obj.TextColor3 = C_ACCENT
		elseif entry.type == "text_lt" then
			obj.TextColor3 = C_ACCENT_LT
		elseif entry.type == "text_mid" then
			obj.TextColor3 = C_ACCENT_MID
		elseif entry.type == "text_main" then
			obj.TextColor3 = C_TEXT
		elseif entry.type == "text_dark" then
			obj.TextColor3 = C_DARK
		elseif entry.type == "fill" then
			obj.BackgroundColor3 = C_ACCENT
		elseif entry.type == "track" then
			obj.BackgroundColor3 = C_BG
		elseif entry.type == "knob" then
			obj.BackgroundColor3 = C_ACCENT_LT
		elseif entry.type == "underline" then
			obj.BackgroundColor3 = C_ACCENT
		elseif entry.type == "badge_on_stroke" then
			-- 状態依存なので何もしない（UpdateToggle側で処理）
		elseif entry.type == "headerline" then
			obj.BackgroundColor3 = C_ACCENT
		elseif entry.type == "scanline" then
			obj.BackgroundColor3 = C_ACCENT
		elseif entry.type == "sweep" then
			obj.BackgroundColor3 = C_ACCENT_LT
		elseif entry.type == "dataline" then
			obj.BackgroundColor3 = C_ACCENT_MID
		end
	end

	-- rainbow アニメ
	if T.rainbow then
		local conn = RunService.RenderStepped:Connect(function()
			local hue = (tick() * 0.2) % 1
			local col = RainbowColor(hue)
			for _, entry in ipairs(ThemeListeners) do
				local ok2, obj2 = pcall(function() return entry.obj end)
				if not ok2 or not obj2 or not obj2.Parent then continue end
				if entry.type == "stroke"
				or entry.type == "corner_h"
				or entry.type == "corner_v"
				or entry.type == "fill"
				or entry.type == "underline"
				or entry.type == "headerline"
				or entry.type == "mainbg" then
					obj2.BackgroundColor3 = col
					if entry.type == "mainbg" then
						obj2.BackgroundTransparency = T.mainAlpha
					end
				elseif entry.type == "stroke" then
					obj2.Color = col
				elseif entry.type == "text_accent" then
					obj2.TextColor3 = col
				end
			end
		end)
		table.insert(RainbowConns, conn)
	end
end

-- ============================================================
--  内部ユーティリティ
-- ============================================================

-- コーナー装飾（登録付き）
local function MakeCorner(parent, xScale, yScale)
	local H = Instance.new("Frame")
	H.BorderSizePixel = 0
	H.Size = UDim2.fromOffset(35, 3)
	H.Position = UDim2.new(
		xScale, xScale == 1 and -35 or 0,
		yScale, yScale == 1 and -3  or 0
	)
	H.BackgroundColor3 = C_ACCENT
	H.Parent = parent
	table.insert(ThemeListeners, { type = "corner_h", obj = H })

	local V = Instance.new("Frame")
	V.BorderSizePixel = 0
	V.Size = UDim2.fromOffset(3, 35)
	V.Position = UDim2.new(
		xScale, xScale == 1 and -3  or 0,
		yScale, yScale == 1 and -35 or 0
	)
	V.BackgroundColor3 = C_ACCENT
	V.Parent = parent
	table.insert(ThemeListeners, { type = "corner_v", obj = V })
end

-- Herta IX デザインフレーム
local function MakeHertaFrame(parent, size, layoutOrder)
	local Bg = Instance.new("Frame")
	Bg.Size = size
	Bg.BackgroundColor3 = C_BG
	Bg.BackgroundTransparency = 0.45
	Bg.BorderSizePixel = 0
	Bg.LayoutOrder = layoutOrder
	Bg.ClipsDescendants = false
	Bg.Parent = parent
	table.insert(ThemeListeners, { type = "bg", obj = Bg })

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = C_ACCENT
	Stroke.Thickness = 1
	Stroke.Transparency = 0.5
	Stroke.Parent = Bg
	table.insert(ThemeListeners, { type = "stroke", obj = Stroke })

	MakeCorner(Bg, 0, 0)
	MakeCorner(Bg, 1, 0)
	MakeCorner(Bg, 0, 1)
	MakeCorner(Bg, 1, 1)

	return Bg
end

local MakeBgFrame = MakeHertaFrame

-- ============================================================
--  ライブラリ本体
-- ============================================================

local HertaIX = {}
HertaIX.__index = HertaIX

-- ------------------------------------------------------------
--  CreateWindow(titleText)
-- ------------------------------------------------------------
-- ============================================================
--  アセット管理（getcustomasset 方式）
-- ============================================================
local _ASSET_FOLDER = "HertaIX_Assets"
local _ICON_FILENAME = "icon.png"
local _ICON_URL = "https://raw.githubusercontent.com/midorimidoru1-collab/HertaIX/master/icon.png"
local _IconAssetId = nil

local function _DownloadAsset(url, path)
	if not isfile(path) then
		local ok, data = pcall(function() return game:HttpGet(url) end)
		if ok then writefile(path, data) end
	end
end

local function _LoadIconAsset()
	if not isfolder(_ASSET_FOLDER) then makefolder(_ASSET_FOLDER) end
	local path = _ASSET_FOLDER .. "/" .. _ICON_FILENAME
	_DownloadAsset(_ICON_URL, path)
	local ok, id = pcall(function() return getcustomasset(path) end)
	if ok then _IconAssetId = id end
end

pcall(_LoadIconAsset)

function HertaIX:CreateWindow(titleText, theme)

	-- テーマ引数が指定されていれば起動時に適用
	if theme then
		ApplyTheme(theme)
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "HertaIXGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.fromOffset(600, 380)
	Main.Position = UDim2.fromScale(0.5, 0.5)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = C_ACCENT
	Main.BackgroundTransparency = 0.93
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Parent = ScreenGui
	table.insert(ThemeListeners, { type = "mainbg", obj = Main })

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = C_ACCENT
	Stroke.Thickness = 2
	Stroke.Parent = Main
	table.insert(ThemeListeners, { type = "stroke", obj = Stroke })

	local Inner = Instance.new("Frame")
	Inner.Size = UDim2.new(1, -12, 1, -12)
	Inner.Position = UDim2.fromOffset(6, 6)
	Inner.BackgroundTransparency = 1
	Inner.BorderSizePixel = 0
	Inner.Parent = Main

	local InnerStroke = Instance.new("UIStroke")
	InnerStroke.Color = C_ACCENT_MID
	InnerStroke.Thickness = 1
	InnerStroke.Parent = Inner
	table.insert(ThemeListeners, { type = "stroke", obj = InnerStroke })

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
		Scan.BackgroundColor3 = C_ACCENT
		Scan.BackgroundTransparency = 0.97
		Scan.Parent = ScanLayer
		table.insert(ThemeListeners, { type = "scanline", obj = Scan })
	end

	local Sweep = Instance.new("Frame")
	Sweep.BorderSizePixel = 0
	Sweep.Size = UDim2.new(1, 0, 0, 40)
	Sweep.BackgroundColor3 = C_ACCENT_LT
	Sweep.BackgroundTransparency = 0.95
	Sweep.Parent = ScanLayer
	table.insert(ThemeListeners, { type = "sweep", obj = Sweep })

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
			Line.BackgroundColor3 = C_ACCENT_MID
			Line.Parent = DataLayer
			table.insert(ThemeListeners, { type = "dataline", obj = Line })

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
	TitleLabel.Size = UDim2.new(1, -170, 0, 40)
	TitleLabel.Position = UDim2.fromOffset(54, 10)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = ""
	TitleLabel.Font = Enum.Font.Code
	TitleLabel.TextSize = 28
	TitleLabel.TextColor3 = C_TEXT
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.ZIndex = 10
	TitleLabel.Parent = Main
	table.insert(ThemeListeners, { type = "text_main", obj = TitleLabel })

	-- タイトル左側アイコン
	local HeaderIcon = Instance.new("ImageLabel")
	HeaderIcon.Size = UDim2.fromOffset(36, 36)
	HeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
	HeaderIcon.Position = UDim2.fromOffset(12, 25)
	HeaderIcon.BackgroundTransparency = 1
	HeaderIcon.BorderSizePixel = 0
	HeaderIcon.ZIndex = 10
	HeaderIcon.Parent = Main
	if _IconAssetId then
		HeaderIcon.Image = _IconAssetId
	end

	local Cursor = Instance.new("TextLabel")
	Cursor.Size = UDim2.fromOffset(20, 40)
	Cursor.Position = UDim2.fromOffset(15, 10)
	Cursor.BackgroundTransparency = 1
	Cursor.Text = "_"
	Cursor.Font = Enum.Font.Code
	Cursor.TextSize = 28
	Cursor.TextColor3 = C_TEXT
	Cursor.ZIndex = 10
	Cursor.Parent = Main
	table.insert(ThemeListeners, { type = "text_main", obj = Cursor })

	-- ヘッダー：最小化ボタン
	local Minimize = Instance.new("TextButton")
	Minimize.Size = UDim2.fromOffset(35, 35)
	Minimize.Position = UDim2.new(1, -85, 0, 10)
	Minimize.BackgroundTransparency = 1
	Minimize.Text = "-"
	Minimize.Font = Enum.Font.Code
	Minimize.TextSize = 24
	Minimize.TextColor3 = C_ACCENT_LT
	Minimize.ZIndex = 10
	Minimize.Parent = Main
	table.insert(ThemeListeners, { type = "text_lt", obj = Minimize })

	-- Minimizeボタンより左側に薄く by HertaIX Lib
	local ByLabel = Instance.new("TextLabel")
	ByLabel.Size = UDim2.fromOffset(130, 20)
	ByLabel.AnchorPoint = Vector2.new(1, 0.5)
	ByLabel.Position = UDim2.new(1, -92, 0, 27)
	ByLabel.BackgroundTransparency = 1
	ByLabel.Text = "by HertaIX Lib"
	ByLabel.Font = Enum.Font.Code
	ByLabel.TextSize = 11
	ByLabel.TextColor3 = C_ACCENT_LT
	ByLabel.TextTransparency = 0.6
	ByLabel.TextXAlignment = Enum.TextXAlignment.Right
	ByLabel.ZIndex = 10
	ByLabel.Parent = Main
	table.insert(ThemeListeners, { type = "text_lt", obj = ByLabel })

	-- ヘッダー：閉じるボタン（→ Rayfield風ミニバーに切り替え）
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
	HeaderLine.BackgroundColor3 = C_ACCENT
	HeaderLine.Parent = Main
	table.insert(ThemeListeners, { type = "headerline", obj = HeaderLine })

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
	CenterMark.BackgroundColor3 = C_ACCENT_LT
	CenterMark.ZIndex = 11
	CenterMark.Parent = Main
	table.insert(ThemeListeners, { type = "sweep", obj = CenterMark })

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
			-- TitleLabel の開始X(54px) + 実際のテキスト幅
			Cursor.Position = UDim2.fromOffset(54 + TitleLabel.TextBounds.X, 10)
		end
	end)

	-- 最小化（上端基準で畳む）
	local FullSize = Main.Size
	local Minimized = false

	Minimize.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		if Minimized then
			local absPos  = Main.AbsolutePosition
			local absSize = Main.AbsoluteSize
			local topY    = absPos.Y
			local centerX = absPos.X + absSize.X / 2
			Main.AnchorPoint = Vector2.new(0.5, 0)
			Main.Position = UDim2.new(0, centerX, 0, topY)
			TweenService:Create(
				Main,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Size = UDim2.new(FullSize.X.Scale, FullSize.X.Offset, 0, 55) }
			):Play()
		else
			TweenService:Create(
				Main,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Size = FullSize }
			):Play()
		end
	end)

	-- ============================================================
	--  Rayfield 風ミニバー（閉じるボタン → 再表示バー）
	-- ============================================================
	local MiniBar = Instance.new("TextButton")
	MiniBar.Size = UDim2.fromOffset(220, 28)
	MiniBar.AnchorPoint = Vector2.new(0.5, 0)
	MiniBar.Position = UDim2.new(0.5, 0, 0, -80)  -- 最初は画面外（十分上に隠す）
	MiniBar.BackgroundColor3 = C_BG
	MiniBar.BackgroundTransparency = 0.2
	MiniBar.BorderSizePixel = 0
	MiniBar.Text = ""
	MiniBar.ZIndex = 100
	MiniBar.Parent = ScreenGui
	table.insert(ThemeListeners, { type = "bg", obj = MiniBar })

	local MBCorner = Instance.new("UICorner")
	MBCorner.CornerRadius = UDim.new(0, 6)
	MBCorner.Parent = MiniBar

	local MBStroke = Instance.new("UIStroke")
	MBStroke.Color = C_ACCENT
	MBStroke.Thickness = 1
	MBStroke.Parent = MiniBar
	table.insert(ThemeListeners, { type = "stroke", obj = MBStroke })

	-- ミニバー：アイコン
	local MBIcon = Instance.new("ImageLabel")
	MBIcon.Size = UDim2.fromOffset(20, 20)
	MBIcon.AnchorPoint = Vector2.new(0, 0.5)
	MBIcon.Position = UDim2.fromOffset(8, 14)
	MBIcon.BackgroundTransparency = 1
	MBIcon.BorderSizePixel = 0
	MBIcon.ZIndex = 101
	MBIcon.Parent = MiniBar
	if _IconAssetId then
		MBIcon.Image = _IconAssetId
	end

	-- ミニバー：タイトルテキスト（titleText 左揃え）
	local MBLabel = Instance.new("TextLabel")
	MBLabel.Size = UDim2.new(1, -36, 1, 0)
	MBLabel.Position = UDim2.fromOffset(32, 0)
	MBLabel.BackgroundTransparency = 1
	MBLabel.Text = titleText
	MBLabel.Font = Enum.Font.Code
	MBLabel.TextSize = 14
	MBLabel.TextColor3 = C_ACCENT_LT
	MBLabel.TextXAlignment = Enum.TextXAlignment.Left
	MBLabel.ZIndex = 101
	MBLabel.Parent = MiniBar
	table.insert(ThemeListeners, { type = "text_lt", obj = MBLabel })

	-- ミニバー：右下に薄く HertaIX
	local MBSub = Instance.new("TextLabel")
	MBSub.Size = UDim2.fromOffset(80, 16)
	MBSub.AnchorPoint = Vector2.new(1, 1)
	MBSub.Position = UDim2.new(1, -6, 1, -3)
	MBSub.BackgroundTransparency = 1
	MBSub.Text = "HertaIX"
	MBSub.Font = Enum.Font.Code
	MBSub.TextSize = 10
	MBSub.TextColor3 = C_ACCENT_LT
	MBSub.TextTransparency = 0.6
	MBSub.TextXAlignment = Enum.TextXAlignment.Right
	MBSub.ZIndex = 101
	MBSub.Parent = MiniBar
	table.insert(ThemeListeners, { type = "text_lt", obj = MBSub })

	local MBAccent = Instance.new("Frame")
	MBAccent.Size = UDim2.new(1, 0, 0, 2)
	MBAccent.BorderSizePixel = 0
	MBAccent.BackgroundColor3 = C_ACCENT
	MBAccent.ZIndex = 101
	MBAccent.Parent = MiniBar
	table.insert(ThemeListeners, { type = "headerline", obj = MBAccent })

	local function ShowMiniBar()
		Main.Visible = false
		-- GuiInset（システムバー分）を考慮して画面最上端に配置
		local inset = game:GetService("GuiService"):GetGuiInset()
		MiniBar.Position = UDim2.new(0.5, 0, 0, -80)
		TweenService:Create(
			MiniBar,
			TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Position = UDim2.new(0.5, 0, 0, -inset.Y) }
		):Play()
	end

	local function HideMiniBar()
		TweenService:Create(
			MiniBar,
			TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ Position = UDim2.new(0.5, 0, 0, -80) }
		):Play()
		task.delay(0.2, function()
			Main.Visible = true
		end)
	end

	Close.MouseButton1Click:Connect(ShowMiniBar)
	MiniBar.MouseButton1Click:Connect(HideMiniBar)

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
			t.Button.TextColor3 = active and C_ACCENT_LT or C_DARK
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
		table.insert(ThemeListeners, { type = "text_dark", obj = Btn })

		local Underline = Instance.new("Frame")
		Underline.Size = UDim2.new(1, 0, 0, 2)
		Underline.Position = UDim2.new(0, 0, 1, -2)
		Underline.BorderSizePixel = 0
		Underline.BackgroundColor3 = C_ACCENT
		Underline.Visible = false
		Underline.ZIndex = 10
		Underline.Parent = Btn
		table.insert(ThemeListeners, { type = "underline", obj = Underline })

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.fromScale(1, 1)
		Page.BackgroundTransparency = 1
		Page.BorderSizePixel = 0
		Page.ScrollBarThickness = 3
		Page.ScrollBarImageColor3 = C_ACCENT
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

			local Bg = MakeHertaFrame(tabEntry.Page, UDim2.new(1, 0, 0, 36), NextOrder())

			local Toggle = Instance.new("TextButton")
			Toggle.Size = UDim2.fromScale(1, 1)
			Toggle.BackgroundTransparency = 1
			Toggle.Text = ""
			Toggle.Parent = Bg

			local NameLabel = Instance.new("TextLabel")
			NameLabel.BackgroundTransparency = 1
			NameLabel.Size = UDim2.new(0.7, -8, 1, 0)
			NameLabel.Position = UDim2.fromOffset(10, 0)
			NameLabel.Text = labelText
			NameLabel.Font = Enum.Font.Code
			NameLabel.TextSize = 17
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.TextColor3 = C_ACCENT_LT
			NameLabel.Parent = Toggle
			table.insert(ThemeListeners, { type = "text_lt", obj = NameLabel })

			local BadgeBg = Instance.new("Frame")
			BadgeBg.Size = UDim2.fromOffset(52, 22)
			BadgeBg.AnchorPoint = Vector2.new(1, 0.5)
			BadgeBg.Position = UDim2.new(1, -10, 0.5, 0)
			BadgeBg.BackgroundColor3 = C_BG
			BadgeBg.BackgroundTransparency = 0.3
			BadgeBg.BorderSizePixel = 0
			BadgeBg.Parent = Toggle
			table.insert(ThemeListeners, { type = "bg", obj = BadgeBg })

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
					StateLabel.TextColor3 = C_ACCENT
					BadgeStroke.Color = C_ACCENT
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

			local Bg = MakeHertaFrame(tabEntry.Page, UDim2.new(1, 0, 0, 56), NextOrder())

			local NameLabel = Instance.new("TextLabel")
			NameLabel.Size = UDim2.new(0.65, 0, 0, 24)
			NameLabel.Position = UDim2.fromOffset(10, 4)
			NameLabel.BackgroundTransparency = 1
			NameLabel.Text = labelText
			NameLabel.Font = Enum.Font.Code
			NameLabel.TextSize = 16
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.TextColor3 = C_ACCENT_LT
			NameLabel.Parent = Bg
			table.insert(ThemeListeners, { type = "text_lt", obj = NameLabel })

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.new(0.3, -10, 0, 24)
			ValueLabel.Position = UDim2.new(0.7, 0, 0, 4)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Font = Enum.Font.Code
			ValueLabel.TextSize = 16
			ValueLabel.TextColor3 = C_ACCENT
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = Bg
			table.insert(ThemeListeners, { type = "text_accent", obj = ValueLabel })

			local TrackBg = Instance.new("Frame")
			TrackBg.Size = UDim2.new(1, -20, 0, 6)
			TrackBg.Position = UDim2.new(0, 10, 0, 34)
			TrackBg.BackgroundColor3 = C_BG
			TrackBg.BackgroundTransparency = 0.2
			TrackBg.BorderSizePixel = 0
			TrackBg.Parent = Bg
			table.insert(ThemeListeners, { type = "track", obj = TrackBg })

			local TrackCorner = Instance.new("UICorner")
			TrackCorner.CornerRadius = UDim.new(1, 0)
			TrackCorner.Parent = TrackBg

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new(0, 0, 1, 0)
			Fill.BackgroundColor3 = C_ACCENT
			Fill.BorderSizePixel = 0
			Fill.Parent = TrackBg
			table.insert(ThemeListeners, { type = "fill", obj = Fill })

			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = Fill

			local Knob = Instance.new("Frame")
			Knob.Size = UDim2.fromOffset(14, 14)
			Knob.AnchorPoint = Vector2.new(0.5, 0.5)
			Knob.Position = UDim2.new(0, 0, 0.5, 0)
			Knob.BackgroundColor3 = C_ACCENT_LT
			Knob.BorderSizePixel = 0
			Knob.ZIndex = 2
			Knob.Parent = TrackBg
			table.insert(ThemeListeners, { type = "knob", obj = Knob })

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
		function Tab:AddDropdown(titleText2, options, callback)

			local Selected = nil
			local Open     = false

			local Container = Instance.new("Frame")
			Container.Size = UDim2.new(1, 0, 0, 36)
			Container.BackgroundTransparency = 1
			Container.BorderSizePixel = 0
			Container.ClipsDescendants = false
			Container.LayoutOrder = NextOrder()
			Container.ZIndex = 20
			Container.Parent = tabEntry.Page

			local MainButton = Instance.new("TextButton")
			MainButton.Size = UDim2.new(1, 0, 0, 36)
			MainButton.BackgroundColor3 = C_BG
			MainButton.BackgroundTransparency = 0.45
			MainButton.BorderSizePixel = 0
			MainButton.Text = ""
			MainButton.ZIndex = 20
			MainButton.Parent = Container
			table.insert(ThemeListeners, { type = "bg", obj = MainButton })

			local MBCorner2 = Instance.new("UICorner")
			MBCorner2.CornerRadius = UDim.new(0, 4)
			MBCorner2.Parent = MainButton

			local MBStroke2 = Instance.new("UIStroke")
			MBStroke2.Color = C_ACCENT
			MBStroke2.Thickness = 1
			MBStroke2.Transparency = 0.5
			MBStroke2.Parent = MainButton
			table.insert(ThemeListeners, { type = "stroke", obj = MBStroke2 })

			-- 4隅コーナー
			MakeCorner(MainButton, 0, 0)
			MakeCorner(MainButton, 1, 0)
			MakeCorner(MainButton, 0, 1)
			MakeCorner(MainButton, 1, 1)

			local Header = Instance.new("TextLabel")
			Header.Size = UDim2.new(1, -10, 1, 0)
			Header.Position = UDim2.fromOffset(10, 0)
			Header.BackgroundTransparency = 1
			Header.Font = Enum.Font.Code
			Header.TextSize = 16
			Header.TextColor3 = C_ACCENT_LT
			Header.TextXAlignment = Enum.TextXAlignment.Left
			Header.Text = titleText2 .. "  ▼"
			Header.ZIndex = 21
			Header.Parent = MainButton
			table.insert(ThemeListeners, { type = "text_lt", obj = Header })

			local ListFrame = Instance.new("Frame")
			ListFrame.Size = UDim2.new(1, 0, 0, 0)
			ListFrame.Position = UDim2.new(0, 0, 1, 2)
			ListFrame.BackgroundColor3 = C_BG
			ListFrame.BackgroundTransparency = 0.3
			ListFrame.BorderSizePixel = 0
			ListFrame.ClipsDescendants = true
			ListFrame.ZIndex = 22
			ListFrame.Parent = Container
			table.insert(ThemeListeners, { type = "bg", obj = ListFrame })

			local LFCorner = Instance.new("UICorner")
			LFCorner.CornerRadius = UDim.new(0, 4)
			LFCorner.Parent = ListFrame

			local LFStroke = Instance.new("UIStroke")
			LFStroke.Color = C_ACCENT
			LFStroke.Thickness = 1
			LFStroke.Transparency = 0.5
			LFStroke.Parent = ListFrame
			table.insert(ThemeListeners, { type = "stroke", obj = LFStroke })

			local Layout = Instance.new("UIListLayout")
			Layout.SortOrder = Enum.SortOrder.LayoutOrder
			Layout.Parent = ListFrame

			local function UpdateHeader()
				Header.Text = (Selected and tostring(Selected) or titleText2) .. "  ▼"
				Header.TextColor3 = Selected and C_ACCENT or C_ACCENT_LT
				MBStroke2.Color = C_ACCENT
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
					Opt.TextColor3 = C_ACCENT_LT
					Opt.TextXAlignment = Enum.TextXAlignment.Left
					Opt.Text = "  " .. tostring(optName)
					Opt.LayoutOrder = i
					Opt.ZIndex = 23
					Opt.Parent = ListFrame
					table.insert(ThemeListeners, { type = "text_lt", obj = Opt })

					Opt.MouseEnter:Connect(function() Opt.TextColor3 = C_ACCENT end)
					Opt.MouseLeave:Connect(function() Opt.TextColor3 = C_ACCENT_LT end)

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

			local Bg = MakeHertaFrame(tabEntry.Page, UDim2.new(1, 0, 0, 30), NextOrder())

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -10, 1, 0)
			Label.Position = UDim2.fromOffset(10, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text or ""
			Label.Font = Enum.Font.Code
			Label.TextSize = 15
			Label.TextColor3 = C_ACCENT_LT
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = Bg
			table.insert(ThemeListeners, { type = "text_lt", obj = Label })

			local obj = {}
			function obj:Set(v) Label.Text = tostring(v) end
			function obj:Get() return Label.Text end
			return obj
		end

		-- --------------------------------------------------------
		--  Tab:AddParagraph(titleText, descText)
		-- --------------------------------------------------------
		function Tab:AddParagraph(pTitle, descText)

			local Bg = Instance.new("Frame")
			Bg.Size = UDim2.new(1, 0, 0, 60)
			Bg.BackgroundColor3 = C_BG
			Bg.BackgroundTransparency = 0.55
			Bg.BorderSizePixel = 0
			Bg.LayoutOrder = NextOrder()
			Bg.Parent = tabEntry.Page
			table.insert(ThemeListeners, { type = "bg", obj = Bg })

			local BgCorner = Instance.new("UICorner")
			BgCorner.CornerRadius = UDim.new(0, 4)
			BgCorner.Parent = Bg

			local TopLine = Instance.new("Frame")
			TopLine.Size = UDim2.new(1, 0, 0, 2)
			TopLine.BorderSizePixel = 0
			TopLine.BackgroundColor3 = C_ACCENT
			TopLine.Parent = Bg
			table.insert(ThemeListeners, { type = "headerline", obj = TopLine })

			local BottomLine = Instance.new("Frame")
			BottomLine.BorderSizePixel = 0
			BottomLine.BackgroundColor3 = C_ACCENT
			BottomLine.Parent = Bg
			table.insert(ThemeListeners, { type = "headerline", obj = BottomLine })

			local TitleLbl = Instance.new("TextLabel")
			TitleLbl.Size = UDim2.new(1, -10, 0, 22)
			TitleLbl.Position = UDim2.fromOffset(8, 2)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = pTitle or ""
			TitleLbl.Font = Enum.Font.Code
			TitleLbl.TextSize = 15
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
			TitleLbl.TextColor3 = C_ACCENT_LT
			TitleLbl.Parent = Bg
			table.insert(ThemeListeners, { type = "text_lt", obj = TitleLbl })

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
			Desc.TextColor3 = C_ACCENT_MID
			Desc.Text = descText or ""
			Desc.Parent = Bg
			table.insert(ThemeListeners, { type = "text_mid", obj = Desc })

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
		table.insert(ThemeListeners, { type = "bg", obj = Notification })

		local NCorner = Instance.new("UICorner")
		NCorner.CornerRadius = UDim.new(0, 6)
		NCorner.Parent = Notification

		local NStroke = Instance.new("UIStroke")
		NStroke.Color = C_ACCENT
		NStroke.Thickness = 1
		NStroke.Parent = Notification
		table.insert(ThemeListeners, { type = "stroke", obj = NStroke })

		local AccentLine = Instance.new("Frame")
		AccentLine.Size = UDim2.new(1, 0, 0, 2)
		AccentLine.BorderSizePixel = 0
		AccentLine.BackgroundColor3 = C_ACCENT
		AccentLine.Parent = Notification
		table.insert(ThemeListeners, { type = "headerline", obj = AccentLine })

		local TitleLbl = Instance.new("TextLabel")
		TitleLbl.Size = UDim2.new(1, -10, 0, 26)
		TitleLbl.Position = UDim2.fromOffset(8, 4)
		TitleLbl.BackgroundTransparency = 1
		TitleLbl.Text = title
		TitleLbl.Font = Enum.Font.Code
		TitleLbl.TextSize = 17
		TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
		TitleLbl.TextColor3 = C_ACCENT_LT
		TitleLbl.Parent = Notification
		table.insert(ThemeListeners, { type = "text_lt", obj = TitleLbl })

		local MsgLbl = Instance.new("TextLabel")
		MsgLbl.Size = UDim2.new(1, -10, 0, 36)
		MsgLbl.Position = UDim2.fromOffset(8, 32)
		MsgLbl.BackgroundTransparency = 1
		MsgLbl.Text = message
		MsgLbl.Font = Enum.Font.Code
		MsgLbl.TextSize = 13
		MsgLbl.TextXAlignment = Enum.TextXAlignment.Left
		MsgLbl.TextWrapped = true
		MsgLbl.TextColor3 = C_ACCENT_MID
		MsgLbl.Parent = Notification
		table.insert(ThemeListeners, { type = "text_mid", obj = MsgLbl })

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
return HertaIX
