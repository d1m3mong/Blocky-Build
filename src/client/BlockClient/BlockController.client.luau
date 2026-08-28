local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local networker = require(ReplicatedStorage.Packages.networker).client
local jecs = require(ReplicatedStorage.Packages.jecs)
local ripple = require(ReplicatedStorage.Packages.ripple)
local trove = require(ReplicatedStorage.Packages.trove)
local BlocksList = require(ReplicatedStorage.Shared.Blocks.BlocksList)
local BlocksPlacement = require(ReplicatedStorage.Shared.Blocks.BlocksPlacement)
local Packets = require(ReplicatedStorage.Shared.Packets)
local DeleteBlockSignal = require(ReplicatedStorage.Shared.Signals.DeleteBlockSignal)
local SelectBlockSignal = require(ReplicatedStorage.Shared.Signals.SelectBlockSignal)
local player = Players.LocalPlayer

BlocksPlacement:start(player)

const blockSize = Vector3.new(5, 5, 5)

local t = trove.new()

local function determinBlockPosition()
	local mouse = player:GetMouse()

	local ray = workspace:Raycast(mouse.UnitRay.Origin, mouse.UnitRay.Direction * 1000)

	if not ray then
		return
	end

	local position = ray.Position + ray.Normal * (blockSize.Y / 2)

	return position
end

local function determinInstance(): RaycastResult
	local mouse = player:GetMouse()

	local ray = workspace:Raycast(mouse.UnitRay.Origin, mouse.UnitRay.Direction * 1000)

	if not ray then
		return
	end

	return ray
end

local deleteModeEnabled = false

DeleteBlockSignal:Connect(function(toggle: boolean)
	if toggle == true then
		deleteModeEnabled = true
	else
		deleteModeEnabled = false
	end
end)

local selectedBlock = nil

SelectBlockSignal:Connect(function(blockId: string)
	local block = BlocksList.BlockList[blockId]

	--print(blockId)

	if not block then
		warn(blockId)
		return
	end

	selectedBlock = blockId
end)

t = UserInputService.InputBegan:Connect(function(input: InputObject, gpe: boolean)
	if gpe then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local data = {}

		if deleteModeEnabled == true then
			local block = determinInstance()
			if not block then
				return
			end

			data.instance = block.Instance
			data.Position = block.Instance.Position

			Packets.DeleteBlock:Fire(data)

			return
		end

		if selectedBlock == nil then
			return
		end

		data.Position = determinBlockPosition()
		data.Id = selectedBlock

		Packets.PlaceBlock:Fire(data)
	end
end)

CollectionService:GetInstanceAddedSignal("PlacedBlock"):Connect(function(block)
	if not block:IsA("Part") then
		return
	end

	local originalSize = block.Size

	block.Size = Vector3.zero

	local spring = ripple.createSpring(block.Size, { frequency = 4, dampingRatio = 1 })

	spring:setGoal(originalSize)
	spring:start()

	spring:onChange(function(value, dt)
		block.Size = value
	end)
end)
