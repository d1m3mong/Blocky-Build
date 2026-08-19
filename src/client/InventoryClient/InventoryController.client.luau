local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local vide = require(ReplicatedStorage.Packages.vide)
local EventButton = require(ReplicatedStorage.Shared.App.BasicComponents.EventButton)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ImageLabel = require(ReplicatedStorage.Shared.App.BasicComponents.ImageLabel)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local UIListLayout = require(ReplicatedStorage.Shared.App.BasicComponents.UIListLayout)
local UIPadding = require(ReplicatedStorage.Shared.App.BasicComponents.UIPadding)
local BlocksList = require(ReplicatedStorage.Shared.Blocks.BlocksList)
local SelectBlockSignal = require(ReplicatedStorage.Shared.Signals.SelectBlockSignal)

type dict = { [string]: any }

local root = vide.root
local indexes = vide.indexes
local source = vide.source
local spring = vide.spring
local effect = vide.effect

local blocks: dict = source(BlocksList.BlockList)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local selectedBlock = source(nil)

local keybinds = {
	[Enum.KeyCode.One] = "Gray Wool",
	[Enum.KeyCode.Two] = "Black Wool",
	[Enum.KeyCode.Three] = "White Wool",
	[Enum.KeyCode.Four] = 4,
	[Enum.KeyCode.Five] = 5,
	[Enum.KeyCode.Six] = 6,
	[Enum.KeyCode.Seven] = 7,
	[Enum.KeyCode.Eight] = 8,
	[Enum.KeyCode.Nine] = 9,
}

local function createFrames()
	local frames = {}

	indexes(blocks, function(block, key)
		local targetSize = source(UDim2.fromScale(1, 1))
		local animatedSize = spring(targetSize, 0.25, 0.75)

		--selene: allow(mixed_table)
		local frame = Frame {
			Size = UDim2.fromScale(0.1, 0.8),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,

			EventButton {
				Text = "",
				Name = tostring(key),

				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,

				Size = function()
					return animatedSize()
				end,

				OnClick = function()
					selectedBlock(key)
					SelectBlockSignal:Fire(key)
				end,

				ImageLabel {
					Image = block().Image,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
				},
			},
		}

		effect(function()
			if selectedBlock() == key then
				targetSize(UDim2.fromScale(0.85, 0.85))
			else
				targetSize(UDim2.fromScale(1, 1))
			end
		end)

		table.insert(frames, frame)
	end)

	return frames
end

root(function()
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

UserInputService.InputBegan:Connect(function(input: InputObject, gpe: boolean)
	if gpe then
		return
	end

	local index = keybinds[input.KeyCode]

	if not index then
		return
	end

	selectedBlock(index)
	SelectBlockSignal:Fire(index)
end)
