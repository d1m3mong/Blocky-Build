local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local PropsType = require(ReplicatedStorage.Shared.App.PropsType)

local create = vide.create

return function(props: PropsType.Props)
	--selene: allow(mixed_table)
	return create "Frame" {
		Size = props.Size,
		Position = props.Position,

		AnchorPoint = props.AnchorPoint,

		BackgroundTransparency = props.BackgroundTransparency,

		BackgroundColor3 = props.BackgroundColor3,

		Visible = props.Visible,
		ZIndex = props.ZIndex,

		Name = props.Name,

		table.unpack(props),
	}
end
