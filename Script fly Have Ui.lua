-- Script FrogVnCom - Fly Script có UI chỉnh tốc độ, ẩn hiện UI bằng Left Ctrl, hiện thành tựu Welcome!

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local mouse = player:GetMouse()
local flying = false
local speed = 50

-- Tạo UI chính
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlySpeedUI"

-- Tiêu đề và tốc độ bay
local title = Instance.new("TextLabel", screenGui)
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.Text = "Fly Speed: " .. speed
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

-- Thanh slider
local sliderBar = Instance.new("Frame", screenGui)
sliderBar.Size = UDim2.new(0, 200, 0, 20)
sliderBar.Position = UDim2.new(0, 10, 0, 50)
sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sliderBar.BorderSizePixel = 0
sliderBar.ClipsDescendants = true

local sliderHandle = Instance.new("ImageButton", sliderBar)
sliderHandle.Size = UDim2.new(0, 20, 1, 0)
sliderHandle.Position = UDim2.new(speed/100, 0, 0, 0) -- Vị trí theo speed
sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderHandle.AutoButtonColor = false
sliderHandle.Image = ""
sliderHandle.Draggable = true
sliderHandle.BorderSizePixel = 0
sliderHandle.Modal = true

-- Thành tựu nhỏ bên phải màn hình
local achievementGui = Instance.new("ScreenGui", player.PlayerGui)
achievementGui.Name = "FrogVnComAchievement"

local achievementFrame = Instance.new("Frame", achievementGui)
achievementFrame.Size = UDim2.new(0, 150, 0, 40)
achievementFrame.Position = UDim2.new(1, -160, 0.5, -20) -- Góc phải giữa màn hình
achievementFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
achievementFrame.BackgroundTransparency = 0.3
achievementFrame.BorderSizePixel = 0
achievementFrame.AnchorPoint = Vector2.new(1, 0.5)
achievementFrame.Visible = true

local achievementText = Instance.new("TextLabel", achievementFrame)
achievementText.Size = UDim2.new(1, -10, 1, 0)
achievementText.Position = UDim2.new(0, 5, 0, 0)
achievementText.Text = "Welcome!"
achievementText.TextColor3 = Color3.new(1, 1, 1)
achievementText.BackgroundTransparency = 1
achievementText.TextScaled = true
achievementText.Font = Enum.Font.SourceSansBold
achievementText.TextXAlignment = Enum.TextXAlignment.Right
achievementText.TextYAlignment = Enum.TextYAlignment.Center

-- Hàm cập nhật tốc độ khi kéo slider
local function updateSpeed()
    local relativePos = math.clamp(
        (sliderHandle.Position.X.Scale * sliderBar.AbsoluteSize.X + sliderHandle.Position.X.Offset) / sliderBar.AbsoluteSize.X, 
        0, 1)
    speed = math.floor(relativePos * 100)
    title.Text = "Fly Speed: " .. speed
end

-- Khi dừng kéo
sliderHandle.DragStopped:Connect(updateSpeed)

-- Cập nhật vị trí slider khi kéo chuột
sliderHandle.MouseMoved:Connect(function()
    local mouseX = UserInputService:GetMouseLocation().X - sliderBar.AbsolutePosition.X
    local clampedX = math.clamp(mouseX, 0, sliderBar.AbsoluteSize.X)
    sliderHandle.Position = UDim2.new(0, clampedX, 0, 0)
    updateSpeed()
end)

-- Bật/tắt bay với phím F
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local bodyVelocity

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Ẩn/hiện UI khi nhấn Left Ctrl
    if input.KeyCode == Enum.KeyCode.LeftControl then
        screenGui.Enabled = not screenGui.Enabled
    end

    -- Bật/tắt bay khi nhấn F
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Parent = character.HumanoidRootPart
            humanoid.PlatformStand = true

            spawn(function()
                while flying do
                    local direction = (mouse.Hit.p - character.HumanoidRootPart.Position).unit
                    bodyVelocity.Velocity = direction * speed
                    wait()
                end
            end)
        else
            flying = false
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity:Destroy()
            end
            humanoid.PlatformStand = false
        end
    end
end)
