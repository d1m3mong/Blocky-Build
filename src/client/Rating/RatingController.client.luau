local ExampleV2Service = game:GetService("ExampleV2Service")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local vide_ripple = require(ReplicatedStorage.Packages["vide-ripple"])
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
local show = vide.show

local finalFramePosition = Vector2.new(0.7, 0.5)
local hiddenFramePosition = Vector2.new(1.2, 0.5)

local finalResultPosition = Vector2.new(0.5, 0.5)
local hiddenResultPosition = Vector2.new(0.5, 1.5)

local ratingOngoing = source(false)
local targetFramePopup = source(finalFramePosition)
local targetResultPopup = source(hiddenFramePosition)
local currentlyRating = source(nil)

local stars = source({ 1, 2, 3, 4, 5 })
local selected = source(0)

local buttons = source({})

type ratingEntry = {
	UserId: number,
	Votes: number,
}

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

local function createNominee(entry: ratingEntry)
	print(entry)

	--selene: allow(mixed_table)
	return Frame {
		Size = UDim2.fromScale(1, 0.3),

		BackgroundTransparency = 0,

		TextLabel {
			Size = UDim2.fromScale(0.8, 0.3),
			Position = UDim2.fromScale(0.5, 0.2),
			AnchorPoint = Vector2.new(0.5, 0.5),

			Text = tostring(entry.UserId),

			TextScaled = true,
			BackgroundTransparency = 1,
		},

		TextLabel {
			Size = UDim2.fromScale(0.8, 0.3),
			Position = UDim2.fromScale(0.5, 0.7),
			AnchorPoint = Vector2.new(0.5, 0.5),

			Text = tostring(entry.Votes),

			TextScaled = true,
			BackgroundTransparency = 1,
		},
	}
end

Packets.PrompRate.OnClientEvent:Connect(function(state: boolean)
	ratingOngoing(state)
end)

Packets.PrompPlayerRate.OnClientEvent:Connect(function(plr: Player)
	selected(0)

	currentlyRating(plr)
end)

local nomineesList = {
	source(nil),
	source(nil),
	source(nil),
} :: { () -> ratingEntry? }

Packets.ReplicateNominations.OnClientEvent:Connect(function(nominees: { ratingEntry })
	for i, nomineesSource in nomineesList do
		nomineesSource(nominees[i])
	end
end)

local resultState: () -> boolean = source(false)

Packets.ResultState.OnClientEvent:Connect(function(state)
	resultState(state)
end)

root(function()
	local animatedFramePopup, _ = spring(targetFramePopup, 0.25, 0.45)
	local animatedResultPopup, setSpring = spring(targetResultPopup, 0.4, 0.45)

	effect(function()
		-- Rating
		if ratingOngoing() then
			targetFramePopup(finalFramePosition)
		else
			targetFramePopup(hiddenFramePosition)
		end

		-- Results
		local hasResults = nomineesList[1]() ~= nil

		if resultState() and hasResults then
			targetResultPopup(finalResultPosition)
		else
			targetResultPopup(hiddenResultPosition)
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
				Size = UDim2.fromScale(1, 0.25),

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
				Position = UDim2.fromScale(0.5, 0.3),
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

		Frame {
			--selene: allow(mixed_table)

			Position = function()
				local v = animatedResultPopup()

				return UDim2.fromScale(v.X, v.Y)
			end,

			Size = UDim2.fromScale(0.3, 0.8),

			AnchorPoint = Vector2.new(0.5, 0.5),

			UIListLayout {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			},

			show(function()
				return nomineesList[1]() ~= nil
			end, function()
				return createNominee(nomineesList[1]())
			end),

			show(function()
				return nomineesList[2]() ~= nil
			end, function()
				return createNominee(nomineesList[2]())
			end),

			show(function()
				return nomineesList[3]() ~= nil
			end, function()
				return createNominee(nomineesList[3]())
			end),
		},
	}
end)
