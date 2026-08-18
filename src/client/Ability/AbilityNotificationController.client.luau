local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local vide = require(ReplicatedStorage.Packages.vide)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local TextLabel = require(ReplicatedStorage.Shared.App.BasicComponents.TextLabel)
local UIGradient = require(ReplicatedStorage.Shared.App.BasicComponents.UIGradient)
local UIListLayout = require(ReplicatedStorage.Shared.App.BasicComponents.UIListLayout)
local Packets = require(ReplicatedStorage.Shared.Packets)

local player = Players.LocalPlayer

local root = vide.root
local source = vide.source
local indexes = vide.indexes
local action = vide.action
local changed = vide.changed

local notificationList = source({})

local nextOrder = 0

Packets.UsedAbility.OnClientEvent:Connect(function(playerName: string, abilityName: string, duration: number)
	local list = table.clone(notificationList())

	nextOrder += 1

	list[playerName] = {
		abilityName = abilityName,
		duration = duration,
		order = nextOrder,
	}

	notificationList(list)

	task.delay(10, function()
		local current = table.clone(notificationList())
		current[playerName] = nil
		notificationList(current)
	end)
end)

local numberSequence =
	{ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) }

local function appear(instance: GuiObject)
	local targetTransparency = instance.BackgroundTransparency
	instance.BackgroundTransparency = 1

	local scale = Instance.new("UIScale")
	scale.Scale = 0.6
	scale.Parent = instance

	TweenService:Create(
		instance,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ BackgroundTransparency = targetTransparency }
	):Play()

	TweenService:Create(scale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
		:Play()
end

local function createNotification(
	playerName: string,
	data: () -> { abilityName: string, duration: number, order: number }?
)
	--selene: allow(mixed_table)
	return Frame {
		Name = playerName,

		Size = UDim2.new(1, 0, 0, 30),

		LayoutOrder = function()
			local d = data()
			return d and d.order or 0
		end,

		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.3,

		UIGradient {
			GradientTransparency = NumberSequence.new(numberSequence),
		},

		TextLabel {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			TextScaled = true,
			TextWrapped = true,
			TextColor3 = Color3.new(1, 1, 1),

			Text = function()
				local d = data()
				return d and `{playerName} used {d.abilityName} for: {d.duration} Seconds!` or ""
			end,
		},

		action(function(instance)
			appear(instance)
		end),
	}
end

local app = root(function()
	local layout = UIListLayout {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, 6),
	}

	--selene: allow(mixed_table)
	local container = Frame {
		Position = UDim2.fromScale(0.5, 0.25),
		Size = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		BackgroundTransparency = 1,

		layout,

		indexes(notificationList, function(entryData, playerName)
			return createNotification(playerName, entryData)
		end),
	}

	local sizeTween: Tween? = nil

	local function resizeToContent()
		local height = layout.AbsoluteContentSize.Y

		if sizeTween then
			sizeTween:Cancel()
		end

		sizeTween = TweenService:Create(
			container,
			TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{ Size = UDim2.new(0.7, 0, 0, height) }
		)
		sizeTween:Play()
	end

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeToContent)
	task.defer(resizeToContent)

	return ScreenGUI {
		IgnoreGuiInset = true,
		Name = "AbilityNotifications",
		Parent = player.PlayerGui,

		container,
	}
end)
