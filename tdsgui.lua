local user_input_service = game:GetService("UserInputService")
local http_service = game:GetService("HttpService")
local local_player = game.Players.LocalPlayer
local gui_parent = gethui and gethui() or game:GetService("CoreGui")

-- Eski GUI'yi temizle
local old_gui = gui_parent:FindFirstChild("KiwiStratsGui")
if old_gui then old_gui:Destroy() end

local CONFIG_FILE = "KiwiStrats_Config.json"

-- Renk Paleti (Kivi Teması)
local KIWI_GREEN = Color3.fromRGB(118, 186, 27) -- Canlı Kivi Yeşili
local KIWI_DARK_BROWN = Color3.fromRGB(40, 30, 20) -- Kivi Kabuğu Kahvesi
local KIWI_BG = Color3.fromRGB(25, 20, 15) -- Çok Koyu Arka Plan
local KIWI_LIGHT = Color3.fromRGB(240, 255, 230) -- Hafif Krem/Yeşil Yazı

_G.AutoMercenary = _G.AutoMercenary or false
_G.PathDistance = _G.PathDistance or 0
_G.SellFarms = _G.SellFarms or false
_G.SellFarmsWave = _G.SellFarmsWave or 39

local function save_settings()
    local data = {
        AutoSkip = _G.AutoSkip,
        AutoPickups = _G.AutoPickups,
        AutoChain = _G.AutoChain,
        AutoDJ = _G.AutoDJ,
        AntiLag = _G.AntiLag,
        ClaimRewards = _G.ClaimRewards,
        SendWebhook = _G.SendWebhook,
        WebhookURL = _G.WebhookURL,
        AutoMercenary = _G.AutoMercenary,
        PathDistance = _G.PathDistance,
        SellFarms = _G.SellFarms,
        SellFarmsWave = _G.SellFarmsWave
    }
    writefile(CONFIG_FILE, http_service:JSONEncode(data))
end

local function load_settings()
    local default = {
        AutoSkip = false, AutoPickups = false, AutoChain = false, AutoDJ = false,
        AntiLag = false, ClaimRewards = false, SendWebhook = false, WebhookURL = "",
        AutoMercenary = false, PathDistance = 0, SellFarms = false, SellFarmsWave = 13
    }
    if isfile(CONFIG_FILE) then
        local success, decoded = pcall(function() return http_service:JSONDecode(readfile(CONFIG_FILE)) end)
        if success then
            for k, v in pairs(decoded) do _G[k] = v end
            return
        end
    end
    for k, v in pairs(default) do _G[k] = v end
end

load_settings()

local tds_gui = Instance.new("ScreenGui")
tds_gui.Name = "KiwiStratsGui"
tds_gui.Parent = gui_parent
tds_gui.ResetOnSpawn = false

local main_frame = Instance.new("Frame")
main_frame.Name = "MainFrame"
main_frame.Parent = tds_gui
main_frame.Size = UDim2.new(0, 380, 0, 380)
main_frame.Position = UDim2.new(0.5, -190, 0.5, -190)
main_frame.BackgroundColor3 = KIWI_BG
main_frame.BorderSizePixel = 0
main_frame.Active = true
main_frame.ClipsDescendants = true

Instance.new("UICorner", main_frame).CornerRadius = UDim.new(0, 10)
local main_stroke = Instance.new("UIStroke", main_frame)
main_stroke.Color = KIWI_GREEN
main_stroke.Thickness = 1.2

local header_frame = Instance.new("Frame", main_frame)
header_frame.Size = UDim2.new(1, 0, 0, 45)
header_frame.BackgroundColor3 = KIWI_DARK_BROWN
header_frame.BorderSizePixel = 0
Instance.new("UICorner", header_frame).CornerRadius = UDim.new(0, 10)

local title_label = Instance.new("TextLabel", header_frame)
title_label.Size = UDim2.new(1, -90, 1, 0)
title_label.Position = UDim2.new(0, 15, 0, 0)
title_label.Text = "🥝 KIWI STRATS"
title_label.TextColor3 = KIWI_LIGHT
title_label.BackgroundTransparency = 1
title_label.Font = Enum.Font.GothamBold
title_label.TextSize = 16
title_label.TextXAlignment = Enum.TextXAlignment.Left

local min_btn = Instance.new("TextButton", header_frame)
min_btn.Size = UDim2.new(0, 24, 0, 24)
min_btn.Position = UDim2.new(1, -35, 0.5, -12)
min_btn.BackgroundColor3 = KIWI_GREEN
min_btn.Text = "-"
min_btn.TextColor3 = KIWI_BG
min_btn.Font = Enum.Font.GothamBold
min_btn.TextSize = 18
Instance.new("UICorner", min_btn).CornerRadius = UDim.new(0, 6)

local open_button = Instance.new("TextButton", tds_gui)
open_button.Size = UDim2.new(0, 120, 0, 35)
open_button.Position = UDim2.new(0.5, -60, 0, 10)
open_button.BackgroundColor3 = KIWI_DARK_BROWN
open_button.Text = "🥝 KIWI STRATS"
open_button.TextColor3 = KIWI_GREEN
open_button.Font = Enum.Font.GothamBold
open_button.TextSize = 12
open_button.Visible = false
Instance.new("UICorner", open_button).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", open_button).Color = KIWI_GREEN

local function toggle_gui()
    local is_visible = main_frame.Visible
    main_frame.Visible = not is_visible
    open_button.Visible = is_visible
end

min_btn.MouseButton1Click:Connect(toggle_gui)
open_button.MouseButton1Click:Connect(toggle_gui)

local tab_bar = Instance.new("Frame", main_frame)
tab_bar.Size = UDim2.new(1, 0, 0, 30)
tab_bar.Position = UDim2.new(0, 0, 0, 45)
tab_bar.BackgroundColor3 = Color3.fromRGB(35, 28, 20)
tab_bar.BorderSizePixel = 0

local tab_layout = Instance.new("UIListLayout", tab_bar)
tab_layout.FillDirection = Enum.FillDirection.Horizontal

local function create_tab_btn(name)
    local btn = Instance.new("TextButton", tab_bar)
    btn.Size = UDim2.new(0.333, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(120, 110, 100)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    return btn
end

local logger_btn = create_tab_btn("LOGGER")
local main_tab_btn = create_tab_btn("MAIN")
local misc_tab_btn = create_tab_btn("MISC")

local content_holder = Instance.new("Frame", main_frame)
content_holder.Size = UDim2.new(1, 0, 1, -110)
content_holder.Position = UDim2.new(0, 0, 0, 75)
content_holder.BackgroundTransparency = 1

local function create_page()
    local page = Instance.new("ScrollingFrame", content_holder)
    page.Size = UDim2.new(1, -24, 1, -10)
    page.Position = UDim2.new(0, 12, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = KIWI_GREEN
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return page
end

local logger_page = create_page()
local main_page = create_page()
local misc_page = create_page()

local function create_toggle(display_name, global_var, parent)
    local toggle_bg = Instance.new("Frame", parent)
    toggle_bg.Size = UDim2.new(1, 0, 0, 35)
    toggle_bg.BackgroundColor3 = KIWI_DARK_BROWN
    Instance.new("UICorner", toggle_bg).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel", toggle_bg)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = display_name
    label.TextColor3 = KIWI_LIGHT
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton", toggle_bg)
    btn.Size = UDim2.new(0, 38, 0, 20)
    btn.Position = UDim2.new(1, -48, 0.5, -10)
    btn.BackgroundColor3 = _G[global_var] and KIWI_GREEN or Color3.fromRGB(60, 50, 40)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = _G[global_var] and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    btn.MouseButton1Click:Connect(function()
        _G[global_var] = not _G[global_var]
        btn.BackgroundColor3 = _G[global_var] and KIWI_GREEN or Color3.fromRGB(60, 50, 40)
        circle:TweenPosition(_G[global_var] and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7), "Out", "Quad", 0.15, true)
        save_settings()
    end)
    return toggle_bg
end

local function create_slider(display_name, global_var, min, max, parent)
    local slider_bg = Instance.new("Frame", parent)
    slider_bg.Size = UDim2.new(1, 0, 0, 50)
    slider_bg.BackgroundColor3 = KIWI_DARK_BROWN
    Instance.new("UICorner", slider_bg).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", slider_bg)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = display_name .. ": " .. tostring(_G[global_var])
    label.TextColor3 = KIWI_LIGHT
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left

    local slide_bar = Instance.new("Frame", slider_bg)
    slide_bar.Size = UDim2.new(1, -24, 0, 4)
    slide_bar.Position = UDim2.new(0, 12, 0, 35)
    slide_bar.BackgroundColor3 = Color3.fromRGB(60, 50, 40)
    Instance.new("UICorner", slide_bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", slide_bar)
    fill.Size = UDim2.new((_G[global_var] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = KIWI_GREEN
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", slide_bar)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((_G[global_var] - min) / (max - min), -6, 0.5, -6)
    knob.BackgroundColor3 = KIWI_LIGHT
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function move_knob(input)
        local pos = math.clamp((input.Position.X - slide_bar.AbsolutePosition.X) / slide_bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        _G[global_var] = value
        label.Text = display_name .. ": " .. tostring(value)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -6, 0.5, -6)
        save_settings()
    end

    local sliding = false
    knob.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end end)
    user_input_service.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
    user_input_service.InputChanged:Connect(function(input) if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then move_knob(input) end end)
end

-- Sayfa İçeriklerini Oluştur
create_toggle("Auto Skip Waves", "AutoSkip", main_page)
create_toggle("Auto Chain", "AutoChain", main_page)
create_toggle("Auto DJ Booth", "AutoDJ", main_page)
create_toggle("Auto Mercenary Base", "AutoMercenary", main_page)
create_slider("Path Distance", "PathDistance", 0, 300, main_page)
create_toggle("Auto Collect Pickups", "AutoPickups", main_page)

create_toggle("Enable Anti-Lag", "AntiLag", misc_page)
create_toggle("Claim Rewards", "ClaimRewards", misc_page)
create_toggle("Send Discord Webhook", "SendWebhook", misc_page)

local function SwitchTab(tabName)
    logger_page.Visible = (tabName == "LOGGER"); main_page.Visible = (tabName == "MAIN"); misc_page.Visible = (tabName == "MISC")
    logger_btn.TextColor3 = (tabName == "LOGGER") and KIWI_GREEN or Color3.fromRGB(120, 110, 100)
    main_tab_btn.TextColor3 = (tabName == "MAIN") and KIWI_GREEN or Color3.fromRGB(120, 110, 100)
    misc_tab_btn.TextColor3 = (tabName == "MISC") and KIWI_GREEN or Color3.fromRGB(120, 110, 100)
end

logger_btn.MouseButton1Click:Connect(function() SwitchTab("LOGGER") end)
main_tab_btn.MouseButton1Click:Connect(function() SwitchTab("MAIN") end)
misc_tab_btn.MouseButton1Click:Connect(function() SwitchTab("MISC") end)
SwitchTab("LOGGER")

-- Footer ve Zamanlayıcı
local footer_frame = Instance.new("Frame", main_frame)
footer_frame.Size = UDim2.new(1, 0, 0, 35); footer_frame.Position = UDim2.new(0, 0, 1, -35); footer_frame.BackgroundTransparency = 1
local status_text = Instance.new("TextLabel", footer_frame); status_text.Size = UDim2.new(0.5, -15, 1, 0); status_text.Position = UDim2.new(0, 15, 0, 0); status_text.BackgroundTransparency = 1; status_text.Text = "● <font color='#76ba1b'>Idle</font>"; status_text.TextColor3 = KIWI_LIGHT; status_text.Font = Enum.Font.GothamMedium; status_text.RichText = true; status_text.TextSize = 11; status_text.TextXAlignment = Enum.TextXAlignment.Left
local clock_label = Instance.new("TextLabel", footer_frame); clock_label.Size = UDim2.new(0.5, -15, 1, 0); clock_label.Position = UDim2.new(0.5, 0, 0, 0); clock_label.BackgroundTransparency = 1; clock_label.Text = "00:00:00"; clock_label.TextColor3 = KIWI_GREEN; clock_label.Font = Enum.Font.GothamBold; clock_label.TextSize = 10; clock_label.TextXAlignment = Enum.TextXAlignment.Right

-- Sürükleme ve Boyutlandırma (Gelişmiş)
local dragging, resizing = false, false
local drag_start, start_pos, target_pos = nil, nil, main_frame.Position
header_frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; drag_start = input.Position; start_pos = main_frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
user_input_service.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - drag_start
        target_pos = UDim2.new(start_pos.X.Scale, start_pos.X.Offset + delta.X, start_pos.Y.Scale, start_pos.Y.Offset + delta.Y)
    end
end)
game:GetService("RunService").RenderStepped:Connect(function() main_frame.Position = main_frame.Position:Lerp(target_pos, 0.2) end)

local session_start = tick()
task.spawn(function()
    while task.wait(1) do
        local elapsed = tick() - session_start
        local h, m, s = math.floor(elapsed / 3600), math.floor((elapsed % 3600) / 60), math.floor(elapsed % 60)
        clock_label.Text = string.format("%02d:%02d:%02d", h, m, s)
    end
end)

shared.KiwiStratsGUI = {
    Console = logger_page,
    Status = function(new_status) status_text.Text = "● <font color='#76ba1b'>" .. tostring(new_status) .. "</font>" end
}
