local ExampleV2Service = game:GetService("ExampleV2Service")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packet = require(ReplicatedStorage.Packages.packet)
local vide = require(ReplicatedStorage.Packages.vide)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local TextLabel = require(ReplicatedStorage.Shared.App.BasicComponents.TextLabel)
local UIListLayout = require(ReplicatedStorage.Shared.App.BasicComponents.UIListLayout)
local Packets = require(ReplicatedStorage.Shared.Packets)

local player = Players.LocalPlayer

local root = vide.root
local source = vide.source
local indexes = vide.indexes
local derive = vide.derive
local show = vide.show
local action = vide.action

type Map = {
	Name: string,
	Difficulty: number,
	Category: string,
	Description: string,
}

local mapSlot1: () -> Map? = source(nil)
local mapSlot2: () -> Map? = source(nil)
local mapSlot3: () -> Map? = source(nil)

Packets.StartVote.OnClientEvent:Connect(function(map1: Map, map2: Map, map3: Map)
	mapSlot1(map1)
	mapSlot2(map2)
	mapSlot3(map3)
end)

Packets.EndVote.OnClientEvent:Connect(function()
	mapSlot1(nil)
	mapSlot2(nil)
	mapSlot3(nil)
end)

Packets.RequestVoteState:Fire()

local function MapCard(mapSource: () -> Map?)
	--selene: allow(mixed_table)
	return Frame {
		Size = UDim2.fromScale(1 / 3, 1),
		BackgroundTransparency = 1,

		show(function()
			return mapSource() ~= nil
		end, function()
			local map = mapSource() :: Map

			return Frame {
				Size = UDim2.fromScale(0.95, 0.95),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),

				BackgroundColor3 = Color3.fromRGB(255, 255, 255),

				action(function(instance: Frame)
					local connection = instance.InputBegan:Connect(function(input: InputObject)
						if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
							return
						end

						Packets.CastVote:Fire(map.Name)
					end)

					return function()
						connection:Disconnect()
					end
				end),

				UIListLayout {
					FillDirection = Enum.FillDirection.Vertical,
				},

				TextLabel {
					Text = map.Name,
					TextScaled = true,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 30),
				},

				TextLabel {
					Text = map.Category,
					TextScaled = true,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 24),
				},

				TextLabel {
					Text = map.Description,
					TextScaled = true,
					TextWrapped = true,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, -59),
				},
			}
		end),
	}
end

local app = root(function()
	--selene: allow(mixed_table)

	ScreenGUI {
		Parent = player.PlayerGui,
		IgnoreGuiInset = true,

		Frame {
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.7, 0.5),

			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundTransparency = 1,

			UIListLayout {
				FillDirection = Enum.FillDirection.Horizontal,
			},

			MapCard(mapSlot1),
			MapCard(mapSlot2),
			MapCard(mapSlot3),
		},
	}
end)
