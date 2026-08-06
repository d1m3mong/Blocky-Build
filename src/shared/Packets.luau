local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packet = require(ReplicatedStorage.Packages.packet)

return {
	PlaceBlock = packet("Placeblock", { Position = packet.Vector3S16, Id = packet.String }),
}
