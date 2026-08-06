local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GridTypes = require(script.Parent.GridTypes)

type tile = GridTypes.Tile
type grid = GridTypes.Grid

local Grid = {}
Grid.__index = Grid

local parts = Instance.new("Folder")
parts.Parent = workspace
parts.Name = "GridFolder"

local function createPart(Position: Vector3): ()
	local Tile = Instance.new("Part")
	Tile.Color = Color3.new(math.random() * 255, math.random() * 255, math.random() * 255)
	Tile.Size = Vector3.new(5, 0.5, 5)
	Tile.Position = Position

	Tile.Anchored = true

	Tile.Parent = parts

	return Tile
end

function Grid:setupGrid(): grid
	for i = 0, 10 do
		for j = 0, 10 do
			createPart(Vector3.new(i * 5, 1, j * 5)) --+ Vector3.new(-12.5, 0, -12.5))
		end
	end
end

return Grid
