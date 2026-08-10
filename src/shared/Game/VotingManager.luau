local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Themes = require(script.Parent.Themes)
local Packets = require(ReplicatedStorage.Shared.Packets)
local VotingManager = {}
VotingManager.__index = VotingManager

export type VotingManager = typeof(setmetatable(VotingManager, {}))

local function getRandomMaps()
	local result = {}

	while #result < 3 do
		local ran = math.random(1, #Themes.themes)
		local candidate = Themes.themes[ran]

		if table.find(result, candidate) then
			continue
		end

		table.insert(result, candidate)
	end

	return result
end

function VotingManager.new(): VotingManager
	local self = {}
	setmetatable(self, VotingManager)

	self.currentMaps = nil :: { any }?
	self.voting = false
	self.votes = {} :: { [number]: string }

	Packets.RequestVoteState.OnServerEvent:Connect(function(player: Player)
		if self.voting and self.currentMaps then
			Packets.StartVote:FireClient(player, self.currentMaps[1], self.currentMaps[2], self.currentMaps[3])
		end
	end)

	Packets.CastVote.OnServerEvent:Connect(function(player: Player, id: string)
		if not self.voting then
			return
		end

		print(id)

		local isValid = false

		for _, map in self.currentMaps do
			if map.Name == id then
				isValid = true
				break
			end
		end

		if not isValid then
			warn("[VotingManager]: ", player.Name, " vote is not Valid!")
			return
		end

		self.votes[player.UserId] = id
	end)

	Players.PlayerRemoving:Connect(function(player: Player, reason: Enum.PlayerExitReason)
		self.votes[player.UserId] = nil
	end)

	return self
end

function VotingManager:Votes(): string
	local counts: { [string]: number } = {}

	for _, mapName in self.votes do
		counts[mapName] = (counts[mapName] or 0) + 1
	end

	local winner = self.currentMaps[1].Name
	local best = -1

	for _, map in self.currentMaps do
		local count = counts[map.Name] or 0

		if count > best then
			best = count
			winner = map.Name
		end
	end

	return winner
end

function VotingManager.displayMaps(self: VotingManager)
	local maps = getRandomMaps()
	self.currentMaps = maps

	for _, player: Player in Players:GetPlayers() do
		Packets.StartVote:FireClient(player, maps[1], maps[2], maps[3])
	end
end

const InitialVotingTime = 10

function VotingManager.startVote(self: VotingManager): string
	self.voting = true
	self.votes = {}
	self:displayMaps()

	local currentTime = InitialVotingTime
	while task.wait(1) do
		currentTime -= 1

		for _, player: Player in Players:GetPlayers() do
			Packets.UpdateTimer:FireClient(player, currentTime)
		end

		if currentTime <= 0 then
			break
		end
	end

	self.voting = false

	local winnerName = self:Votes()

	self.currentMaps = nil

	for _, player: Player in Players:GetPlayers() do
		Packets.EndVote:FireClient(player)
	end

	return winnerName
end

return VotingManager
