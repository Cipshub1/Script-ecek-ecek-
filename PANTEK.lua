--====================================================
-- ❄️ CIPSHUB | MODERN KEY SYSTEM GATEWAY ❄️
-- Wajib isi key setiap kali masuk (No Save Key)
--====================================================

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- CONFIGURATION
local CorrectKey = "CIPSHUB-FREE-2026"
local KeyLink = "https://chat.whatsapp.com/C9lws7uXig62tX1xcVnhfS?mode=gi_t"
local MainScriptURL = "https://raw.githubusercontent.com/Cipshub1/Script-ecek-ecek-/refs/heads/main/PANTEK.lua"

-- UI GATEWAY BUILDER
local Gui = Instance.new("ScreenGui", LP.PlayerGui)
Gui.Name = "CipsKeyAuth"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromOffset(330, 200)
Main.Position = UDim2.new(0.5, -165, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 225, 255)
Stroke.Thickness = 2
Stroke.Transparency = 0.3

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "CIPSHUB AUTHENTICATION ❄️"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- INPUT BOX
local Box = Instance.new("TextBox", Main)
Box.Size = UDim2.new(0.8, 0, 0, 45)
Box.Position = UDim2.new(0.1, 0, 0.35, 0)
Box.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
Box.Text = ""
Box.PlaceholderText = "Enter Key Here..."
Box.TextColor3 = Color3.new(1, 1, 1)
Box.Font = Enum.Font.Gotham
Box.TextSize = 14
Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)

-- BUTTONS CONTAINER
local BtnHolder = Instance.new("Frame", Main)
BtnHolder.Size = UDim2.new(0.8, 0, 0, 40)
BtnHolder.Position = UDim2.new(0.1, 0, 0.7, 0)
BtnHolder.BackgroundTransparency = 1

local GetBtn = Instance.new("TextButton", BtnHolder)
GetBtn.Size = UDim2.new(0.48, 0, 1, 0)
GetBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
GetBtn.Text = "GET KEY"
GetBtn.Font = Enum.Font.GothamBold
GetBtn.TextColor3 = Color3.new(1, 1, 1)
GetBtn.TextSize = 12
Instance.new("UICorner", GetBtn).CornerRadius = UDim.new(0, 8)

local CheckBtn = Instance.new("TextButton", BtnHolder)
CheckBtn.Size = UDim2.new(0.48, 0, 1, 0)
CheckBtn.Position = UDim2.new(0.52, 0, 0, 0)
CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 225, 255)
CheckBtn.Text = "CHECK KEY"
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.TextColor3 = Color3.fromRGB(10, 15, 25)
CheckBtn.TextSize = 12
Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 8)

-- DRAGGABLE SYSTEM
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- LOGIC
GetBtn.MouseButton1Click:Connect(function()
    setclipboard(KeyLink)
    pcall(function() game:GetService("GuiService"):OpenBrowserWindow(KeyLink) end)
    GetBtn.Text = "LINK COPIED!"
    task.wait(2)
    GetBtn.Text = "GET KEY"
end)

CheckBtn.MouseButton1Click:Connect(function()
    if Box.Text == CorrectKey then
        CheckBtn.Text = "SUCCESS!"
        CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
        task.wait(1)
        Gui:Destroy()
        
        -- INI ADALAH BAGIAN OTOMATIS EXECUTED SCRIPT UTAMA
        loadstring(game:HttpGet(MainScriptURL))()
    else
        CheckBtn.Text = "WRONG KEY!"
        CheckBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        task.wait(1.5)
        CheckBtn.Text = "CHECK KEY"
        CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 225, 255)
    end
end)
