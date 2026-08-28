local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dataservicetyped = require(ReplicatedStorage.Packages.dataservicetyped)

local template = {
	currency = {
		Coins = 0,
		Wins = 0,
	},

	Votes = 0,

	firstJoined = nil,
	lastLeft = nil,

	Abilities = {},
}

return dataservicetyped({
	template = template,
	--resetData = true,
})
