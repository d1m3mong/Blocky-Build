local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameManager = require(ReplicatedStorage.Shared.Game.GameManager)

return {
	gameManager = GameManager.new(),
}
