local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local jecs = require(ReplicatedStorage.Packages.jecs)

local world = jecs.World.new()

const Position = world:component()
const instance = world:component()

local BlockTypes = require(script.Parent.BlockTypes)

type Block = BlockTypes.Block

local Trove = require(ReplicatedStorage.Packages.trove)

local BlockPlacement = {}
BlockPlacement.__index = BlockPlacement

local function snapToGrid(value: number, grid: number): number
	return math.round(value / grid) * grid
end

const speed = 10

const params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude

function BlockPlacement:start(player: Player): ()
	if RunService:IsServer() then
		return
	end

	if not player then
		warn("[BLOCKSPLACEMENT]: Player Object is nil!")
		return
	end

	params.FilterDescendantsInstances = { player.Character }

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

	local block = playerTrove:Add(Instance.new("Part")) :: Part

	block.Size = Vector3.new(5, 5, 5)
	block.Anchored = true
	block.CanCollide = false
	block.CanQuery = false
	block.CanTouch = false
	block.Transparency = 0.5
	block.Parent = workspace

	local alpha = 0

	playerTrove:Connect(RunService.RenderStepped, function(dt: number)
		local ray = workspace:Raycast(mouse.UnitRay.Origin, mouse.UnitRay.Direction * 1000, params)

		if not ray then
			return
		end

		local position = ray.Position + ray.Normal + (block.Size / 10)

		local goal = Vector3.new(snapToGrid(position.X, 5), snapToGrid(position.Y, 5), snapToGrid(position.Z, 5))

		alpha = math.clamp(speed * dt, 0, 1)

		block.Position = block.Position:Lerp(goal, alpha)
	end)
end

function BlockPlacement:Place(Block: Block)
	if RunService:IsClient() then
		return
	end

	local blockFolder = workspace:FindFirstChild("BlocksFolder")
	if not blockFolder then
		blockFolder = Instance.new("Folder")
		blockFolder.Name = "blockFolder"

		blockFolder.Parent = workspace
	end

	local block = Instance.new("Part")
	block.Color = Block.Color or Color3.new(1, 1, 1)
	block.Position = Block.Position
	block.Size = Vector3.new(5, 5, 5)

	block.Anchored = true

	block.Parent = blockFolder

	if Block.OnPlace then
		Block.OnPlace()
	end

	local Entity = world:entity()

	world:set(Entity, Position, Block.Position)
	world:set(Entity, instance, block)
end

return BlockPlacement
