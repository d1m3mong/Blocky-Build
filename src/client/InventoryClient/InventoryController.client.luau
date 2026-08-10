local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local Button = require(ReplicatedStorage.Shared.App.BasicComponents.Button)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ImageLabel = require(ReplicatedStorage.Shared.App.BasicComponents.ImageLabel)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local UIListLayout = require(ReplicatedStorage.Shared.App.BasicComponents.UIListLayout)
local UIPadding = require(ReplicatedStorage.Shared.App.BasicComponents.UIPadding)
local UIStroke = require(ReplicatedStorage.Shared.App.BasicComponents.UIStroke)
local BlocksList = require(ReplicatedStorage.Shared.Blocks.BlocksList)
local SelectBlockSignal = require(ReplicatedStorage.Shared.Signals.SelectBlockSignal)

type dict = { [string]: any }

const root = vide.root
const create = vide.create
const indexes = vide.indexes
const source = vide.source

const blocks: dict = source(BlocksList.BlockList)

local player = Players.LocalPlayer
const playerGui = player:WaitForChild("PlayerGui")

local function createFrames()
	local frames = {}

	indexes(blocks, function(i: () -> (), key)
		local frame = Frame {
			Size = UDim2.fromScale(0.1, 0.8),
			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundTransparency = 1,

			--selene: allow(mixed_table)
			LayoutOrder = Enum.SortOrder.LayoutOrder,

			Button {
				Text = "",
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),

				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),

				--selene: allow(mixed_table)
				OnClick = function()
					SelectBlockSignal:Fire(key)
				end,

				ImageLabel {
					Image = i().Image,
					BackgroundTransparency = 1,

					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0.5, 0.5),

					AnchorPoint = Vector2.new(0.5, 0.5),
				},
			},
		}

		table.insert(frames, frame)
	end)

	return frames
end

local app = root(function()
	--selene: allow(mixed_table)
	return ScreenGUI {
		Name = "Inventory",
		Parent = playerGui,

		IgnoreGuiInset = true,

		Frame {
			Size = UDim2.fromScale(0.65, 0.15),
			Position = UDim2.fromScale(0.5, 0.9),

			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundColor3 = Color3.fromRGB(200, 100, 0),

			UIListLayout {
				LayoutOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,

				ListPadding = UDim.new(0, 10),
			},

			UIPadding {
				PaddingTop = UDim.new(0.1, 0),
			},

			createFrames(),
		},
	}
end)
