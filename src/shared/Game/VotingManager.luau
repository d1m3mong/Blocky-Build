local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Themes = require(script.Parent.Themes)
local Packets = require(ReplicatedStorage.Shared.Packets)
local VotingManager = {}
VotingManager.__index = VotingManager

export type VotingManager = typeof(setmetatable(VotingManager, {}))

function VotingManager.new(): VotingManager
	local self = {}

	setmetatable(self, {})
	return self
end

local function getRandomMaps()
	local map = Themes.themes[1]

	print(map)
end

function VotingManager.startVote(self: VotingManager)
	Packets.StartVote:Fire()
end

return VotingManager
