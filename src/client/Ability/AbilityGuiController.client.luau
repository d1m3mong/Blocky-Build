local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local Packets = require(ReplicatedStorage.Shared.Packets)

local player = Players.LocalPlayer

local root = vide.root
local source = vide.source
local show = vide.show

local isVisible = source(false)
local notificationList = source({})

Packets.SquidInk.OnClientEvent:Connect(function(isActive: boolean)
	isVisible(isActive)
end)

local app = root(function()
	--selene: allow(mixed_table)
	return ScreenGUI {
		IgnoreGuiInset = true,
		Name = "AbilityGui",

		Parent = player.PlayerGui,

		-- Squid AbilityGUI

		show(isVisible, function()
			return Frame {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.9, 0.9),

				AnchorPoint = Vector2.new(0.5, 0.5),

				BackgroundColor3 = Color3.new(0, 0, 0),

				ZIndex = 10000,
			}
		end),
	}
end)
