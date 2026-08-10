local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local PropsType = require(ReplicatedStorage.Shared.App.PropsType)

local create = vide.create

return function(props: PropsType.Props)
	--selene: allow(mixed_table)
	return create "ImageLabel" {
		Size = props.Size,
		Position = props.Position,

		AnchorPoint = props.AnchorPoint,

		BackgroundTransparency = props.BackgroundTransparency,

		Image = props.Image,

		table.unpack(props),
	}
end
