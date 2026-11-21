local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
const StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")

const gameManagerClient = require(StarterPlayer.StarterPlayerScripts.Client.gameManagerClient)
local vide = require(ReplicatedStorage.Packages.vide)
local EventButton = require(ReplicatedStorage.Shared.App.BasicComponents.EventButton)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ImageLabel = require(ReplicatedStorage.Shared.App.BasicComponents.ImageLabel)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local UIListLayout = require(ReplicatedStorage.Shared.App.BasicComponents.UIListLayout)
local UIPadding = require(ReplicatedStorage.Shared.App.BasicComponents.UIPadding)
local BlocksList = require(ReplicatedStorage.Shared.Blocks.BlocksList)
local SelectBlockSignal = require(ReplicatedStorage.Shared.Signals.SelectBlockSignal)
local Packets = require(ReplicatedStorage.Shared.Packets)

local root = vide.root
local source = vide.source
local spring = vide.spring
local effect = vide.effect
local create = vide.create

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local selectedBlock = source(nil)
local customColor = source(Color3.fromRGB(255, 255, 255))

local numberKeys = {
	Enum.KeyCode.One,
	Enum.KeyCode.Two,
	Enum.KeyCode.Three,
	Enum.KeyCode.Four,
	Enum.KeyCode.Five,
	Enum.KeyCode.Six,
	Enum.KeyCode.Seven,
	Enum.KeyCode.Eight,
	Enum.KeyCode.Nine,
}

local keybinds = {}

for index, name in BlocksList.BlockOrder do
	local key = numberKeys[index]
	if key then
		keybinds[key] = name
	end
end

keybinds[Enum.KeyCode.Nine] = BlocksList.CustomName

local function selectBlock(name: string)
	selectedBlock(name)
	SelectBlockSignal:Fire(name)
end

local function createSlot(name: string, order: number, tint: any?)
	local data = BlocksList.BlockList[name]
	local targetSize = source(UDim2.fromScale(1, 1))
	local animatedSize = spring(targetSize, 0.25, 0.75)

	--selene: allow(mixed_table)
	local frame = Frame {
		Size = UDim2.fromScale(0.1, 0.8),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		LayoutOrder = order,

		EventButton {
			Text = "",
			Name = name,

			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,

			Size = function()
				return animatedSize()
			end,

			OnClick = function()
				selectBlock(name)
			end,

			ImageLabel {
				Image = data.Image,
				ImageColor3 = tint or Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
			},
		},
	}

	effect(function()
		if selectedBlock() == name then
			targetSize(UDim2.fromScale(0.85, 0.85))
		else
			targetSize(UDim2.fromScale(1, 1))
		end
	end)

	return frame
end

local function createFrames()
	local frames = {}

	for index, name in BlocksList.BlockOrder do
		frames[index] = createSlot(name, index)
	end

	table.insert(frames, createSlot(BlocksList.CustomName, BlocksList.CustomSlot, customColor))

	return frames
end

local function paletteColors()
	local columns = 12
	local colors = {}

	for i = 0, columns - 1 do
		table.insert(colors, Color3.fromHSV(0, 0, 1 - i / (columns - 1)))
	end

	for _, sv in { { 1, 1 }, { 0.55, 1 }, { 1, 0.6 } } do
		for i = 0, columns - 1 do
			table.insert(colors, Color3.fromHSV(i / columns, sv[1], sv[2]))
		end
	end

	return colors
end

local function createColorPicker()
	local swatches = {}

	for index, color in paletteColors() do
		swatches[index] = create "TextButton" {
			Text = "",
			Name = tostring(index),
			LayoutOrder = index,
			BackgroundColor3 = color,
			AutoButtonColor = false,
			BorderSizePixel = 0,

			Activated = function()
				customColor(color)
				Packets.SetCustomColor:Fire(
					math.round(color.R * 255),
					math.round(color.G * 255),
					math.round(color.B * 255)
				)
			end,
		}
	end

	return Frame {
		Name = "ColorPicker",

		Visible = function()
			return selectedBlock() == BlocksList.CustomName
		end,

		Position = UDim2.fromScale(0.5, 0.7),
		Size = UDim2.fromScale(0.3, 0.2),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),

		create "UICorner" {
			CornerRadius = UDim.new(0, 8),
		},

		Frame {
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.94, 0.88),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,

			create "UIGridLayout" {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				CellSize = UDim2.fromScale(0.07, 0.2),
				CellPadding = UDim2.fromScale(0.01, 0.04),
			},

			swatches,
		},
	}
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

			Visible = function()
				return gameManagerClient.isInGame()
			end,

			UIListLayout {
				FillDirection = Enum.FillDirection.Horizontal,
				ListPadding = UDim.new(0, 10),
			},

			UIPadding {
				PaddingTop = UDim.new(0.1, 0),
			},

			createFrames(),
		},

		createColorPicker(),
	}
end)

UserInputService.InputBegan:Connect(function(input: InputObject, gpe: boolean)
	if gpe then
		return
	end

	local name = keybinds[input.KeyCode]

	if not name then
		return
	end

	selectBlock(name)
end)
