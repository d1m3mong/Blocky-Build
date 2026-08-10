local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.Packages.jecs)

const world = jecs.World.new()

const owner = world:component()
const spawnPart = world:component()

const isInGame = world:component()
const placedBlocks = world:component()
const playerRef = world:component()

const Position = world:component()
const instance = world:component()
const id = world:component()
const data = world:component()

return {
	world = world,

	owner = owner,
	spawnPart = spawnPart,

	isInGame = isInGame,
	placedBlocks = placedBlocks,
	playerRef = playerRef,

	Position = Position,
	instance = instance,
	id = id,
	data = data,
}
