local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local trove = require(ReplicatedStorage.Packages.trove)
local BlocksManager = require(ReplicatedStorage.Shared.Blocks.BlocksManager)
local BlocksPlacement = require(ReplicatedStorage.Shared.Blocks.BlocksPlacement)
local GameSingleton = require(ReplicatedStorage.Shared.GameSingleton)
local Grid = require(ReplicatedStorage.Shared.Grid.Grid)
local Packets = require(ReplicatedStorage.Shared.Packets)
local PrompGridSignal = require(ReplicatedStorage.Shared.Signals.PrompGridSignal)

local grids = {}

PrompGridSignal:Connect(function(player: Player, promptedGrid)
	print(player.UserId)

	grids[player.UserId] = promptedGrid
end)

local blockFolder = Instance.new("Folder")
blockFolder.Name = "BlockFolder"

blockFolder.Parent = workspace

local function snapToGrid(value: number, grid: number): number
	return math.round(value / grid) * grid
end

Packets.PlaceBlock.OnServerEvent:Connect(function(player: Player, data: { Vector3 | string })
	local grid = grids[player.UserId]
	if not grid then
		warn("[BlockService]: Attemted to place a block with no grid assigned")
		return
	end

	local block = {
		Position = Vector3.new(
			snapToGrid(data.Position.X, 5),
			snapToGrid(data.Position.Y, 5),
			snapToGrid(data.Position.Z, 5)
		),
		Id = data.Id,

		data = {
			OnDeletion = function()
				print "Deleted"
			end,

			OnPlace = function(): ()
				print "Created"
			end,
		},
	}

	local isOnGrid = Grid:shareSamePosition(grid, block.Position)
	if not isOnGrid then
		return
	end

	local gameState = GameSingleton:getGameState()
	if gameState ~= "started" then
		return
	end

	BlocksPlacement:Place(block, player)
end)

Packets.DeleteBlock.OnServerEvent:Connect(function(player: Player, data: { Position: Vector3, instance: Instance }): ()
	local gameState = GameSingleton:getGameState()
	if gameState ~= "started" then
		return
	end

	BlocksManager:deleteBlock(player, data)
end)

Players.PlayerRemoving:Connect(function(player: Player, reason: Enum.PlayerExitReason)
	BlocksManager:clearBlocks(player)
	grids[player.UserId] = nil
end)
