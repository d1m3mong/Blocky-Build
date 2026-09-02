local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local vide_ripple = require(ReplicatedStorage.Packages["vide-ripple"])

local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local TextLabel = require(ReplicatedStorage.Shared.App.BasicComponents.TextLabel)

local data = require(ReplicatedStorage.Shared.data).client

local source = vide.source
local root = vide.root
local effect = vide.effect
local untrack = vide.untrack

local useSpring = vide_ripple.useSpring
local useMotion = vide_ripple.useMotion
local useTween = vide_ripple.useTween

local playerCoins = source(data.currency.Coins())

local random = Random.new()

data.currency.Coins.Changed(function(newCoins)
	playerCoins(newCoins)
end)

local initialPosition = Vector2.new(0.0075, 0.9)
local ghostStartPosition = Vector2.new(initialPosition.X + 0.16, initialPosition.Y)

local function ghostNumber(change: number, parent: Instance)
	local ghostLabel: TextLabel

	local destroy = root(function()
		local getPosition, positionMotion = useMotion(ghostStartPosition, {
			start = true,

			tween = {
				duration = 0.7,
				easing = "quadOut",
			},
		})

		local getTransparency, transparencyTween = useTween(0, {
			start = true,
			duration = 0.7,
			easing = "quadIn",
		})

		local getRotation, rotationMotion = useMotion(-10, {
			start = true,

			tween = {
				duration = 0.7,
				easing = "backOut",
			},
		})

		ghostLabel = TextLabel {
			Text = "+" .. tostring(change),

			Position = function()
				local position = getPosition()
				return UDim2.fromScale(position.X, position.Y)
			end,

			Size = UDim2.fromScale(0.14, 0.06),
			AnchorPoint = Vector2.new(1, 0.5),

			Rotation = function()
				return getRotation()
			end,

			TextTransparency = function()
				return getTransparency()
			end,

			TextStrokeTransparency = function()
				return math.min(1, getTransparency() + 0.1)
			end,

			TextColor3 = Color3.fromRGB(255, 220, 65),
			TextStrokeColor3 = Color3.fromRGB(85, 55, 0),
			BackgroundTransparency = 1,
			TextScaled = true,
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 2,
		}

		task.defer(function()
			positionMotion:tween(
				Vector2.new(
					ghostStartPosition.X + random:NextNumber(-0.1, 0.1),
					ghostStartPosition.Y - random:NextNumber(0, 0.1)
				)
			)

			transparencyTween:setGoal(1)
			rotationMotion:tween(random:NextNumber(-12, 12))
		end)
	end)

	ghostLabel.Parent = parent

	task.delay(0.8, function()
		ghostLabel.Parent = nil
		destroy()
	end)
end

root(function()
	local getWidth, widthSpring = useSpring(0.2, {
		precision = 0.0001,
		speed = 26,
		damping = 0.5,
	})

	local getHeight, heightSpring = useSpring(0.2, {
		precision = 0.0001,
		speed = 22,
		damping = 0.56,
	})

	local ghostLayer = Frame {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = 2,
	}

	local initialized = false
	local lastCoins = playerCoins()

	effect(function()
		local coins = playerCoins()
		local gainedCoins = coins - lastCoins
		lastCoins = coins

		if not initialized then
			initialized = true
			return
		end

		if gainedCoins > 0 then
			local strength = math.clamp(1.4 + gainedCoins * 0.025, 1.4, 3.2)

			widthSpring:impulse(strength)
			heightSpring:impulse(-strength * 0.38)

			untrack(function()
				ghostNumber(gainedCoins, ghostLayer)
			end)
		else
			widthSpring:impulse(-0.45)
			heightSpring:impulse(0.12)
		end
	end)

	--selene: allow(mixed_table)
	return ScreenGUI {
		IgnoreGuiInset = true,
		Name = "DataGui",
		Parent = Players.LocalPlayer.PlayerGui,

		ghostLayer,

		Frame {
			Position = UDim2.fromScale(initialPosition.X, initialPosition.Y),
			AnchorPoint = Vector2.new(0, 0.5),

			Size = function()
				return UDim2.fromScale(getWidth(), getHeight())
			end,

			BackgroundTransparency = 1,

			TextLabel {
				Text = function()
					return tostring(playerCoins())
				end,

				Position = UDim2.fromScale(1, 0.5),
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.fromScale(1, 1),

				BackgroundTransparency = 1,
				TextScaled = true,
				TextWrapped = true,

				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
			},
		},
	}
end)
