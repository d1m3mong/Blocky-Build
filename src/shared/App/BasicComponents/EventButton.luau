local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local PropsType = require(ReplicatedStorage.Shared.App.PropsType)

local create = vide.create
local source = vide.source
local spring = vide.spring
local effect = vide.effect

local function resolveSize(size: UDim2 | (() -> UDim2)): UDim2
	if typeof(size) == "function" then
		return (size :: () -> UDim2)()
	end

	return size :: UDim2
end

return function(props: PropsType.Props): TextButton
	local pressFactor = source(1)
	local targetSize = source(resolveSize(props.Size))
	local animatedSize, setSpring = spring(targetSize, 0.25, 0.75)

	effect(function()
		local base = resolveSize(props.Size)
		local factor = pressFactor()

		targetSize(
			UDim2.new(base.X.Scale * factor, base.X.Offset * factor, base.Y.Scale * factor, base.Y.Offset * factor)
		)
	end)

	--selene: allow(mixed_table)
	return create "TextButton" {
		Size = function()
			return animatedSize()
		end,

		Position = props.Position,
		AnchorPoint = props.AnchorPoint,

		BackgroundTransparency = props.BackgroundTransparency,
		BackgroundColor3 = props.BackgroundColor3,

		Text = props.Text,
		TextScaled = props.TextScaled,

		Name = props.Name,

		Activated = function()
			pressFactor(1 / 1.1)
			setSpring({ impulse = Vector2.new(0.15, 0.15) })

			task.delay(0.12, function()
				pressFactor(1)
			end)

			if props.OnClick then
				props.OnClick()
			end
		end,

		MouseEnter = function()
			pressFactor(1 / 1.1)
			setSpring({ impulse = Vector2.new(0.1, 0.1) })
		end,

		MouseLeave = function()
			pressFactor(1)
			setSpring({ impulse = Vector2.new(0.1, 0.1) })
		end,

		table.unpack(props),
	}
end
