local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sift = require(ReplicatedStorage.Packages.sift)
local vide = require(ReplicatedStorage.Packages.vide)
local videRipple = require(ReplicatedStorage.Packages["vide-ripple"])

local Button = require(ReplicatedStorage.Shared.App.BasicComponents.Button)
local Frame = require(ReplicatedStorage.Shared.App.BasicComponents.Frame)
local ScreenGUI = require(ReplicatedStorage.Shared.App.BasicComponents.ScreenGUI)
local GuiWorld = require(ReplicatedStorage.Shared.Ecs.GuiWorld)
local Packets = require(ReplicatedStorage.Shared.Packets)

local player = Players.LocalPlayer

local source = vide.source
local root = vide.root

local useSpring = videRipple.useSpring

local hiddenPosition = Vector2.new(0.5, 1.4)
local finalPosition = Vector2.new(0.5, 0.5)

local openerSize = UDim2.fromScale(0.1, 0.15)

local isShopOpen = source(false)

local shopEntity = GuiWorld.Guis.Shop

--selene: allow(unused_variable, unscoped_variables)
app = root(function()
	local getPosition, positionSpring = useSpring(hiddenPosition, {
		dampingRatio = 0.7,
		frequency = 3,
	})

	local getPunch, punchSpring = useSpring(0, {
		dampingRatio = 0.3,
		frequency = 4,
	})

	local function toggleShop()
		local opening = not isShopOpen()

		punchSpring:setGoal(50, { impulse = 50 })
		task.delay(0.12, function()
			punchSpring:setGoal(0)
		end)

		if not GuiWorld.trySetOpen(shopEntity, opening) then
			return
		end

		isShopOpen(opening)
		positionSpring:setGoal(opening and finalPosition or hiddenPosition)
	end

	--selene: allow(mixed_table)
	return ScreenGUI {
		Name = "Shop",
		Parent = player.PlayerGui,
		IgnoreGuiInset = true,

		-- ShopOpener

		Button {
			Position = UDim2.fromScale(0.2, 0.8),
			AnchorPoint = Vector2.new(0.5, 0.5),

			Size = function()
				local punch = getPunch()
				return UDim2.new(
					openerSize.X.Scale,
					openerSize.X.Offset - punch,
					openerSize.Y.Scale,
					openerSize.Y.Offset - punch
				)
			end,

			OnClick = function()
				toggleShop()
			end,
		},

		-- ShopContainer

		Frame {
			Position = function()
				local pos = getPosition() :: Vector2
				return UDim2.fromScale(pos.X, pos.Y)
			end,

			Size = UDim2.fromScale(0.6, 0.6),
			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundColor3 = Color3.new(1, 0.5, 0),
		},
	}
end)
