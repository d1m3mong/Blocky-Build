local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local networker = require(ReplicatedStorage.Packages.networker)
local signal = require(ReplicatedStorage.Packages.signal)
local vide = require(ReplicatedStorage.Packages.vide)
local Button = require(ReplicatedStorage.Shared.App.BasicComponents.Button)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local TextLabel = require(ReplicatedStorage.Shared.App.BasicComponents.TextLabel)
local Packets = require(ReplicatedStorage.Shared.Packets)
local DeleteBlockSignal = require(ReplicatedStorage.Shared.Signals.DeleteBlockSignal)

local toggle = vide.source(false)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild "PlayerGui"

local timer = vide.source(0)

Packets.UpdateTimer.OnClientEvent:Connect(function(t: number)
	timer(t)
end)

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
				end,
			},
		},

		Frame {
			Position = UDim2.fromScale(0.5, 0.1),
			Size = UDim2.fromScale(0.6, 0.2),

			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundTransparency = 0,

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
	}
end)
