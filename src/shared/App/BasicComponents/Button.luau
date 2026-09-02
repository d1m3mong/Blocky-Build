local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local PropsType = require(ReplicatedStorage.Shared.App.PropsType)
local TweenPress = require(ReplicatedStorage.Shared.App.Util.TweenPress)

local create = vide.create

return function(props: PropsType.Props): TextButton
	local button: TextButton

	--selene: allow(mixed_table)
	button = create "TextButton" {
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,

		BackgroundTransparency = props.BackgroundTransparency,
		BackgroundColor3 = props.BackgroundColor3,

		Text = props.Text,
		TextScaled = props.TextScaled,

		Activated = props.OnClick,
		Visible = props.Visible,

		table.unpack(props),
	}

	return button
end
