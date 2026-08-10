local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packet = require(ReplicatedStorage.Packages.packet)

return {
	PlaceBlock = packet("Placeblock", { Position = packet.Vector3S16, Id = packet.String }),
	DeleteBlock = packet("Deleteblock", { instance = packet.Instance, Position = packet.Vector3S16 }),

	UpdateTimer = packet("UpdateTimer", packet.NumberU16),

	StartVote = packet("StartVote", { Id = packet.String }, { Id = packet.String }, { Id = packet.String }),
}
