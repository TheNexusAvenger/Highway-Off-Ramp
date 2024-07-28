--[[
TheNexusAvenger

Utility for handling paths.
--]]
--!strict

local PathUtil = {}



--[[
Returns the path for a script.
--]]
function PathUtil.GetScriptPath(Script: Instance): string
    --Build the path.
    local Path = ""
    local CurrentInstance = Script
    while CurrentInstance and CurrentInstance ~= game do
        Path = CurrentInstance.Name..Path
        CurrentInstance = CurrentInstance.Parent :: Instance
        if CurrentInstance and CurrentInstance ~= game then
            Path = "/"..Path
        end
    end

    --Add init to the path if there is a child script.
    for _, Child in Script:GetDescendants() do
        if not Child:IsA("LuaSourceContainer") then continue end
        Path = Path.."/init"
        break
    end

    --Add the extension.
    if Script:IsA("LocalScript") then
        Path = Path..".client.lua"
    elseif Script:IsA("Script") then
        Path = Path..".server.lua"
    else
        Path = Path..".lua"
    end

    --Return the path.
    return Path
end

--[[
Finds all the instances for the given path.
--]]
function PathUtil.FindInstances(Path: string, Parent: Instance?): {Instance}
    Parent = Parent or game
    
    --Move down the path.
    local PathParts = string.split(Path, "/")
    for i = 1, #PathParts - 1 do
        if not Parent then return {} end
        Parent = Parent:FindFirstChild(PathParts[i])
    end
    if not Parent then return {} end

    --Add and return all the children that match the name.
    local InstanceName = PathParts[#PathParts]
    local Children = {}
    for _, Child in Parent:GetChildren() do
        if Child.Name ~= InstanceName then continue end
        table.insert(Children, Child)
    end
    return Children
end



return PathUtil