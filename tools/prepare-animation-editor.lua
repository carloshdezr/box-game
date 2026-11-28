-- Run by the AI through Studio MCP in Edit, using this exact repository source.
-- No upload, no place save. A repeat run replaces only our export staging objects.
assert(game.PlaceId == 111090309292395, "Lugar no autorizado")
assert(not game:GetService("RunService"):IsRunning(), "Detén Play")
local storage = game:GetService("ServerStorage")
local previous = storage:FindFirstChild("BoxerAnimationExport")
if previous then previous:Destroy() end
local folder = Instance.new("Folder")
folder.Name = "BoxerAnimationExport"
local sequences = require(game.ReplicatedStorage.BoxerKeyframes).Export(folder)
local rig = require(game.ReplicatedStorage.BoxerRig).Create({})
rig.Name = "BoxerAnimationPreview"
require(game.ReplicatedStorage.BoxerRig).AssemblePreview(rig)
rig.HumanoidRootPart.Anchored = true
local reference = Instance.new("ObjectValue")
reference.Name, reference.Value, reference.Parent = "AnimSaves", sequences, rig
rig.Parent = folder
folder.Parent = storage
return {rig = rig:GetFullName(), sequences = #sequences:GetChildren()}
