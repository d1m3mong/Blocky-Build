local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local Button = require(ReplicatedStorage.Shared.App.BasicComponents.Button)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local UIListLayout = require(ReplicatedStorage.Shared.App.BasicComponents.UIListLayout)
local UIPadding = require(ReplicatedStorage.Shared.App.BasicComponents.UIPadding)
local AbilitysConfig = require(ReplicatedStorage.Shared.Game.AbilitysConfig)

local player = Players.LocalPlayer

local source = vide.source
local root = vide.root
local effect = vide.effect
local show = vide.show
local indexes = vide.indexes

local MenuOpen = source(false)
local abilities = source(AbilitysConfig) :: vide.Source<AbilitysConfig.AbilitiesType>

local function createFrame(Ability: AbilitysConfig.AbilityType, name: string)
	return Frame {
		Name = name,

		Size = UDim2.fromScale(0.15, 0.3),

		AnchorPoint = Vector2.new(0.5, 0.5),

		BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
	}
end

--selene: allow(unused_variable, unscoped_variables)
app = root(function()
	--selene: allow(mixed_table)
	return ScreenGUI {
		IgnoreGuiInset = true,
		Name = "Abilities",

		Parent = player.PlayerGui,

		--AbilityMenu Opener

		Button {
			Text = "",

			Size = UDim2.fromScale(0.15, 0.3),
			Position = UDim2.fromScale(0.1, 0.5),

			AnchorPoint = Vector2.new(0.5, 0.5),

			OnClick = function()
				MenuOpen(not MenuOpen())
			end,
		},

		effect(function() end),

		show(MenuOpen, function()
			return Frame {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.65, 0.65),

				AnchorPoint = Vector2.new(0.5, 0.5),

				UIListLayout {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
				},

				indexes(abilities, function(abilitySource, value)
					return createFrame(abilitySource(), value)
				end),
			}
		end),
	}
end)
