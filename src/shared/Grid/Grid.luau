local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GridTypes = require(script.Parent.GridTypes)

type tile = GridTypes.Tile
type grid = GridTypes.Grid

local Grid = {}
Grid.__index = Grid

local tileSize = 3.5
local tileHeight = 0.5

local function snap(value: number): number
	return math.round(value / tileSize) * tileSize
end

local function createPart(Position: Vector3, index: number, folder: Folder): Part
	local Tile = Instance.new("Part")
	Tile.Color = if index % 2 == 0 then Color3.fromRGB(232, 230, 230) else Color3.fromRGB(143, 143, 143)
	Tile.Size = Vector3.new(tileSize, tileHeight, tileSize)
	Tile.Position = Position

	Tile.Anchored = true

	Tile.Parent = folder

	return Tile
end

function Grid:setupGrid(player: Player, part: Part): grid
	print(`Setting up Grid for {player.Name}`)

	local t = {}

	local folder = Instance.new("Folder")
	folder.Name = player.UserId .. "Folder"

	folder.Parent = workspace

	local gridSize = 20
	local offset = (gridSize - 1) / 2

	local origin = Vector3.new(
		snap(part.Position.X),
		snap(part.Position.Y + tileSize / 2 + tileHeight / 2) - tileSize / 2 - tileHeight / 2,
		snap(part.Position.Z)
	)

	for i = 0, gridSize - 1 do
		for j = 0, gridSize - 1 do
			local position = origin + Vector3.new((i - offset) * tileSize, 0, (j - offset) * tileSize)

			table.insert(t, createPart(position, i - j, folder))
		end
	end

	local p = Instance.new("Part")
	p.Name = "Root"
	p.Anchored = true
	p.CanCollide = false
	p.CastShadow = false
	p.Transparency = 1

	p.Position = origin

	table.insert(t, p)

	return t
end

local function isolateXZ(vec: Vector3): Vector3
	return Vector3.new(vec.X, 0, vec.Z)
end

function Grid:shareSamePosition(grid: grid, blockPos: Vector3): boolean
	local root = grid[#grid]
	local offset = blockPos - root.Position

	local half = (35 * 3.5) / 2

	return math.abs(offset.X) <= half and math.abs(offset.Z) <= half
end

return Grid
