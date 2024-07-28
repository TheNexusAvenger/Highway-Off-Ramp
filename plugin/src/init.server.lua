--[[
TheNexusAvenger

Main script for the highway plugin.
--]]
--!strict

local PluginGuiService = game:GetService("PluginGuiService")

local PromptWindow = require(script:WaitForChild("UI"):WaitForChild("Window"):WaitForChild("PromptWindow"))
local PushPromptFrame = require(script:WaitForChild("UI"):WaitForChild("Frame"):WaitForChild("PushPromptFrame"))



--Create the toolbar and buttons.
local HighwayToolbar = plugin:CreateToolbar("Highway Off-Ramp")
local PushButton = HighwayToolbar:CreateButton("Push Files", "Pushes the current Studio scripts to the file system.", "") --TODO: Create icon
PushButton.ClickableWhenViewportHidden = true

--Connect the buttons.
local DB = true
PushButton.Click:Connect(function()
    if DB then
        DB = false
        if not PluginGuiService:FindFirstChild("Highway Off-Ramp - Push") then
            PromptWindow.new("Highway Off-Ramp - Push", PushPromptFrame.new(), plugin)
        end
        task.wait()
        PushButton:SetActive(false)
        DB = true
    end
end)
