local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GridTypes = require(script.Parent.GridTypes)

type tile = GridTypes.Tile
type grid = GridTypes.Grid

local Grid = {}
Grid.__index = Grid

local function createPart(Position: Vector3, index: number, folder: Folder): ()
	local Tile = Instance.new("Part")
	Tile.Color = if index % 2 == 0 then Color3.fromRGB(232, 230, 230) else Color3.fromRGB(143, 143, 143)
	Tile.Size = Vector3.new(5, 0.5, 5)
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

	local gridSize = 11
	local tileSize = 5
	local offset = (gridSize - 1) / 2

	for i = 0, gridSize - 1 do
		for j = 0, gridSize - 1 do
			local position = part.Position + Vector3.new((i - offset) * tileSize, 1, (j - offset) * tileSize)

			table.insert(t, createPart(position, i - j, folder))
		end
	end

	local p = Instance.new("Part")
	p.Name = "Root"
	p.Anchored = true
	p.CanCollide = false
	p.CastShadow = false
	p.Transparency = 1

	p.Position = part.Position

	table.insert(t, p)

	return t
end

local function isolateXZ(vec: Vector3): Vector3
	return Vector3.new(vec.X, 0, vec.Z)
end

function Grid:shareSamePosition(grid: grid, blockPos: Vector3): boolean
	for _, tile: tile in grid do
		if blockPos.X ~= tile.Position.X or blockPos.Z ~= tile.Position.Z then
			continue
		end

		return true
	end

	return
end

return Grid
