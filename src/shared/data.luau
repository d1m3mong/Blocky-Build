local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dataservicetyped = require(ReplicatedStorage.Packages.dataservicetyped)

local template = {
	currency = {
		Wins = 0,
	},

	firstJoined = nil,
	lastLeft = nil,
}

return dataservicetyped({
	template = template,
})
