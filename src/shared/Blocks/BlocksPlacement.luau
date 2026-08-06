local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Trove = require(ReplicatedStorage.Packages.trove)

local BlockPlacement = {}
BlockPlacement.__index = BlockPlacement

function BlockPlacement:start(player: Player): ()
	if RunService:IsServer() then
		return
	end

	if not player then
		warn("[BLOCKSPLACEMENT]: Player Object is nil!")
		return
	end

	local mouse = player:GetMouse()

	if not mouse then
		warn("[BLOCKSPLACEMENT]: Mouse Object is nil!")
		return
	end

	local camera = workspace.CurrentCamera

	if not camera then
		warn("[BLOCKSPLACEMENT]: Camera Object returned nil!")
		return
	end

	self.trove = self.trove or {}

	local function clean(): ()
		local playerTrove = self.trove[player.UserId]

		if playerTrove then
			playerTrove:Destroy()
			self.trove[player.UserId] = nil
		end
	end

	if self.trove[player.UserId] then
		clean()
	end

	local playerTrove = Trove.new()
	self.trove[player.UserId] = playerTrove

	local block = playerTrove:Add(Instance.new("Part"))

	block.Size = Vector3.new(2.5, 2.5, 2.5)
	block.Anchored = true
	block.CanCollide = false
	block.CanQuery = false
	block.CanTouch = false
	block.Transparency = 0.5
	block.Parent = workspace

	playerTrove:Connect(RunService.RenderStepped, function()
		local ray = workspace:Raycast(mouse.UnitRay.Origin, mouse.UnitRay.Direction * 1000)

		if ray then
			block.Position = ray.Position
		end
	end)
end

return BlockPlacement
