--[[
TheNexusAvenger

Tests the PathUtil.
--]]
--!strict
--$NexusUnitTestExtensions

local PathUtil = require(game:GetService("ReplicatedStorage").HighwayPlugin.Util.PathUtil)

return function()
    describe("The GetScriptPath helper method", function()
        local InstanceToClear = nil
        afterEach(function()
            if not InstanceToClear then return end
            InstanceToClear:Destroy()
        end)

        it("should return a path for an unparented script.", function()
            local Script = Instance.new("ModuleScript")
            Script.Name = "TestScript"

            expect(PathUtil.GetScriptPath(Script)).to.equal("TestScript.lua")
        end)

        it("should return a path for a parented script.", function()
            local Folder1 = Instance.new("Folder")
            Folder1.Name = "Folder1"
            local Folder2 = Instance.new("Folder")
            Folder2.Name = "Folder2"
            Folder2.Parent = Folder1
            local Script = Instance.new("ModuleScript")
            Script.Name = "TestScript"
            Script.Parent = Folder2

            expect(PathUtil.GetScriptPath(Script)).to.equal("Folder1/Folder2/TestScript.lua")
        end)

        it("should return a path for a parented script with child scripts.", function()
            local Folder1 = Instance.new("Folder")
            Folder1.Name = "Folder1"
            local Folder2 = Instance.new("Folder")
            Folder2.Name = "Folder2"
            Folder2.Parent = Folder1
            local Script = Instance.new("ModuleScript")
            Script.Name = "TestScript"
            Script.Parent = Folder2
            local ChildScript = Instance.new("ModuleScript")
            ChildScript.Name = "ChildScript"
            ChildScript.Parent = Script

            expect(PathUtil.GetScriptPath(Script)).to.equal("Folder1/Folder2/TestScript/init.lua")
            expect(PathUtil.GetScriptPath(ChildScript)).to.equal("Folder1/Folder2/TestScript/ChildScript.lua")
        end)

        it("should not add game to the paths.", function()
            local Folder = Instance.new("Folder")
            Folder.Name = "Folder1"
            Folder.Parent = game:GetService("ReplicatedStorage")
            InstanceToClear = Folder
            local Script = Instance.new("ModuleScript")
            Script.Name = "TestScript"
            Script.Parent = Folder

            expect(PathUtil.GetScriptPath(Script)).to.equal("ReplicatedStorage/Folder1/TestScript.lua")
        end)

        it("should add server script extensions.", function()
            local Script = Instance.new("Script")
            Script.Name = "TestScript"

            expect(PathUtil.GetScriptPath(Script)).to.equal("TestScript.server.lua")
        end)

        it("should add local script extensions.", function()
            local Script = Instance.new("LocalScript")
            Script.Name = "TestScript"

            expect(PathUtil.GetScriptPath(Script)).to.equal("TestScript.client.lua")
        end)
    end)

    describe("The FindInstances helper method", function()
        local Parent = nil
        local Script1, Script2, Script3, Script4 = nil, nil, nil, nil
        beforeEach(function()
            local Folder1 = Instance.new("Folder")
            Folder1.Name = "Folder1"
            Parent = Folder1
            local Folder2 = Instance.new("Folder")
            Folder2.Name = "Folder2"
            Folder2.Parent = Folder1
            local ParentScript1 = Instance.new("ModuleScript")
            ParentScript1.Name = "TestScript"
            ParentScript1.Parent = Folder2
            Script1 = ParentScript1
            local ChildScript1 = Instance.new("ModuleScript")
            ChildScript1.Name = "TestScript"
            ChildScript1.Parent = ParentScript1
            Script2 = ChildScript1
            local ChildScript2 = Instance.new("Script")
            ChildScript2.Name = "TestScript"
            ChildScript2.Parent = ParentScript1
            Script3 = ChildScript2
            local ChildScript3 = Instance.new("LocalScript")
            ChildScript3.Name = "TestScript"
            ChildScript3.Parent = ParentScript1
            Script4 = ChildScript3
        end)

        it("should return an empty list for unknown paths.", function()
            expect(#PathUtil.FindInstances("Unknown", Parent)).to.equal(0)
            expect(#PathUtil.FindInstances("Folder2/Unknown2/Unknown2", Parent)).to.equal(0)
        end)

        it("should return instances with correct paths.", function()
            expect(PathUtil.FindInstances("Folder2/TestScript", Parent)).to.deepEqual({Script1})
            expect(PathUtil.FindInstances("Folder2/TestScript/TestScript", Parent)).to.deepEqual({Script2, Script3, Script4} :: {Instance})
        end)
    end)
end