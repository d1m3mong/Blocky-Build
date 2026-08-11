local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local networker = require(ReplicatedStorage.Packages.networker)
local signal = require(ReplicatedStorage.Packages.signal)
local vide = require(ReplicatedStorage.Packages.vide)
local Button = require(ReplicatedStorage.Shared.App.BasicComponents.Button)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local TextLabel = require(ReplicatedStorage.Shared.App.BasicComponents.TextLabel)
local UIState = require(ReplicatedStorage.Shared.App.Util.UIState)
local Themes = require(ReplicatedStorage.Shared.Game.Themes)
local VotingManager = require(ReplicatedStorage.Shared.Game.VotingManager)
local Packets = require(ReplicatedStorage.Shared.Packets)
local DeleteBlockSignal = require(ReplicatedStorage.Shared.Signals.DeleteBlockSignal)
local DeletionModeSignal = require(ReplicatedStorage.Shared.Signals.DeletionModeSignal)

local show = vide.show

local player = Players.LocalPlayer
local playerGui = player:WaitForChild "PlayerGui"

local timer = vide.source(0)
local toggle = vide.source(false)
local winningMap = vide.source("")

Packets.UpdateTimer.OnClientEvent:Connect(function(t: number)
	timer(t)
end)

Packets.GetWinningMapData.OnClientEvent:Connect(function(mapName)
	winningMap(mapName)
end)

local votingOpen = UIState.isOpen("Voting")
const guiName = "HUD"

--selene: allow(unused_variable)
local app = vide.root(function()
	--selene: allow(mixed_table)
	return ScreenGUI {
		Name = "HUD",
		IgnoreGuiInset = true,

		Parent = playerGui,

		Frame {
			Position = UDim2.fromScale(0.05, 0.5),
			Size = UDim2.fromScale(0.1, 0.2),

			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundTransparency = 1,

			Color = Color3.fromRGB(255, 0, 155),

			Button {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),

				AnchorPoint = Vector2.new(0.5, 0.5),

				BackgroundColor3 = Color3.fromRGB(155, 155, 0),

				OnClick = function()
					toggle(not toggle())

					DeleteBlockSignal:Fire(toggle())
					DeletionModeSignal:Fire(toggle())
				end,
			},
		},

		Frame {
			Position = UDim2.fromScale(0.5, 0.1),
			Size = UDim2.fromScale(0.6, 0.2),

			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundTransparency = 1,

			TextLabel {
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),

				AnchorPoint = Vector2.new(0.5, 0.5),

				BackgroundTransparency = 1,

				TextScaled = true,

				Text = function()
					return tostring(timer())
				end,
			},
		},

		Frame {
			Position = UDim2.fromScale(0.9, 0.5),
			Size = UDim2.fromScale(0.2, 0.5),

			AnchorPoint = Vector2.new(0.5, 0.5),

			Visible = function()
				return not votingOpen()
			end,

			TextLabel {
				Visible = function()
					return not votingOpen()
				end,

				Text = function()
					return winningMap()
				end,

				TextScaled = true,
				Size = UDim2.fromScale(1, 0.2),
				AnchorPoint = Vector2.new(0.5, 0.5),

				Position = UDim2.fromScale(0.5, 0),
			},

			TextLabel {
				Visible = function()
					return not votingOpen()
				end,

				Text = function()
					local mapData = Themes.getMapData(winningMap())
					if mapData then
						return mapData.Description
					end

					return ""
				end,

				TextScaled = true,
				Size = UDim2.fromScale(1, 0.2),
				AnchorPoint = Vector2.new(0.5, 0.5),

				Position = UDim2.fromScale(0.5, 0.4),
			},
		},
	}
end)
