local CollectionService = game:GetService("CollectionService")
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
local Packets = require(ReplicatedStorage.Shared.Packets)
local DeletionModeSignal = require(ReplicatedStorage.Shared.Signals.DeletionModeSignal)

local BlockPlacement = {}
BlockPlacement.__index = BlockPlacement

local function snapToGrid(value: number, grid: number): number
	return math.round(value / grid) * grid
end

const speed = 10

const params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude

local isDeleting = false
local currentPlayer: Player? = nil

DeletionModeSignal:Connect(function(state: boolean)
	isDeleting = state

	if currentPlayer then
		BlockPlacement:start(currentPlayer)
	end
end)

local function isPlacedBlock(target: Instance): boolean
	if not target:IsA("BasePart") then
		return false
	end

	local parent = target.Parent

	return CollectionService:HasTag(target, "PlacedBlock")
		and parent ~= nil
		and parent:IsA("Folder")
		and string.match(parent.Name, "^BlocksFolder%d+$") ~= nil
end

const valid = Color3.fromRGB(56, 255, 1)
const invalid = Color3.fromRGB(255, 2, 2)

local lastValid: boolean? = nil

function BlockPlacement:start(player: Player): ()
	if RunService:IsServer() then
		return
	end

	if not player then
		warn("[BLOCKSPLACEMENT]: Player Object is nil!")
		return
	end

	currentPlayer = player

	local ignored = { player.Character }

	local baseplate = workspace:FindFirstChild("Baseplate")
	if baseplate then
		table.insert(ignored, baseplate)
		print "YEASSS"
	end

	params.FilterDescendantsInstances = ignored

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

	print(isDeleting)
	local overlap = OverlapParams.new()
	overlap.FilterType = Enum.RaycastFilterType.Exclude
	overlap.FilterDescendantsInstances = { player.Character }

	if isDeleting then
		local highlight = playerTrove:Add(Instance.new("Highlight"))

		highlight.FillColor = Color3.fromRGB(255, 0, 22)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.Parent = workspace:FindFirstChild("BlocksFolder" .. player.UserId)

		playerTrove:Connect(RunService.RenderStepped, function()
			local ray = workspace:Raycast(mouse.UnitRay.Origin, mouse.UnitRay.Direction * 1000, params)

			if ray and isPlacedBlock(ray.Instance) then
				highlight.Adornee = ray.Instance
			else
				highlight.Adornee = nil
			end
		end)

		return
	end

	local block = playerTrove:Add(Instance.new("Part")) :: Part

	block.Size = Vector3.new(4.999, 4.999, 4.999)
	block.Anchored = true
	block.CanCollide = false
	block.CanQuery = false
	block.CanTouch = false
	block.Transparency = 0.5
	block.Parent = workspace

	local alpha

	playerTrove:Connect(RunService.RenderStepped, function(dt: number)
		local ray = workspace:Raycast(mouse.UnitRay.Origin, mouse.UnitRay.Direction * 1000, params)

		if not ray then
			return
		end

		local position = ray.Position + ray.Normal * (block.Size.Y / 2)

		local goal = Vector3.new(snapToGrid(position.X, 5), snapToGrid(position.Y, 5), snapToGrid(position.Z, 5))
		local targetCFrame = CFrame.new(goal)

		local inbound = workspace:GetPartBoundsInBox(targetCFrame, block.Size, overlap)

		local isValid = #inbound == 0

		if isValid ~= lastValid then
			block.Color = if isValid then valid else invalid
			lastValid = isValid
		end

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

	local overlap = OverlapParams.new()
	overlap.FilterType = Enum.RaycastFilterType.Include
	overlap.FilterDescendantsInstances = { blockFolder, player.Character }

	local inbound = workspace:GetPartBoundsInBox(CFrame.new(Block.Position), Vector3.new(4.9, 4.9, 4.9), overlap)

	if #inbound > 0 then
		return
	end

	local block = Instance.new("Part")

	block.Color = BlocksList.BlockList[Block.Id].Color or Color3.fromRGB(177, 170, 170)

	block.Position = Block.Position
	block.Size = Vector3.new(5, 5, 5)
	block.Anchored = true

	block.Parent = blockFolder

	CollectionService:AddTag(block, "PlacedBlock")

	local Entity = world:entity()

	world:set(Entity, Position, Block.Position)
	world:set(Entity, instance, block)
	world:set(Entity, data, Block.data)
	world:set(Entity, id, Block.Id)
	world:set(Entity, owner, player.UserId)

	Packets.ScaleBlock:FireClient(player, block)
end

return BlockPlacement
