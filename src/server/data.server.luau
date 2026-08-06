local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local trove = require(ReplicatedStorage.Packages.trove)
local data = require(ReplicatedStorage.Shared.data).server

Players.PlayerAdded:Connect(function(player: Player)
	local playerData = data.Service:waitForData(player)

	playerData.firstJoined(os.time())
end)

Players.PlayerRemoving:Connect(function(player: Player, reason: Enum.PlayerExitReason)
	local playerData = data.Service:waitForData(player)

	playerData.lastLeft(os.time())
end)
