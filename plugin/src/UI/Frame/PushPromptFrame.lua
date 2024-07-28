--[[
TheNexusAvenger

Frame for confirming and running push actions.
--]]
--!strict

local NexusPluginComponents = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginComponents"))
local PluginColor = require(script.Parent.Parent.Parent:WaitForChild("NexusPluginComponents"):WaitForChild("Base"):WaitForChild("PluginColor"))
local PushAction = require(script.Parent.Parent.Parent:WaitForChild("Action"):WaitForChild("PushAction"))
local PathUtil = require(script.Parent.Parent.Parent:WaitForChild("Util"):WaitForChild("PathUtil"))
local BasePromptFrame = require(script.Parent:WaitForChild("BasePromptFrame"))
local TextListEntry = require(script.Parent:WaitForChild("TextListEntry"))
local Types = require(script.Parent.Parent.Parent:WaitForChild("Types"))

local PushPromptFrame = BasePromptFrame:Extend()
PushPromptFrame:SetClassName("PushPromptFrame")

export type PushPromptFrame = {
    new: () -> (PushPromptFrame),
    Extend: (self: PushPromptFrame) -> (PushPromptFrame),
} & Types.BasePromptFrame



--[[
Loads the frame.
--]]
function PushPromptFrame:Load(): ()
    xpcall(function()
        --Create the action.
        local Action = PushAction.new()

        --Determine the lines to display.
        local Lines = {}
        local SecondaryColor = PluginColor.new(Enum.StudioStyleGuideColor.SubText):GetColor()
        local SecondaryColorText = "rgb("..tostring(math.floor(SecondaryColor.R * 255))..","..tostring(math.floor(SecondaryColor.G * 255))..","..tostring(math.floor(SecondaryColor.B * 255))..")"
        for Script, Hash in Action.ScriptHashCollection.Hashes do
            table.insert(Lines, PathUtil.GetScriptPath(Script).." <font color=\""..SecondaryColorText.."\"><i>("..string.sub(Hash, 1, 7)..")</i></font>")
        end

        --Create the user interface.
        local ScrollListContainer = NexusPluginComponents.new("Frame")
        ScrollListContainer.BorderSizePixel = 1
        ScrollListContainer.Size = UDim2.new(1, 0, 1, -1)
        ScrollListContainer.Parent = self.ContentsFrame

        local ElementList = TextListEntry.CreateTextList(Lines)
        ElementList.Size = UDim2.new(1, 0, 1, 0)
        ElementList.Parent = ScrollListContainer

        --Check if there are no lines to display.
        local ChangesToPush = true
        if #Lines == 0 then
            ChangesToPush = false
            table.insert(Lines, "<font color=\""..SecondaryColorText.."\"><i>No scripts.</i></font>")
        end

        --Return if the game id is not allowed.
        if Action.Manifest.PushPlaceId and game.PlaceId ~= Action.Manifest.PushPlaceId then
            self.StatusText.Text = "Place id invalid for pushing ("..tostring(Action.Manifest.PushPlaceId).." required, got "..tostring(game.PlaceId)..")"
            self.StatusText.TextColor3 = Enum.StudioStyleGuideColor.ErrorText
            return
        end

        --Return if there are no scripts to push.
        if not ChangesToPush then
            self.StatusText.Text = "No scripts to push."
            self.CancelButton.Text = "Close"
            return
        end

        --Connect the confirm button.
        local DB = true
        self.ConfirmButton.MouseButton1Click:Connect(function()
            if DB then
                DB = false
                xpcall(function()
                    --Disable the buttons.
                    self.ConfirmButton.Disabled = true
                    self.CancelButton.Disabled = true

                    --Export the files.
                    self.StatusText.Text = "Preparing scripts..."
                    self.StatusText.TextColor3 = Enum.StudioStyleGuideColor.MainText
                    Action:PushScripts(function(Status: string)
                        self.StatusText.Text = Status
                    end)

                    --Complete the push.
                    self.StatusText.Text = "Push complete."
                    self.CancelButton.Text = "Close"
                end, function(ErrorMessage: string)
                    if string.find(ErrorMessage, "PushCommitError") then
                        --Display that there was nothing to commit.
                        self.StatusText.Text = "No changes pushed. Remote is up to date."
                        self.CancelButton.Text = "Close"
                    else
                        --Display the error mesage.
                        self.StatusText.Text = ErrorMessage
                        self.StatusText.TextColor3 = Enum.StudioStyleGuideColor.ErrorText

                        --Allow using the buttons.
                        self.ConfirmButton.Disabled = false
                    end
                end)
                self.CancelButton.Disabled = false
                task.wait()
                DB = true
            end
        end)
        self.ConfirmButton.Disabled = false
        self.StatusText.Text = "Push "..tostring(#Lines).." files?"
    end, function(ErrorMessage: string)
        --Display the error mesage.
        self.StatusText.Text = ErrorMessage
        self.StatusText.TextColor3 = Enum.StudioStyleGuideColor.ErrorText
    end)
end



return (PushPromptFrame :: any) :: PushPromptFrame