local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StudioScriptDebugEventListener = game:GetService("StudioScriptDebugEventListener")
local vide = require(ReplicatedStorage.Packages.vide)
local EventButton = require(ReplicatedStorage.Shared.App.BasicComponents.EventButton)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ImageLabel = require(ReplicatedStorage.Shared.App.BasicComponents.ImageLabel)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local TextLabel = require(ReplicatedStorage.Shared.App.BasicComponents.TextLabel)
local UIListLayout = require(ReplicatedStorage.Shared.App.BasicComponents.UIListLayout)
local Packets = require(ReplicatedStorage.Shared.Packets)

local player = Players.LocalPlayer

local source = vide.source
local spring = vide.spring
local root = vide.root
local effect = vide.effect
local indexes = vide.indexes

local finalFramePosition = Vector2.new(0.7, 0.5)
local hiddenFramePosition = Vector2.new(1.2, 0.5)

local ratingOngoing = source(false)
local targetFramePopup = source(finalFramePosition)
local currentlyRating = source(nil)

local stars = source({ 1, 2, 3, 4, 5 })
local selected = source(0)

local buttons = source({})

local function createStars(key: number)
	return EventButton {
		Size = UDim2.fromScale(0.95 / 5, 4 / 5),

		AnchorPoint = Vector2.new(0.5, 0.5),

		Name = tostring(key),

		BackgroundColor3 = function()
			if selected() >= key then
				return Color3.fromRGB(255, 234, 0)
			end

			return Color3.fromRGB(80, 80, 80)
		end,

		OnClick = function()
			selected(key)

			local currentPlayer = currentlyRating()

			if currentPlayer then
				Packets.RatePlayer:Fire(currentPlayer, key)
			end
		end,
	}
end

Packets.PrompRate.OnClientEvent:Connect(function(state: boolean)
	ratingOngoing(state)
end)

Packets.PrompPlayerRate.OnClientEvent:Connect(function(plr: Player)
	selected(0)

	currentlyRating(plr)
end)

root(function()
	local animatedFramePopup, setSpring = spring(targetFramePopup, 0.25, 0.45)

	effect(function()
		if ratingOngoing() == true then
			targetFramePopup(finalFramePosition)
		else
			targetFramePopup(hiddenFramePosition)
		end
	end)

	--selene: allow(mixed_table)
	return ScreenGUI {
		IgnoreGuiInset = true,
		Name = "Rating",

		Parent = player.PlayerGui,

		Frame {
			Position = function()
				local v = animatedFramePopup()

				return UDim2.fromScale(v.X, v.Y)
			end,

			Size = UDim2.fromScale(0.25, 0.6),

			AnchorPoint = Vector2.new(0.5, 0.5),

			TextLabel {
				Position = UDim2.fromScale(0.5, 0.1),
				Size = UDim2.fromScale(1 / 5, 0.15),

				AnchorPoint = Vector2.new(0.5, 0.5),

				Text = function()
					if currentlyRating() == nil then
						return ""
					end

					local currentPlayer: Player = currentlyRating()
					return currentPlayer.Name
				end,

				TextScaled = true,
				TextWrapped = true,

				BackgroundTransparency = 1,
			},

			ImageLabel {
				Position = UDim2.fromScale(0.5, 0.25),
				Size = UDim2.fromScale(1 / 4, 1 / 4),

				AnchorPoint = Vector2.new(0.5, 0.5),

				Image = function()
					local currentPlayer: Player? = currentlyRating()
					if not currentPlayer then
						return "rbxassetid://0"
					end

					local success, content, isReady = pcall(
						Players.GetUserThumbnailAsync,
						Players,
						currentPlayer.UserId,
						Enum.ThumbnailType.HeadShot,
						Enum.ThumbnailSize.Size180x180
					)

					if not success or not isReady then
						return "rbxassetid://0"
					end

					return content
				end,
			},

			Frame {
				Position = UDim2.fromScale(0.5, 0.85),
				Size = UDim2.fromScale(1, 0.2),

				AnchorPoint = Vector2.new(0.5, 0.5),

				BackgroundTransparency = 1,

				UIListLayout {
					SortOrder = Enum.SortOrder.Name,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,

					ListPadding = UDim.new(0, 2),
				},

				indexes(stars, function(f, k)
					local starButton = createStars(k)
					buttons(starButton)

					return starButton
				end),
			},
		},
	}
end)
