-- Place this LocalScript under StarterGui or StarterPlayerScripts
-- It will create a simple GUI with two buttons to control the looping sequence

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoopControllerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("StarterGui")

-- Create Visibility Toggle Button
local visibilityBtn = Instance.new("TextButton")
visibilityBtn.Name = "VisibilityButton"
visibilityBtn.Size = UDim2.new(0, 150, 0, 50)
visibilityBtn.Position = UDim2.new(0, 10, 0, 10)
visibilityBtn.Text = "Hide GUI"
visibilityBtn.Parent = screenGui

-- Create Loop Toggle Button
local loopBtn = Instance.new("TextButton")
loopBtn.Name = "LoopButton"
loopBtn.Size = UDim2.new(0, 150, 0, 50)
loopBtn.Position = UDim2.new(0, 10, 0, 70)
loopBtn.Text = "Start Loop"
loopBtn.Parent = screenGui

-- State variables
local loopEnabled = false
local isGuiVisible = true

-- Function that runs the original sequence every 3 seconds
local function runSequence()
    while loopEnabled do
        -- Play meteor sound
        local args = {"wep_meteor"}
        game:GetService("ReplicatedStorage"):WaitForChild("shared/network@GlobalEvents"):WaitForChild("UnloadCharacter"):FireServer(unpack(args))

        -- Play earthquake sound
        args = {"wep_earthquake"}
        game:GetService("ReplicatedStorage"):WaitForChild("shared/network@GlobalEvents"):WaitForChild("UnloadCharacter"):FireServer(unpack(args))

        -- Report hit scan stats again
        args = {"hitscasn"}
        game:GetService("ReplicatedStorage"):WaitForChild("shared/network@GlobalEvents"):WaitForChild("MovementAction"):FireServer(unpack(args))
        task.wait(0.2)

        -- Report ultimate stats again
        args = {"ult"}
        game:GetService("ReplicatedStorage"):WaitForChild("shared/network@GlobalEvents"):WaitForChild("MovementAction"):FireServer(unpack(args))

        -- Update aim to ultimate again
        args = {"primary", true, "ult"}
        game:GetService("ReplicatedStorage"):WaitForChild("shared/network@GlobalEvents"):WaitForChild("VoxelBreak"):FireServer(unpack(args))

        -- Wait 3 seconds before repeating
        task.wait(1)
    end
end

-- Toggle GUI visibility
visibilityBtn.MouseButton1Click:Connect(function()
    isGuiVisible = not isGuiVisible
    screenGui.Enabled = isGuiVisible
    visibilityBtn.Text = isGuiVisible and "Hide GUI" or "Show GUI"
end)

-- Toggle looping sequence
loopBtn.MouseButton1Click:Connect(function()
    loopEnabled = not loopEnabled
    loopBtn.Text = loopEnabled and "Stop Loop" or "Start Loop"
    if loopEnabled then
        spawn(runSequence)
    end
end)
