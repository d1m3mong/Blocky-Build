local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local PropsType = require(ReplicatedStorage.Shared.App.PropsType)

local create = vide.create

return function(props: PropsType.Props): ScreenGui
	--selene: allow(mixed_table)
	return create "ScreenGui" {
		IgnoreGuiInset = props.IgnoreGuiInset,
		Name = props.Name,
		Parent = props.Parent,

		table.unpack(props),
	}
end
