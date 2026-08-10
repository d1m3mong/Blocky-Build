local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local PropsType = require(ReplicatedStorage.Shared.App.PropsType)

local create = vide.create

return function(props: PropsType.Props): UICorner
	--selene: allow(mixed_table)
	return create "TextLabel" {
		Position = props.Position,
		Size = props.Size,

		AnchorPoint = props.AnchorPoint,

		Text = props.Text,

		TextColor3 = props.TextColor3,

		TextScaled = props.TextScaled,

		table.unpack(props),
	}
end
