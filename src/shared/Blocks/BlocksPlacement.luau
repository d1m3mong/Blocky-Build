local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ecs = require(ReplicatedStorage.Shared.Ecs.World)

local world = Ecs.world
local Position = Ecs.Position
local instance = Ecs.instance
local id = Ecs.id
local data = Ecs.data
local owner = Ecs.owner

local BlockTypes = require(script.Parent.BlockTypes)
local BlocksList = require(script.Parent.BlocksList)

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

function BlockPlacement:start(player: Player, toggle: boolean): ()
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

function BlockPlacement:Place(Block: Block, player: Player)
	if RunService:IsClient() then
		return
	end

	local blockFolder = workspace:FindFirstChild("BlocksFolder" .. player.UserId)
	if not blockFolder then
		blockFolder = Instance.new("Folder")
		blockFolder.Name = "BlocksFolder" .. player.UserId

		blockFolder.Parent = workspace
	end

	local block = Instance.new("Part")
	block.Color = BlocksList.BlockList[Block.Id].Color or Color3.fromRGB(177, 170, 170)
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
	world:set(Entity, data, Block.data)
	world:set(Entity, id, Block.Id)
	world:set(Entity, owner, player.UserId)
end

return BlockPlacement
