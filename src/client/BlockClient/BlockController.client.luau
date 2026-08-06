local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlocksPlacement = require(ReplicatedStorage.Shared.Blocks.BlocksPlacement)

task.wait(5)

local player = Players.LocalPlayer

BlocksPlacement:start(player)
