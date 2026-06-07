local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local voidRunning = false
local orbitRunning = false
local antiaImRunning = false

local VOID_Y = -50000
local ORBIT_RADIUS = 1000000
local ORBIT_SPEED = 1.2
local VOID_DISTANCE = 100000000

local voidDirections = {
    Vector3.new(1, 0, 0),
    Vector3.new(-1, 0, 0),
    Vector3.new(0, 1, 0),
    Vector3.new(0, -1, 0),
    Vector3.new(0, 0, 1),
    Vector3.new(0, 0, -1),
    Vector3.new(1, 1, 1).Unit,
    Vector3.new(-1, -1, -1).Unit,
    Vector3.new(1, 1, -1).Unit,
    Vector3.new(-1, 1, 1).Unit,
    Vector3.new(1, -1, 1).Unit,
    Vector3.new(-1, 1, -1).Unit,
}

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")
local VoidBtn = Instance.new("TextButton")
local OrbitBtn = Instance.new("TextButton")
local AntiBtn = Instance.new("TextButton")

ScreenGui.Name = "DeltaMobileUiFast"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 180, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

UIListLayout.Parent = MainFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Rivals Mobile"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local function createButton(btn, text, color)
    btn.Parent = MainFrame
    btn.BackgroundColor3 = color
    btn.Size = UDim2.new(0, 150, 0, 40)
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
end

createButton(VoidBtn, "Void Spam: OFF", Color3.fromRGB(60, 60, 60))
createButton(OrbitBtn, "Orbit: OFF", Color3.fromRGB(60, 60, 60))
createButton(AntiBtn, "Anti Aim: OFF", Color3.fromRGB(60, 60, 60))

local function getHrp()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

VoidBtn.MouseButton1Click:Connect(function()
    voidRunning = not voidRunning
    if voidRunning then
        VoidBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        VoidBtn.Text = "Void Spam: ON"
        task.spawn(function()
            local hrp = getHrp()
            if hrp then
                hrp.CFrame = CFrame.new(hrp.Position.X, VOID_Y, hrp.Position.Z)
            end
            task.wait(0.05)
            while voidRunning do
                for _, dir in ipairs(voidDirections) do
                    if not voidRunning then break end
                    local currentHrp = getHrp()
                    if currentHrp then
                        local cur = currentHrp.Position
                        currentHrp.CFrame = CFrame.new(cur + dir * VOID_DISTANCE)
                    end
                    RunService.Heartbeat:Wait()
                end
            end
        end)
    else
        VoidBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        VoidBtn.Text = "Void Spam: OFF"
    end
end)

OrbitBtn.MouseButton1Click:Connect(function()
    orbitRunning = not orbitRunning
    if orbitRunning then
        OrbitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        OrbitBtn.Text = "Orbit: ON"
        task.spawn(function()
            local angle = 0
            while orbitRunning do
                local currentHrp = getHrp()
                local target = nil
                local closestDist = math.huge
                
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
                        local tHum = p.Character:FindFirstChild("Humanoid")
                        if tHrp and tHum and tHum.Health > 0 then
                            local dist = (tHrp.Position - (currentHrp and currentHrp.Position or Vector3.new())).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                target = tHrp
                            end
                        end
                    end
                end
                
                if target and currentHrp then
                    angle = angle + ORBIT_SPEED
                    local x = target.Position.X + math.cos(angle) * ORBIT_RADIUS
                    local z = target.Position.Z + math.sin(angle) * ORBIT_RADIUS
                    local y = target.Position.Y + math.sin(angle * 3) * (ORBIT_RADIUS * 0.3)
                    currentHrp.CFrame = CFrame.new(x, y, z) * CFrame.Angles(0, math.pi + angle, 0)
                end
                RunService.Heartbeat:Wait()
            end
        end)
    else
        OrbitBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        OrbitBtn.Text = "Orbit: OFF"
    end
end)

AntiBtn.MouseButton1Click:Connect(function()
    antiaImRunning = not antiaImRunning
    if antiaImRunning then
        AntiBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        AntiBtn.Text = "Anti Aim: ON"
        task.spawn(function()
            local hrp = getHrp()
            if hrp then
                hrp.CFrame = CFrame.new(hrp.Position.X, VOID_Y, hrp.Position.Z)
            end
            task.wait(0.05)
            local angle = 0
            while antiaImRunning do
                local currentHrp = getHrp()
                if currentHrp then
                    angle = angle + 30
                    if angle >= 360 then angle = 0 end
                    currentHrp.CFrame = CFrame.new(currentHrp.Position) * CFrame.Angles(
                        math.rad(math.random(-180, 180)),
                        math.rad(angle),
                        math.rad(math.random(-180, 180))
                    )
                end
                RunService.Heartbeat:Wait()
            end
        end)
    else
        AntiBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        AntiBtn.Text = "Anti Aim: OFF"
    end
end)
