--====================================================
-- ❄️ CIPSHUB KEY SYSTEM (SIMPLE & PREMIUM) ❄️
--====================================================

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")

-- CONFIG
local CorrectKey = "bayar"
local KeyLink = "https://chat.whatsapp.com/C9lws7uXig62tX1xcVnhfS?mode=gi_t"
local RawScript = "https://raw.githubusercontent.com/Cipshub1/Script-ecek-ecek-/refs/heads/main/PANTEK.lua"

-- UI BASE
local Gui = Instance.new("ScreenGui", LP.PlayerGui)
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromOffset(330, 200)
Main.Position = UDim2.new(0.5, -165, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(0, 225, 255); Stroke.Thickness = 2

-- TITLE
local T = Instance.new("TextLabel", Main)
T.Size = UDim2.new(1, 0, 0, 50); T.Text = "CIPSHUB AUTH ❄️"; T.TextColor3 = Color3.new(1,1,1)
T.Font = "GothamBold"; T.TextSize = 18; T.BackgroundTransparency = 1

-- INPUT BOX
local Box = Instance.new("TextBox", Main)
Box.Size = UDim2.new(0.8, 0, 0, 40); Box.Position = UDim2.new(0.1, 0, 0.35, 0)
Box.BackgroundColor3 = Color3.fromRGB(25, 30, 45); Box.Text = ""; Box.PlaceholderText = "Input Key..."
Box.TextColor3 = Color3.new(1,1,1); Box.Font = "Gotham"; Box.TextSize = 14
Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)

-- GET KEY BUTTON
local Get = Instance.new("TextButton", Main)
Get.Size = UDim2.new(0.38, 0, 0, 35); Get.Position = UDim2.new(0.1, 0, 0.7, 0)
Get.BackgroundColor3 = Color3.fromRGB(35, 40, 55); Get.Text = "GET KEY"; Get.TextColor3 = Color3.new(1,1,1)
Get.Font = "GothamBold"; Get.TextSize = 12; Instance.new("UICorner", Get).CornerRadius = UDim.new(0, 8)

-- CHECK KEY BUTTON
local Check = Instance.new("TextButton", Main)
Check.Size = UDim2.new(0.38, 0, 0, 35); Check.Position = UDim2.new(0.52, 0, 0.7, 0)
Check.BackgroundColor3 = Color3.fromRGB(0, 225, 255); Check.Text = "CHECK"; Check.TextColor3 = Color3.fromRGB(10,15,25)
Check.Font = "GothamBold"; Check.TextSize = 12; Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 8)

-- LOGIC
Get.MouseButton1Click:Connect(function()
    setclipboard(KeyLink)
    pcall(function() game:GetService("GuiService"):OpenBrowserWindow(KeyLink) end)
    Get.Text = "COPIED!"
    task.wait(2); Get.Text = "GET KEY"
end)

Check.MouseButton1Click:Connect(function()
    if Box.Text == CorrectKey then
        Check.Text = "SUCCESS!"; Check.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
        task.wait(1)
        Gui:Destroy()
        -- EXECUTE SCRIPT UTAMA
        loadstring(game:HttpGet(RawScript))()
    else
        Check.Text = "WRONG!"; Check.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        task.wait(1.5); Check.Text = "CHECK"; Check.BackgroundColor3 = Color3.fromRGB(0, 225, 255)
    end
end)

-- MAKE DRAGGABLE
local d, i, s, p
Main.InputBegan:Connect(function(inpt) if inpt.UserInputType == Enum.UserInputType.MouseButton1 then d = true; s = inpt.Position; p = Main.Position end end)
UIS.InputChanged:Connect(function(inpt) if inpt.UserInputType == Enum.UserInputType.MouseMovement and d then
    local delta = inpt.Position - s
    Main.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y)
end end)
UIS.InputEnded:Connect(function(inpt) if inpt.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
