local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local trove = require(ReplicatedStorage.Packages.trove)
local BlocksPlacement = require(ReplicatedStorage.Shared.Blocks.BlocksPlacement)
local Grid = require(ReplicatedStorage.Shared.Grid.Grid)
local Packets = require(ReplicatedStorage.Shared.Packets)

local grid = Grid:setupGrid()

local blockFolder = Instance.new("Folder")
blockFolder.Name = "BlockFolder"

blockFolder.Parent = workspace

local function snapToGrid(value: number, grid: number): number
	return math.round(value / grid) * grid
end

Packets.PlaceBlock.OnServerEvent:Connect(function(player: Player, data: { Vector3 | string })
	local block = {
		Position = Vector3.new(
			snapToGrid(data.Position.X, 5),
			snapToGrid(data.Position.Y, 5),
			snapToGrid(data.Position.Z, 5)
		),
		Id = data.Position,
	}

	BlocksPlacement:Place(block)
end)
