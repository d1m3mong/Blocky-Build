local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameManager = require(ReplicatedStorage.Shared.Game.GameManager)
local Grid = require(ReplicatedStorage.Shared.Grid.Grid)
local PrompGridSignal = require(ReplicatedStorage.Shared.Signals.PrompGridSignal)
local Ecs = require(ReplicatedStorage.Shared.Ecs.World)
local ModuleSingleton = require(ReplicatedStorage.Shared.ModuleSingleton)

local world = Ecs.world
local owner = Ecs.owner
local spawnPart = Ecs.spawnPart

const gridSpawnPart = workspace:FindFirstChild("gridSpawnPoints")

local function snapToGrid(value: number, grid: number): number
	return math.round(value / grid) * grid
end

for _, part: Part in gridSpawnPart:GetChildren() do
	part.Position =
		Vector3.new(snapToGrid(part.Position.X, 5), snapToGrid(part.Position.Y, 5), snapToGrid(part.Position.Z, 5))

	local entity = world:entity()

	world:set(entity, spawnPart, part)
end

local function getUnuccupiedSpawnPart()
	print "getting"

	for Entity, part in world:query(spawnPart):iter() do
		if not world:has(Entity, owner) then
			return Entity, part
		end
	end

	return nil, nil
end

Players.PlayerRemoving:Connect(function(player: Player)
	for entity, _part, ownerValue in world:query(spawnPart, owner) do
		if ownerValue == player.UserId then
			world:remove(entity, owner)
			break
		end
	end
end)

Players.PlayerAdded:Connect(function(player: Player)
	local entity, part = getUnuccupiedSpawnPart()
	print(part.Position)

	if not entity or not part then
		warn("No unoccupied spawn part available for", player.Name)
		return
	end
	print "STILL"
	world:set(entity, owner, player.UserId)

	local grid = Grid:setupGrid(player, part)

	PrompGridSignal:Fire(player, grid)
end)

ModuleSingleton.gameManager:intermission()
