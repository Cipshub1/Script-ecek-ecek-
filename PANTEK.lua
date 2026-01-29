--====================================================
-- CIPIK HUB | ETHER-FIRE EDITION (TOTAL RESTORATION 2026)
-- UPDATE: AIMLOCK WITH VISIBLE CHECK (WALL CHECK)
--====================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Cleanup UI Lama
pcall(function() 
    if LP.PlayerGui:FindFirstChild("CipikSupreme") then LP.PlayerGui.CipikSupreme:Destroy() end
end)

local Gui = Instance.new("ScreenGui", LP.PlayerGui)
Gui.Name = "CipikSupreme"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false 

local Blur = Instance.new("BlurEffect", Lighting)
Blur.Size = 0
Blur.Enabled = true

--========================
-- THEME & CONFIG
--========================
local Theme = {
    Main = Color3.fromRGB(20, 10, 5),
    Sidebar = Color3.fromRGB(35, 15, 5),
    Accent = Color3.fromRGB(255, 130, 0),
    Glow = Color3.fromRGB(255, 40, 0),
    Text = Color3.fromRGB(255, 230, 200),
    GlassTrans = 0.2
}

-- Variables
local SpeedOn, JumpOn, NoClip, CamFreeze = false, false, false, false
local SpeedVal, JumpVal = 16, 50
local SelectedTarget, TrollTarget = nil, nil
local TPFollow, BodyLock = false, false
local FollowDistance = 4
local ViewOn, Flinging = false, false
local ESP_Mode = "None"
local ESP_Name_Enabled = false
local AimlockOn = false

local function Round(obj, rad)
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, rad)
end

--========================
-- FUNCTION: DRAGGABLE
--========================
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--========================
-- MAIN INTERFACE
--========================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromOffset(620, 420)
Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Theme.Main
Main.BackgroundTransparency = Theme.GlassTrans
Main.Visible = false
Round(Main, 20)

local DragHandle = Instance.new("Frame", Main)
DragHandle.Size = UDim2.new(1, 0, 0, 40)
DragHandle.BackgroundTransparency = 1
MakeDraggable(Main, DragHandle)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
local StrokeGrad = Instance.new("UIGradient", MainStroke)
StrokeGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Theme.Glow),
    ColorSequenceKeypoint.new(0.5, Theme.Accent),
    ColorSequenceKeypoint.new(1, Theme.Glow)
}
RunService.RenderStepped:Connect(function() StrokeGrad.Rotation += 2 end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BackgroundTransparency = 0.4
Round(Sidebar, 20)
MakeDraggable(Main, Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 70)
Title.Text = "🔥 CIPIK HUB"
Title.Font = "GothamBlack"
Title.TextColor3 = Theme.Accent
Title.TextSize = 20
Title.BackgroundTransparency = 1

local TabHolder = Instance.new("Frame", Sidebar)
TabHolder.Size = UDim2.new(1, -20, 1, -100)
TabHolder.Position = UDim2.fromOffset(10, 80)
TabHolder.BackgroundTransparency = 1
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 8)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -210, 1, -40)
Container.Position = UDim2.fromOffset(195, 20)
Container.BackgroundTransparency = 1

--========================
-- UI BUILDER
--========================
local Pages = {}

local function NewTab(name, icon)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. icon .. "  " .. name
    btn.Font = "GothamBold"
    btn.TextColor3 = Color3.fromRGB(180, 130, 80)
    btn.TextSize = 12
    btn.TextXAlignment = "Left"
    Round(btn, 10)

    local page = Instance.new("ScrollingFrame", Container)
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.Accent
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)

    Pages[name] = {btn = btn, page = page}
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do
            v.page.Visible = false
            TweenService:Create(v.btn, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 130, 80)}):Play()
        end
        page.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.8, TextColor3 = Theme.Accent}):Play()
    end)
    return page
end

local function AddToggle(parent, text, default, callback)
    local tgl = Instance.new("TextButton", parent)
    tgl.Size = UDim2.new(0.96, 0, 0, 45)
    tgl.BackgroundColor3 = Color3.new(0,0,0)
    tgl.BackgroundTransparency = 0.7
    tgl.Text = ""
    Round(tgl, 12)

    local l = Instance.new("TextLabel", tgl)
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.fromOffset(15, 0)
    l.Text = text
    l.Font = "GothamMedium"
    l.TextColor3 = Theme.Text
    l.TextSize = 13
    l.TextXAlignment = "Left"
    l.BackgroundTransparency = 1

    local sw = Instance.new("Frame", tgl)
    sw.Size = UDim2.fromOffset(34, 16)
    sw.Position = UDim2.new(1, -45, 0.5, -8)
    sw.BackgroundColor3 = Color3.fromRGB(60, 30, 10)
    Round(sw, 10)

    local dot = Instance.new("Frame", sw)
    dot.Size = UDim2.fromOffset(10, 10)
    dot.Position = UDim2.fromOffset(3, 3)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Round(dot, 10)

    local active = default
    local function update()
        callback(active)
        TweenService:Create(sw, TweenInfo.new(0.3), {BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(60, 30, 10)}):Play()
        TweenService:Create(dot, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = active and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3)}):Play()
    end
    tgl.MouseButton1Click:Connect(function() active = not active; update() end)
    update()
end

local function AddButton(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.96, 0, 0, 38)
    b.BackgroundColor3 = Theme.Accent
    b.BackgroundTransparency = 0.85
    b.Text = text
    b.Font = "GothamBold"
    b.TextColor3 = Theme.Text
    b.TextSize = 12
    Round(b, 10)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

--========================
-- TABS
--========================
local Tab1 = NewTab("Player", "👤")
local Tab2 = NewTab("Move/Troll", "🌪️")
local Tab3 = NewTab("Aim", "🔫")
local Tab4 = NewTab("Target", "🎯")
local Tab5 = NewTab("Visuals", "👁️")
local Tab6 = NewTab("Misc", "⚙️")

-- PLAYER
AddToggle(Tab1, "WalkSpeed Bypass", false, function(v) SpeedOn = v end)
AddButton(Tab1, "Speed +10", function() SpeedVal = math.clamp(SpeedVal + 10, 16, 500) end)
AddButton(Tab1, "Speed -10", function() SpeedVal = math.clamp(SpeedVal - 10, 16, 500) end)
AddToggle(Tab1, "JumpPower Bypass", false, function(v) JumpOn = v end)
AddToggle(Tab1, "NoClip", false, function(v) NoClip = v end)
AddToggle(Tab1, "Infinite Jump", false, function(v) _G.InfJump = v end)

-- MOVE/TROLL
local TrollDisplay = Instance.new("TextLabel", Tab2)
TrollDisplay.Size = UDim2.new(0.96, 0, 0, 25); TrollDisplay.Text = "Target: None"; TrollDisplay.TextColor3 = Theme.Accent; TrollDisplay.BackgroundTransparency = 1; TrollDisplay.Font = "GothamBold"

AddButton(Tab2, "Select Troll Target", function()
    local d = Instance.new("ScrollingFrame", Tab2); d.Size = UDim2.new(0.96,0,0,100); d.BackgroundColor3 = Color3.new(0,0,0); d.BackgroundTransparency = 0.6; Round(d, 10); Instance.new("UIListLayout", d)
    for _,p in pairs(Players:GetPlayers()) do if p ~= LP then
        AddButton(d, p.Name, function() TrollTarget = p; TrollDisplay.Text = "Target: "..p.Name; d:Destroy() end).Size = UDim2.new(1,0,0,30)
    end end
end)
AddToggle(Tab2, "View Target (Spectate)", false, function(v) ViewOn = v end)
AddButton(Tab2, "FLING PLAYER", function()
    if not TrollTarget or not TrollTarget.Character then return end
    Flinging = true; local oldCF = LP.Character.HumanoidRootPart.CFrame
    local endT = tick() + 2.5
    while tick() < endT and Flinging do
        RunService.Heartbeat:Wait()
        if TrollTarget.Character and TrollTarget.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = TrollTarget.Character.HumanoidRootPart.CFrame
            LP.Character.HumanoidRootPart.Velocity = Vector3.new(500000, 500000, 500000)
        end
    end
    Flinging = false; LP.Character.HumanoidRootPart.Velocity = Vector3.zero; LP.Character.HumanoidRootPart.CFrame = oldCF
end)

-- AIM (IMPROVED WITH VISIBLE CHECK)
AddToggle(Tab3, "Aimlock (Visible Only)", false, function(v) AimlockOn = v end)
AddButton(Tab3, "Refresh Closest Target", function()
    -- Hanya untuk menunjuk target di UI
end)

-- TARGET
AddButton(Tab4, "Select Main Target", function()
    local d = Instance.new("ScrollingFrame", Tab4); d.Size = UDim2.new(0.96,0,0,100); d.BackgroundColor3 = Color3.new(0,0,0); d.BackgroundTransparency = 0.6; Round(d, 10); Instance.new("UIListLayout", d)
    for _,p in pairs(Players:GetPlayers()) do if p ~= LP then
        AddButton(d, p.Name, function() SelectedTarget = p; d:Destroy() end).Size = UDim2.new(1,0,0,30)
    end end
end)
AddToggle(Tab4, "Teleport Follow", false, function(v) TPFollow = v end)
AddToggle(Tab4, "Body Lock (Smooth)", false, function(v) BodyLock = v end)

-- VISUALS
AddToggle(Tab5, "ESP Names", false, function(v) ESP_Name_Enabled = v end)
AddButton(Tab5, "ESP Mode: None", function(b)
    if ESP_Mode == "None" then ESP_Mode = "2D"
    elseif ESP_Mode == "2D" then ESP_Mode = "Skeleton"
    else ESP_Mode = "None" end
    b.Text = "ESP Mode: " .. ESP_Mode
end)

-- MISC
AddButton(Tab6, "PSHADE ULTIMATE", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-pshade-ultimate-25505"))() end)

--========================
-- CORE SYSTEM (REWRITTEN)
--========================

-- Visible Check Function
local function IsVisible(part)
    if not part then return false end
    local char = LP.Character
    if not char then return false end
    
    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000)
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {char, Camera})
    
    if hit and hit:IsDescendantOf(part.Parent) then
        return true
    end
    return false
end

local function GetBestTarget()
    local target = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local head = v.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen and IsVisible(head) then -- Cek apakah di layar DAN tidak terhalang tembok
                local mouseDist = (Vector2.new(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if mouseDist < dist then
                    dist = mouseDist
                    target = v
                end
            end
        end
    end
    return target
end

-- ESP RENDERER
local function CreateESP(plr)
    local Box = Drawing.new("Square"); Box.Thickness = 1; Box.Color = Theme.Accent; Box.Filled = false; Box.Visible = false
    local Name = Drawing.new("Text"); Name.Size = 14; Name.Center = true; Name.Outline = true; Name.Color = Color3.new(1, 1, 1); Name.Visible = false
    local Line = Drawing.new("Line"); Line.Thickness = 1; Line.Color = Theme.Accent; Line.Visible = false

    RunService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr ~= LP and plr.Character.Humanoid.Health > 0 then
            local hrp = plr.Character.HumanoidRootPart
            local head = plr.Character:FindFirstChild("Head")
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                if ESP_Name_Enabled then Name.Visible = true; Name.Text = plr.Name; Name.Position = Vector2.new(pos.X, pos.Y - 45) else Name.Visible = false end
                if ESP_Mode == "2D" then
                    local sizeX = 2500 / pos.Z; local sizeY = 3500 / pos.Z
                    Box.Visible = true; Box.Size = Vector2.new(sizeX, sizeY); Box.Position = Vector2.new(pos.X - sizeX/2, pos.Y - sizeY/2)
                else Box.Visible = false end
                if ESP_Mode == "Skeleton" and head then
                    local headPos = Camera:WorldToViewportPoint(head.Position)
                    Line.Visible = true; Line.From = Vector2.new(headPos.X, headPos.Y); Line.To = Vector2.new(pos.X, pos.Y)
                else Line.Visible = false end
            else Box.Visible = false; Name.Visible = false; Line.Visible = false end
        else Box.Visible = false; Name.Visible = false; Line.Visible = false end
    end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- Global Heartbeat Loop
RunService.Heartbeat:Connect(function()
    local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hum then 
        hum.WalkSpeed = SpeedOn and SpeedVal or 16
        hum.JumpPower = JumpOn and JumpVal or 50 
    end
    
    if NoClip and char then 
        for _,v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end 
    end
    
    -- Optimized Aimlock with Visible Check
    if AimlockOn then
        local target = GetBestTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetHead = target.Character.Head.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead)
        end
    end
    
    if SelectedTarget and SelectedTarget.Character and hrp then
        local thrp = SelectedTarget.Character:FindFirstChild("HumanoidRootPart")
        if thrp then
            local cf = thrp.CFrame * CFrame.new(0, 0, -FollowDistance)
            if TPFollow then hrp.CFrame = cf elseif BodyLock then hrp.CFrame = hrp.CFrame:Lerp(cf, 0.15) end
        end
    end
end)

--========================
-- LOGO (MINIMIZE)
--========================
local MiniLogo = Instance.new("ImageButton", Gui)
MiniLogo.Size = UDim2.fromOffset(65, 65)
MiniLogo.Position = UDim2.new(0.02, 0, 0.45, 0)
MiniLogo.BackgroundTransparency = 1
MakeDraggable(MiniLogo, MiniLogo)

local FireBg = Instance.new("Frame", MiniLogo); FireBg.Size = UDim2.fromScale(1, 1); FireBg.BackgroundColor3 = Theme.Accent; Round(FireBg, 50)
local FireGrad = Instance.new("UIGradient", FireBg); FireGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 150)), ColorSequenceKeypoint.new(0.5, Theme.Accent), ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 30, 0))}
TweenService:Create(FireGrad, TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()
local LogoTxt = Instance.new("TextLabel", MiniLogo); LogoTxt.Size = UDim2.fromScale(1, 1); LogoTxt.BackgroundTransparency = 1; LogoTxt.Text = "CIPIK"; LogoTxt.Font = "GothamBlack"; LogoTxt.TextColor3 = Color3.new(1,1,1); LogoTxt.TextSize = 14

MiniLogo.MouseButton1Click:Connect(function() 
    Main.Visible = not Main.Visible 
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = Main.Visible and 20 or 0}):Play() 
end)

Pages["Player"].page.Visible = true
Pages["Player"].btn.BackgroundTransparency = 0.8
print("CIPIK HUB: TOTAL RESTORATION SUCCESS | AIMLOCK VISIBLE CHECK ACTIVE")
