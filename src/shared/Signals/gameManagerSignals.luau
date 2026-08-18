local ReplicatedStorage = game:GetService("ReplicatedStorage")
local signal = require(ReplicatedStorage.Packages.signal)

return {
	gameStart = signal.new(),
	ratingStart = signal.new(),

	ratePlayer = signal.new(),
}
