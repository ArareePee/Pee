-- ArareePeeV1 by PEE | เวอร์ชันรวมฟีเจอร์สำหรับ Krnl (Blox Fruits)

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ArareePeeV1"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local originalSize = MainFrame.Size

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ArareePeeV1 | by PEE"
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local ToggleButton = Instance.new("TextButton", MainFrame)
ToggleButton.Text = "-"
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(1, -40, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18

-- Content Frame
local Content = Instance.new("Frame", MainFrame)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.Size = UDim2.new(1, 0, 1, -40)
Content.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Collapse / Expand
local collapsed = false
ToggleButton.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    ToggleButton.Text = collapsed and "+" or "-"
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Size = collapsed and UDim2.new(0, 400, 0, 40) or originalSize
    }):Play()
    Content.Visible = not collapsed
end)

function createToggle(name, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name .. ": OFF"
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

-- Variables
local AutoFarm = false
local AutoAttack = false

-- Monster Label
local MonsterLabel = Instance.new("TextLabel", Content)
MonsterLabel.Size = UDim2.new(1, -20, 0, 30)
MonsterLabel.Text = "Monster: N/A"
MonsterLabel.TextColor3 = Color3.new(1, 1, 1)
MonsterLabel.BackgroundTransparency = 1
MonsterLabel.Font = Enum.Font.Gotham
MonsterLabel.TextSize = 14

-- Find Closest Mob
local function GetClosestMob()
    local closest, distance = nil, math.huge
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local dist = (mob.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if dist < distance then
                closest = mob
                distance = dist
            end
        end
    end
    return closest
end

-- Auto Farm Toggle
createToggle("Auto Farm (ใกล้ตัว)", function(state)
    AutoFarm = state
    spawn(function()
        while AutoFarm do
            pcall(function()
                local mob = GetClosestMob()
                if mob then
                    MonsterLabel.Text = "Monster: " .. mob.Name
                    LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 3)
                else
                    MonsterLabel.Text = "Monster: N/A"
                end
            end)
            wait(0.5)
        end
    end)
end)

-- Auto Attack (แก้ให้ใช้งานจริง)
createToggle("Auto Attack", function(state)
    AutoAttack = state
    spawn(function()
        while AutoAttack do
            pcall(function()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("RemoteFunction") then
                    tool.RemoteFunction:InvokeServer("Attack", true)
                elseif tool then
                    tool:Activate()
                end
            end)
            wait(0.15)
        end
    end)
end)

-- Auto Press J
createToggle("Auto Press J", function(state)
    if state then
        spawn(function()
            while state do
                VirtualInput:SendKeyEvent(true, "J", false, game)
                wait(1)
            end
        end)
    end
end)

-- Auto Press E
createToggle("Auto Press E", function(state)
    if state then
        spawn(function()
            while state do
                VirtualInput:SendKeyEvent(true, "E", false, game)
                wait(1)
            end
        end)
    end
end)

-- Auto Buso Haki เมื่อรัน
spawn(function()
    while wait(2) do
        pcall(function()
            local args = { [1] = "Buso" }
            ReplicatedStorage.Remotes.Comm:InvokeServer(unpack(args))
        end)
    end
end)