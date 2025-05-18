-- Place this LocalScript in StarterGui

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Constants for remotes
local GlobalEvents = ReplicatedStorage:WaitForChild("shared"):WaitForChild("network@GlobalEvents")

-- State
local uiVisible = true
local isRunning = false

-- Helper to fire remotes
local function fireRemote(remoteName, ...)
    local remote = GlobalEvents:FindFirstChild(remoteName)
    if remote then
        remote:FireServer(...)
    else
        warn("Remote not found:", remoteName)
    end
end

-- Sequence functions
local function equipMeteor()
    fireRemote("PlaySound", "wep_meteor")
end

local function equipEarthquake()
    fireRemote("PlaySound", "wep_earthquake")
end

local function equipHitscan()
    fireRemote("RenderMovementAction", "hitscan")
end

local function equipUlt()
    fireRemote("RenderMovementAction", "ult")
end

local function fireUlt()
    fireRemote("SkipCompile", "primary", true, "ult")
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

-- Toggle Off Button
local btnHide = Instance.new("TextButton")
btnHide.Size = UDim2.new(1, -10, 0, 30)
btnHide.Position = UDim2.new(0, 5, 0, 5)
btnHide.Text = "Hide UI"
btnHide.Parent = frame

-- Toggle On Button
local btnShow = Instance.new("TextButton")
btnShow.Size = UDim2.new(1, -10, 0, 30)
btnShow.Position = UDim2.new(0, 5, 0, 45)
btnShow.Text = "Show UI"
btnShow.Visible = false
btnShow.Parent = screenGui

-- Main Loop Button
local btnMain = Instance.new("TextButton")
btnMain.Size = UDim2.new(1, -10, 0, 30)
btnMain.Position = UDim2.new(0, 5, 0, 85)
btnMain.Text = "Start Auto Ult"
btnMain.Parent = frame

-- Button behavior
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
        -- Run sequence on separate thread
        spawn(function()
            while isRunning do
                -- First pass
                equipMeteor()
                equipHitscan()
                equipUlt()
                wait(0.2)
                fireUlt()

                -- Second pass
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
