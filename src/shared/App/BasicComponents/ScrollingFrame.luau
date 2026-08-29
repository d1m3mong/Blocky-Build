local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local PropsType = require(ReplicatedStorage.Shared.App.PropsType)

local create = vide.create

return function(props: PropsType.Props): ScrollingFrame
	--selene: allow(mixed_table)
	return create "ScrollingFrame" {
		Position = props.Position,
		Size = props.Size,

		AnchorPoint = props.AnchorPoint,

		BackgroundColor3 = props.BackgroundColor3,
		BackgroundTransparency = props.BackgroundTransparency,

		AutomaticCanvasSize = props.AutomaticCanvasSize,
		CanvasSize = props.CanvasSize,

		ScrollBarThickness = props.ScrollBarThickness,
		ScrollBarImageColor3 = props.ScrollBarImageColor3,
		ScrollBarImageTransparency = props.ScrollBarImageTransparency,

		table.unpack(props),
	}
end
