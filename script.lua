-- Place this LocalScript in StarterGui

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
print("[AutoUlt] Services loaded, playerGui obtained.")

-- Globals
local eventsFolder = ReplicatedStorage:WaitForChild("shared/network@GlobalEvents")
print("[AutoUlt] eventsFolder set to shared/network@GlobalEvents.")

-- State
local uiVisible = true
local isRunning = false
print("[AutoUlt] Initial state - uiVisible:", uiVisible, "isRunning:", isRunning)

-- Sequence functions (direct FireServer calls)
local function equipMeteor()
    print("[AutoUlt] equipMeteor() called")
    local args = {"wep_meteor"}
    print("[AutoUlt] -> FireServer ReplicateGameState with args:", unpack(args))
    eventsFolder:WaitForChild("ReplicateGameState"):FireServer(unpack(args))
    print("[AutoUlt] equipMeteor() complete")
end

local function equipEarthquake()
    print("[AutoUlt] equipEarthquake() called")
    local args = {"wep_earthquake"}
    print("[AutoUlt] -> FireServer ReplicateGameState with args:", unpack(args))
    eventsFolder:WaitForChild("ReplicateGameState"):FireServer(unpack(args))
    print("[AutoUlt] equipEarthquake() complete")
end

local function equipHitscan()
    print("[AutoUlt] equipHitscan() called")
    local args = {"hitscan"}
    print("[AutoUlt] -> FireServer UnloadCharacter with args:", unpack(args))
    eventsFolder:WaitForChild("UnloadCharacter"):FireServer(unpack(args))
    print("[AutoUlt] equipHitscan() complete")
end

local function equipUlt()
    print("[AutoUlt] equipUlt() called")
    local args = {"ult"}
    print("[AutoUlt] -> FireServer UnloadCharacter with args:", unpack(args))
    eventsFolder:WaitForChild("UnloadCharacter"):FireServer(unpack(args))
    print("[AutoUlt] equipUlt() complete")
end

local function fireUlt()
    print("[AutoUlt] fireUlt() called")
    local args = {"primary", true, "ult"}
    print("[AutoUlt] -> FireServer Attacked with args:", unpack(args))
    eventsFolder:WaitForChild("Attacked"):FireServer(unpack(args))
    print("[AutoUlt] fireUlt() complete")
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoUltGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
print("[AutoUlt] ScreenGui created.")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui
print("[AutoUlt] Frame created.")

-- Hide UI Button
local btnHide = Instance.new("TextButton")
btnHide.Size = UDim2.new(1, -10, 0, 30)
btnHide.Position = UDim2.new(0, 5, 0, 5)
btnHide.Text = "Hide UI"
btnHide.Parent = frame
print("[AutoUlt] Hide UI button created.")

-- Show UI Button
local btnShow = Instance.new("TextButton")
btnShow.Size = UDim2.new(0, 80, 0, 30)
btnShow.Position = UDim2.new(0, 10, 0, 10)
btnShow.Text = "Show UI"
btnShow.Visible = false
btnShow.Parent = screenGui
print("[AutoUlt] Show UI button created.")

-- Start/Stop Button
local btnMain = Instance.new("TextButton")
btnMain.Size = UDim2.new(1, -10, 0, 30)
btnMain.Position = UDim2.new(0, 5, 0, 85)
btnMain.Text = "Start Auto Ult"
btnMain.Parent = frame
print("[AutoUlt] Start/Stop button created.")

-- Button Logic
btnHide.MouseButton1Click:Connect(function()
    print("[AutoUlt] Hide UI clicked")
    frame.Visible = false
    btnShow.Visible = true
    uiVisible = false
    print("[AutoUlt] UI hidden, uiVisible set to false")
end)

btnShow.MouseButton1Click:Connect(function()
    print("[AutoUlt] Show UI clicked")
    frame.Visible = true
    btnShow.Visible = false
    uiVisible = true
    print("[AutoUlt] UI shown, uiVisible set to true")
end)

btnMain.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    print("[AutoUlt] Toggle run state, isRunning:", isRunning)
    if isRunning then
        btnMain.Text = "Stop Auto Ult"
        print("[AutoUlt] Starting auto ult loop")
        spawn(function()
            while isRunning do
                -- First rotation
                equipMeteor()
                equipHitscan()
                equipUlt()
                wait(2)
                fireUlt()

                -- Second rotation
                equipEarthquake()
                equipHitscan()
                equipUlt()
                wait(2)
                fireUlt()

                wait(2)
                print("[AutoUlt] Loop iteration complete")
            end
            print("[AutoUlt] Exited auto ult loop")
        end)
    else
        btnMain.Text = "Start Auto Ult"
        print("[AutoUlt] Stopped auto ult loop")
    end
end)
