-- ============================================================
--  HoloLib 使用例スクリプト（LocalScript に貼り付けて使用）
--  ※ URL の部分は実際のホスティング先に変更してください
-- ============================================================

local HoloLib = loadstring(game:HttpGet("https://your-url/HoloLib.txt"))()

-- ウィンドウを作成（タイトルはタイプライター演出で表示）
local Window = HoloLib:CreateWindow("HOLOGRAM SYSTEM")

-- 起動通知
Window:Notify("SYSTEM", "HoloLib Loaded", 3)

-- ============================================================
--  タブ 1 : PLAYER
-- ============================================================
local PlayerTab = Window:CreateTab("PLAYER")

-- ステータスラベル（リアルタイム更新可能）
local StatusLabel = PlayerTab:AddLabel("Status : Online")

-- 1秒後にラベルを更新する例
task.delay(1, function()
    StatusLabel:Set("Status : Active")
end)

-- トグル：ESP
local EspToggle = PlayerTab:AddToggle("ESP", false, function(enabled)
    print("ESP:", enabled)
end)

-- トグル：Aimbot
PlayerTab:AddToggle("Aimbot", false, function(enabled)
    print("Aimbot:", enabled)
end)

-- スライダー：FOV
local FovSlider = PlayerTab:AddSlider("FOV", {
    Min     = 10,
    Max     = 180,
    Default = 90,
}, function(value)
    print("FOV:", value)
end)

-- 説明ブロック
PlayerTab:AddParagraph("ESP について", "壁越しにプレイヤーを\n表示します。")

-- ============================================================
--  タブ 2 : VISUAL
-- ============================================================
local VisualTab = Window:CreateTab("VISUAL")

-- トグル：フルブライト
VisualTab:AddToggle("Fullbright", false, function(enabled)
    print("Fullbright:", enabled)
end)

-- スライダー：明るさ
VisualTab:AddSlider("Brightness", {
    Min     = 0,
    Max     = 100,
    Default = 50,
}, function(value)
    print("Brightness:", value)
end)

-- 説明ブロック
VisualTab:AddParagraph("VISUAL", "視覚エフェクトの設定です。")

-- ============================================================
--  タブ 3 : MISC
-- ============================================================
local MiscTab = Window:CreateTab("MISC")

MiscTab:AddLabel("Version : 1.0.0")

MiscTab:AddToggle("Auto-Farm", false, function(enabled)
    print("Auto-Farm:", enabled)
end)

MiscTab:AddSlider("Walk Speed", {
    Min     = 16,
    Max     = 200,
    Default = 16,
}, function(value)
    game.Players.LocalPlayer.Character
        and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        and (game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value)
end)

-- 通知を任意のタイミングで呼び出す例
-- Window:Notify("SUCCESS", "ESP Enabled", 3)
-- Window:Notify("WARNING", "Connection Lost", 5)
