local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local antiaImRunning = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")
local AntiBtn = Instance.new("TextButton")

ScreenGui.Name = "DeltaAntiAim"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 180, 0, 120)
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
Title.Text = "justhuman lua"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

AntiBtn.Parent = MainFrame
AntiBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AntiBtn.Size = UDim2.new(0, 150, 0, 40)
AntiBtn.Font = Enum.Font.SourceSans
AntiBtn.Text = "Anti Aim: OFF"
AntiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiBtn.TextSize = 16

local function getJoints()
    local char = LocalPlayer.Character
    if char then
        local waist = char:FindFirstChild("Waist", true)
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        return waist, rootPart
    end
    return nil, nil
end

AntiBtn.MouseButton1Click:Connect(function()
    antiaImRunning = not antiaImRunning
    if antiaImRunning then
        AntiBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        AntiBtn.Text = "Anti Aim: ON"
        task.spawn(function()
            while antiaImRunning do
                local waist, rootPart = getJoints()
                if waist then
                    waist.C0 = CFrame.new(waist.C0.Position) * CFrame.Angles(math.rad(-90), 0, 0)
                end
                if rootPart then
                    rootPart.RootJoint.C0 = CFrame.new(rootPart.RootJoint.C0.Position) * CFrame.Angles(math.rad(90), 0, 0)
                end
                RunService.Heartbeat:Wait()
            end
        end)
    else
        AntiBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        AntiBtn.Text = "Anti Aim: OFF"
        local waist, rootPart = getJoints()
        if waist then
            waist.C0 = CFrame.new(waist.C0.Position)
        end
        if rootPart then
            rootPart.RootJoint.C0 = CFrame.new(rootPart.RootJoint.C0.Position)
        end
    end
end)
