local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local trove = require(ReplicatedStorage.Packages.trove)
local data = require(ReplicatedStorage.Shared.data).server

local troves = {}

local function setupLeaderstats(player: Player)
	local playerTrove = troves[player.UserId] :: typeof(trove.new())

	local leaderstats: Folder = playerTrove:Add(Instance.new("Folder"))
	leaderstats.Name = "leaderstats"

	leaderstats.Parent = player

	local votes = playerTrove:Add(Instance.new("NumberValue"))
	votes.Value = data[player].Votes()
	votes.Name = "Votes"

	votes.Parent = leaderstats

	local wins = playerTrove:Add(Instance.new("NumberValue"))
	wins.Value = data[player].currency.Wins()

	wins.Name = "Wins"

	wins.Parent = leaderstats

	playerTrove:Add(data[player].Votes.Changed(function(newVotes)
		votes.Value = newVotes
	end))

	playerTrove:Add(data[player].currency.Wins.Changed(function(newWins, oldWins)
		print(oldWins, newWins)
		wins.Value = newWins
	end))
end

Players.PlayerAdded:Connect(function(player: Player)
	data.Service:waitForData(player)

	troves[player.UserId] = trove.new()

	setupLeaderstats(player)
end)

Players.PlayerRemoving:Connect(function(player: Player, reason: Enum.PlayerExitReason)
	local playerTrove = troves[player.UserId] :: typeof(trove.new())

	playerTrove:Destroy()
end)
