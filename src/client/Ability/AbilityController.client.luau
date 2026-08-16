local ActivityHistoryEventService = game:GetService("ActivityHistoryEventService")
local DebuggerUIService = game:GetService("DebuggerUIService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packet = require(ReplicatedStorage.Packages.packet)
local vide = require(ReplicatedStorage.Packages.vide)
local Button = require(ReplicatedStorage.Shared.App.BasicComponents.Button)
local EventButton = require(ReplicatedStorage.Shared.App.BasicComponents.EventButton)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ImageLabel = require(ReplicatedStorage.Shared.App.BasicComponents.ImageLabel)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local TextLabel = require(ReplicatedStorage.Shared.App.BasicComponents.TextLabel)
local UIListLayout = require(ReplicatedStorage.Shared.App.BasicComponents.UIListLayout)
local UIPadding = require(ReplicatedStorage.Shared.App.BasicComponents.UIPadding)
local UIStroke = require(ReplicatedStorage.Shared.App.BasicComponents.UIStroke)
local UIState = require(ReplicatedStorage.Shared.App.Util.UIState)
local AbilitysConfig = require(ReplicatedStorage.Shared.Game.AbilitysConfig)
local Packets = require(ReplicatedStorage.Shared.Packets)
local data = require(ReplicatedStorage.Shared.data)
local data = require(ReplicatedStorage.Shared.data).client

local player = Players.LocalPlayer

local source = vide.source
local root = vide.root
local effect = vide.effect
local show = vide.show
local indexes = vide.indexes
local derive = vide.derive

local MenuOpen = source(false)
local abilities = source(AbilitysConfig) :: vide.Source<AbilitysConfig.AbilitiesType>
local selectedAbility = source(nil)
local playerAbilities = source(data.Abilities())

Packets.UpdateAbility.OnClientEvent:Connect(function(abilityName, equipped)
	print("UpdateAbility:", abilityName, equipped)

	local current = playerAbilities()
	local newAbilities = table.clone(current)

	if equipped then
		for name, ability in newAbilities do
			if name ~= abilityName and ability.Equipped then
				newAbilities[name] = table.clone(ability)
				newAbilities[name].Equipped = false
			end
		end
	end

	newAbilities[abilityName] = table.clone(newAbilities[abilityName] or {})
	newAbilities[abilityName].Equipped = equipped

	playerAbilities(newAbilities)
end)

local function createFrame(Ability: AbilitysConfig.AbilityType, name: string)
	--selene: allow(mixed_table)
	return Frame {
		Name = name,

		Size = UDim2.fromScale(0.15, 0.3),

		AnchorPoint = Vector2.new(0.5, 0.5),

		BackgroundTransparency = 1,

		EventButton {
			Text = "",

			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),

			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0, 0.466667, 1),

			UIStroke {
				StrokeThickness = 10,
			},

			OnClick = function()
				selectedAbility(name)
			end,
		},

		ImageLabel {
			Image = "",

			BackgroundTransparency = 0,
		},
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

			Size = UDim2.fromScale(0.075, 0.15),
			Position = UDim2.fromScale(0.05, 0.8),

			AnchorPoint = Vector2.new(0.5, 0.5),

			OnClick = function()
				MenuOpen(not MenuOpen())
				if UIState.isOpen("Abilities")() then
					UIState.close("Abilities")
				else
					UIState.open("Abilities")
				end
			end,
		},

		-- Ability

		Button {
			Text = "",

			Size = UDim2.fromScale(0.075, 0.15),
			Position = UDim2.fromScale(0.8, 0.65),

			AnchorPoint = Vector2.new(0.5, 0.5),

			OnClick = function()
				Packets.UseAbility:Fire()
			end,
		},

		show(function()
			return selectedAbility() ~= nil and MenuOpen()
		end, function()
			return Frame {

				Position = UDim2.fromScale(0.85, 0.5),
				Size = UDim2.fromScale(0.175, 0.6),

				AnchorPoint = Vector2.new(0.5, 0.5),

				BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),

				TextLabel {
					Text = function()
						return selectedAbility() or ""
					end,

					TextScaled = true,
					TextWrapped = true,

					Size = UDim2.fromScale(1, 0.2),
					Position = UDim2.fromScale(0.5, 0),

					AnchorPoint = Vector2.new(0.5, 0.5),

					BackgroundTransparency = 1,
				},

				Button {
					Text = derive(function()
						local pAbilities = playerAbilities()
						local ability = pAbilities[selectedAbility()]

						if not ability then
							return "Purchase"
						end

						if ability.Equipped then
							return "Dequip"
						end

						return "Equip"
					end),

					Size = UDim2.fromScale(1, 0.2),
					Position = UDim2.fromScale(0.5, 0.8),

					AnchorPoint = Vector2.new(0.5, 0.5),

					TextScaled = true,

					OnClick = function()
						local currentAbilities = playerAbilities()
						local selected = selectedAbility()

						if currentAbilities[selected] then
							Packets.EquipAbility:Fire(selected)
						else
							Packets.PurchaseAbility:Fire(selected)
						end
					end,
				},
			}
		end),

		show(MenuOpen, function()
			return Frame {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.5, 0.5),

				AnchorPoint = Vector2.new(0.5, 0.5),

				UIListLayout {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,

					ListPadding = UDim.new(0, 10),
				},

				indexes(abilities, function(abilitySource, value)
					return createFrame(abilitySource(), value)
				end),
			}
		end),
	}
	--vide.cleanup()
end)
