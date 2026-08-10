local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local PropsType = require(ReplicatedStorage.Shared.App.PropsType)

local create = vide.create

return function(props: PropsType.Props): UIPadding
	return create "UIPadding" {
		PaddingTop = props.PaddingTop,
		PaddingBottom = props.PaddingBottom,
		PaddingLeft = props.PaddingLeft,
		PaddingRight = props.PaddingRight,
	}
end
