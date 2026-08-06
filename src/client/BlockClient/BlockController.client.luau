local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local networker = require(ReplicatedStorage.Packages.networker).client
local jecs = require(ReplicatedStorage.Packages.jecs)
local trove = require(ReplicatedStorage.Packages.trove)
local BlocksPlacement = require(ReplicatedStorage.Shared.Blocks.BlocksPlacement)
local Packets = require(ReplicatedStorage.Shared.Packets)
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

	local position = ray.Position + ray.Normal + (blockSize / 10)

	return position
end

t = UserInputService.InputBegan:Connect(function(input: InputObject, gpe: boolean)
	if gpe then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local data = {}

		data.Position = determinBlockPosition()
		data.Id = "White Wool"

		Packets.PlaceBlock:Fire(data)
	end
end)
