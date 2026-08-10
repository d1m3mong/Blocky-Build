local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local PropsType = require(ReplicatedStorage.Shared.App.PropsType)

local create = vide.create

return function(props: PropsType.Props): UIStroke
	return create "UIListLayout" {
		FillDirection = props.FillDirection,
		HorizontalAlignment = props.HorizontalAlignment,
		VerticalAlignment = props.VerticalAlignment,

		Padding = props.ListPadding,
		SortOrder = props.SortOrder,
	}
end
