-- Place this LocalScript in StarterGui

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Globals
local eventsFolder = ReplicatedStorage:WaitForChild("shared"):WaitForChild("network@GlobalEvents")

-- State
local uiVisible = true
local isRunning = false

-- Sequence functions (direct FireServer calls)
local function equipMeteor()
    local args = {"wep_meteor"}
    eventsFolder:WaitForChild("ReplicateGameState"):FireServer(unpack(args))
end

local function equipEarthquake()
    local args = {"wep_earthquake"}
    eventsFolder:WaitForChild("ReplicateGameState"):FireServer(unpack(args))
end

local function equipHitscan()
    local args = {"hitscan"}
    eventsFolder:WaitForChild("UnloadCharacter"):FireServer(unpack(args))
end

local function equipUlt()
    local args = {"ult"}
    eventsFolder:WaitForChild("UnloadCharacter"):FireServer(unpack(args))
end

local function fireUlt()
    local args = {"primary", true, "ult"}
    eventsFolder:WaitForChild("Attacked"):FireServer(unpack(args))
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoUltGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

-- Hide UI Button
local btnHide = Instance.new("TextButton")
btnHide.Size = UDim2.new(1, -10, 0, 30)
btnHide.Position = UDim2.new(0, 5, 0, 5)
btnHide.Text = "Hide UI"
btnHide.Parent = frame

-- Show UI Button
local btnShow = Instance.new("TextButton")
btnShow.Size = UDim2.new(0, 80, 0, 30)
btnShow.Position = UDim2.new(0, 10, 0, 10)
btnShow.Text = "Show UI"
btnShow.Visible = false
btnShow.Parent = screenGui

-- Start/Stop Button
local btnMain = Instance.new("TextButton")
btnMain.Size = UDim2.new(1, -10, 0, 30)
btnMain.Position = UDim2.new(0, 5, 0, 85)
btnMain.Text = "Start Auto Ult"
btnMain.Parent = frame

-- Button Logic
btnHide.MouseButton1Click:Connect(function()
    frame.Visible = false
    btnShow.Visible = true
    uiVisible = false
end)

btnShow.MouseButton1Click:Connect(function()
    frame.Visible = true
    btnShow.Visible = false
    uiVisible = true
end)

btnMain.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        btnMain.Text = "Stop Auto Ult"
        spawn(function()
            while isRunning do
                -- First rotation
                equipMeteor()
                equipHitscan()
                equipUlt()
                wait(0.2)
                fireUlt()

                -- Second rotation
                equipEarthquake()
                equipHitscan()
                equipUlt()
                wait(0.2)
                fireUlt()

                wait(0.2)
            end
        end)
    else
        btnMain.Text = "Start Auto Ult"
    end
end)
