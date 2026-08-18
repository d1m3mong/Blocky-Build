local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local PropsType = require(ReplicatedStorage.Shared.App.PropsType)

local create = vide.create
local source = vide.source
local spring = vide.spring

return function(props: PropsType.Props): TextButton
	local baseSize = props.Size
	local pressedSize = UDim2.fromScale(baseSize.X.Scale / 1.1, baseSize.Y.Scale / 1.1)

	local targetSize = source(baseSize)

	local animatedSize, setSpring = spring(targetSize, 0.25, 0.75)

	local button = create "TextButton" {
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
			targetSize(pressedSize)

			setSpring {
				impulse = Vector2.new(0.15, 0.15),
			}

			task.delay(0.12, function()
				targetSize(baseSize)
			end)

			if props.OnClick then
				props.OnClick()
			end
		end,

		MouseEnter = function()
			targetSize(pressedSize)

			setSpring { impulse = Vector2.new(0.1, 0.1) }
		end,

		MouseLeave = function()
			targetSize(baseSize)

			setSpring { impulse = Vector2.new(0.1, 0.1) }
		end,

		table.unpack(props),
	}

	return button
end
