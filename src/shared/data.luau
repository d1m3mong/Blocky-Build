local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dataservicetyped = require(ReplicatedStorage.Packages.dataservicetyped)

local template = {
	currency = {
		Coins = 1000,
		Wins = 0,
	},

	firstJoined = nil,
	lastLeft = nil,

	Abilities = {},
}

return dataservicetyped({
	template = template,
	--resetData = true,
})
