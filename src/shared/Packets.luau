local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packet = require(ReplicatedStorage.Packages.packet)

local payload = {
	Name = packet.String,
	Category = packet.String,
	Description = packet.String,
	Difficulty = packet.NumberU8,
}

return {
	PlaceBlock = packet("Placeblock", { Position = packet.Vector3S16, Id = packet.String }),
	DeleteBlock = packet("Deleteblock", { instance = packet.Instance, Position = packet.Vector3S16 }),

	UpdateTimer = packet("UpdateTimer", packet.NumberU16),

	StartVote = packet("StartVote", payload, payload, payload),
	EndVote = packet("EndVote"),
	CastVote = packet("CastVote", packet.String),
	RequestVoteState = packet("RequestVoteState"),
	GetWinningMapData = packet("GetWinningMapData", packet.String),

	PurchaseAbility = packet("ParchaseAbility", packet.String),
	EquipAbility = packet("EquipAbility", packet.String),
}
