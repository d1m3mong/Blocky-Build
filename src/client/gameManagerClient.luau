const ReplicatedStorage = game:GetService("ReplicatedStorage")
const vide = require(ReplicatedStorage.Packages.vide)
const Packets = require(ReplicatedStorage.Shared.Packets)
local source = vide.source

local ClientGameState = {}

local gameState = source("intermission")
local inGame = source(false)

function ClientGameState.getGameState()
	return gameState()
end

function ClientGameState.isInGame()
	return inGame()
end

Packets.UpdateGameState.OnClientEvent:Connect(function(state)
	gameState(state)
	inGame(state == "started" or state == "rating")
end)

return ClientGameState
