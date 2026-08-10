local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ecs = require(ReplicatedStorage.Shared.Ecs.World)
local BlockTypes = require(script.Parent.BlockTypes)

const World = Ecs.world
const Position = Ecs.Position
const instance = Ecs.instance
const id = Ecs.id
const Data = Ecs.data

local BlockManager = {}
BlockManager.__index = BlockManager

function BlockManager:clearBlocks(player: Player): ()
	local blockFolder = workspace:FindFirstChild("BlocksFolder" .. player.UserId) :: Folder?
	if not blockFolder then
		return
	end

	if #blockFolder:GetChildren() <= 0 then
		return
	end

	for _, block: BlockTypes.Block in blockFolder:GetChildren() do
		block:Destroy()
	end

	for _Entity, ownerValue, ins in World:query(Ecs.owner, instance) do
		if ownerValue == player.UserId then
			World:delete(_Entity)
		end
	end

	print("Deleted:" .. player.UserId)
end

function BlockManager:deleteBlock(player: Player, data: { instance: Instance, Position: Vector3 }): ()
	local blockFolder = workspace:FindFirstChild("BlocksFolder" .. player.UserId) :: Folder?
	if not blockFolder then
		return
	end

	local blockInstance = data.instance

	for _, block: BlockTypes.Block in blockFolder:GetChildren() do
		if block == blockInstance and block.Position == data.Position then
			block:Destroy()

			for _Entity, ins in World:query(instance) do
				if ins == blockInstance then
					World:delete(_Entity)
					break
				end
			end
		end
	end
end
return BlockManager
