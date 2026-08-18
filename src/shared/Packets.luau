local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packet = require(ReplicatedStorage.Packages.packet)

local payload = {
	Name = packet.String,
	Category = packet.String,
	Description = packet.String,
	Difficulty = packet.NumberU8,
}

return {
	-- Blocks

	PlaceBlock = packet("Placeblock", { Position = packet.Vector3S16, Id = packet.String }),
	DeleteBlock = packet("Deleteblock", { instance = packet.Instance, Position = packet.Vector3S16 }),

	-- Timer

	UpdateTimer = packet("UpdateTimer", packet.NumberU16),

	-- Voting

	StartVote = packet("StartVote", payload, payload, payload),
	EndVote = packet("EndVote"),
	CastVote = packet("CastVote", packet.String),
	RequestVoteState = packet("RequestVoteState"),
	GetWinningMapData = packet("GetWinningMapData", packet.String),

	-- Abilities

	PurchaseAbility = packet("PurchaseAbility", packet.String),
	EquipAbility = packet("EquipAbility", packet.String),
	UpdateAbility = packet("UpdateAbility", packet.String, packet.Boolean8),
	UseAbility = packet("UseAbility"),

	UsedAbility = packet("UsedAbility", packet.String, packet.String, packet.NumberU8),
	SquidInk = packet("SquidInk", packet.Boolean8),

	-- Rating

	PrompRate = packet("PrompRate", packet.Boolean8),
	PrompPlayerRate = packet("PrompPlayerRate", packet.Instance),
	RatePlayer = packet("Rate", packet.Instance, packet.NumberU8),
}
