-- Script FrogVnCom - Fly Script + UI tối ưu

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local baseFlySpeed = 50
local flySpeed = baseFlySpeed

-- UI chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FrogVnComFlyUI"
screenGui.ResetOnSpawn = false -- Giữ UI tồn tại dù người chơi chết
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Loader UI
local loaderFrame = Instance.new("Frame", screenGui)
loaderFrame.Size = UDim2.new(0, 500, 0, 320)
loaderFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
loaderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loaderFrame.BorderSizePixel = 0
loaderFrame.Visible = false -- Mặc định ẩn

-- Bo góc cho UI
local corner = Instance.new("UICorner", loaderFrame)
corner.CornerRadius = UDim.new(0, 15)

-- Tab Fly
local tabFly = Instance.new("TextLabel", loaderFrame)
tabFly.Size = UDim2.new(1, 0, 0.1, 0)
tabFly.Position = UDim2.new(0, 0, 0, 0)
tabFly.Text = "Fly Settings"
tabFly.Font = Enum.Font.GothamSemibold
tabFly.TextColor3 = Color3.fromRGB(255, 255, 255)
tabFly.TextSize = 25

-- Speed Display
local speedText = Instance.new("TextLabel", loaderFrame)
speedText.Size = UDim2.new(0.8, 0, 0.05, 0)
speedText.Position = UDim2.new(0.1, 0, 0.25, 0)
speedText.Text = "Fly Speed: " .. flySpeed
speedText.TextColor3 = Color3.fromRGB(255, 255, 255)
speedText.Font = Enum.Font.GothamSemibold
speedText.TextSize = 25

-- Speed Control Buttons
local increaseButton = Instance.new("TextButton", loaderFrame)
increaseButton.Size = UDim2.new(0.1, 0, 0.1, 0)
increaseButton.Position = UDim2.new(0.6, 0, 0.35, 0)
increaseButton.Text = "+"
increaseButton.Font = Enum.Font.GothamSemibold
increaseButton.TextSize = 25

local decreaseButton = Instance.new("TextButton", loaderFrame)
decreaseButton.Size = UDim2.new(0.1, 0, 0.1, 0)
decreaseButton.Position = UDim2.new(0.3, 0, 0.35, 0)
decreaseButton.Text = "-"
decreaseButton.Font = Enum.Font.GothamSemibold
decreaseButton.TextSize = 25

-- Achievement Message
local achievement = Instance.new("TextLabel", screenGui)
achievement.Size = UDim2.new(0.3, 0, 0.05, 0)
achievement.Position = UDim2.new(0.7, 0, 0.95, 0)
achievement.Text = "Welcome!"
achievement.Font = Enum.Font.GothamSemibold
achievement.TextSize = 25
achievement.TextColor3 = Color3.fromRGB(0, 255, 0)
achievement.BackgroundTransparency = 1
achievement.Visible = false

-- Achievement xuất hiện khi mở tab và biến mất sau 15s
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        loaderFrame.Visible = not loaderFrame.Visible
        if loaderFrame.Visible then
            achievement.Visible = true
            task.delay(15, function()
                achievement.Visible = false
            end)
        end
    end
end)

-- Adjust Speed Functions
increaseButton.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 5
    speedText.Text = "Fly Speed: " .. flySpeed
end)

decreaseButton.MouseButton1Click:Connect(function()
    if flySpeed > 5 then
        flySpeed = flySpeed - 5
        speedText.Text = "Fly Speed: " .. flySpeed
    end
end)

-- Fly control
local trail
local function startFlying()
    if flying then return end
    flying = true

    trail = Instance.new("Trail", player.Character.HumanoidRootPart)
    trail.Attachment0 = Instance.new("Attachment", player.Character.HumanoidRootPart)
    trail.Attachment1 = Instance.new("Attachment", player.Character.HumanoidRootPart)
    trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))
    trail.Lifetime = 0.5
    trail.Transparency = NumberSequence.new(0, 1)

    RunService.Heartbeat:Connect(function()
        if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local camera = workspace.CurrentCamera
            player.Character.HumanoidRootPart.Velocity = (camera.CFrame.LookVector * flySpeed)
        end
    end)
end

local function stopFlying()
    flying = false
    if trail then trail:Destroy() end
end

-- Phím điều khiển
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        if flying then stopFlying() else startFlying() end
    end
end)