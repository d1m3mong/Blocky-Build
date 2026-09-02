local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.Packages.jecs)

local world = jecs.World.new()

local World = {
	world = world,
	isOpen = world:component() :: jecs.Component<boolean>,
}

World.Guis = {
	Abilities = world:entity(),
	--Result = world:entity(),
	Shop = world:entity(),
}

function World.isAnyOtherOpen(exclude: number): boolean
	for entity, isOpen in world:query(World.isOpen) do
		if entity ~= exclude and isOpen == true then
			return true
		end
	end

	return false
end

function World.trySetOpen(entity: number, open: boolean): boolean
	if open and World.isAnyOtherOpen(entity) then
		return false
	end

	world:set(entity, World.isOpen, open)
	return true
end

return World
