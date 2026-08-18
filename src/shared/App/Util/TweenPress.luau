local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

export type PressConfig = {
	instance: GuiObject,
	pressGoals: UDim2?,
	hoverGoals: UDim2?,
	idleGoals: UDim2?,
	speed: number?,
	damping: number?,
}

local source = vide.source
local spring = vide.spring

local TweenPress = {}

function TweenPress.attach(config: PressConfig): () -> ()
	local instance = config.instance

	local targetSize = source(config.idleGoals or instance.Size)

	local animatedSize = spring(targetSize, config.speed or 0.25, config.damping or 0.75)

	local connections = {}

	if config.pressGoals then
		table.insert(
			connections,
			(instance :: any).Activated:Connect(function()
				targetSize(config.pressGoals)
			end)
		)
	end

	if config.hoverGoals then
		table.insert(
			connections,
			instance.MouseEnter:Connect(function()
				targetSize(config.hoverGoals)
			end)
		)
	end

	if config.idleGoals then
		table.insert(
			connections,
			instance.MouseLeave:Connect(function()
				targetSize(config.idleGoals)
			end)
		)
	end

	local cleanup = function()
		for _, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
	end

	return cleanup, animatedSize
end

return TweenPress
