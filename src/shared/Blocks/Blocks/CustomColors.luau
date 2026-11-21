local CustomColors = {}

local colors: { [Player]: Color3 } = {}

function CustomColors.set(player: Player, color: Color3)
	colors[player] = color
end

function CustomColors.get(player: Player): Color3?
	return colors[player]
end

function CustomColors.clear(player: Player)
	colors[player] = nil
end

return CustomColors
