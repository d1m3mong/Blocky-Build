local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packet = require(ReplicatedStorage.Packages.packet)
local AbilityEffectManager = require(script.Parent.AbilityEffectManager)
local BlocksManager = require(ReplicatedStorage.Shared.Blocks.BlocksManager)
local AbilitysConfig = require(ReplicatedStorage.Shared.Game.AbilitysConfig)
local GameSingleton = require(ReplicatedStorage.Shared.GameSingleton)
local Packets = require(ReplicatedStorage.Shared.Packets)
local gameManagerSignals = require(ReplicatedStorage.Shared.Signals.gameManagerSignals)
local data = require(ReplicatedStorage.Shared.data).server

local playerCooldowns = {}

local function getPlayerEquippedAbility(player: Player): string?
	local playerAbilities = data[player].Abilities()

	local equipped

	for name, value in playerAbilities do
		if value.Equipped then
			equipped = name
			break
		end
	end

	return equipped
end

Packets.UseAbility.OnServerEvent:Connect(function(player: Player)
	local state = GameSingleton:getGameState()
	if state ~= "started" then
		return
	end

	local ability = getPlayerEquippedAbility(player)
	if not ability then
		warn("[AbilityService]: No Equipped Ability for: " .. player.Name)
		return
	end

	if playerCooldowns[player.UserId] then
		warn("CD for: " .. player.UserId)
		return
	end

	playerCooldowns[player.UserId] = true

	for _, plr in Players:GetPlayers() do
		Packets.UsedAbility:FireClient(plr, player.Name, ability, AbilitysConfig[ability].Duration)
	end

	task.delay(AbilitysConfig[ability].Cooldown, function()
		playerCooldowns[player.UserId] = false
	end)

	if ability == "Freeze" then
		for _, plr in Players:GetPlayers() do
			if plr == player then
				continue
			end

			local char = plr.Character
			if not char then
				continue
			end

			local root: BasePart? = char:FindFirstChild("HumanoidRootPart")
			if not root then
				continue
			end

			root.Anchored = true

			AbilityEffectManager:applyEffect(plr, AbilitysConfig[ability].Duration, function()
				if root.Parent then
					root.Anchored = true
				end
			end)
		end
	end

	if ability == "50/50" then
		for _, plr in Players:GetPlayers() do
			if plr == player then
				continue
			end

			local blockFolder = workspace:FindFirstChild("BlocksFolder" .. plr.UserId) :: Folder?
			if not blockFolder then
				continue
			end

			local children = blockFolder:GetChildren()
			local count = #children
			if count <= 0 then
				continue
			end

			local iterations = math.floor(count / 2)
			for i = 1, iterations do
				children = blockFolder:GetChildren()
				if #children == 0 then
					break
				end

				local randomIndex = math.random(1, #children)
				local block = children[randomIndex]

				BlocksManager:deleteBlock(plr, {
					instance = block,
					Position = block.Position,
				})
			end
		end
	end

	if ability == "Color Mix" then
		for _, plr in Players:GetPlayers() do
			if plr == player then
			end

			local blockFolder = workspace:FindFirstChild("BlocksFolder" .. plr.UserId) :: Folder?
			if not blockFolder then
				continue
			end

			for _, block in blockFolder:GetChildren() do
				block.Color = Color3.new(math.random(), math.random(), math.random())
			end
		end
	end

	if ability == "Gravity" then
		local gravity = workspace.Gravity
		workspace.Gravity = gravity / 5

		local revertGravityOnce = false

		for _, plr in Players:GetPlayers() do
			local char = plr.Character
			if not char then
				continue
			end

			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				continue
			end

			local jumpHeight = humanoid.JumpHeight
			humanoid.JumpHeight = jumpHeight * 5

			AbilityEffectManager:applyEffect(plr, AbilitysConfig[ability].Duration, function()
				if not revertGravityOnce then
					revertGravityOnce = true
					workspace.Gravity = gravity
				end
				if humanoid.Parent then
					humanoid.JumpHeight = jumpHeight
				end
			end)
		end
	end

	if ability == "Squid Ink" then
		for _, plr in Players:GetPlayers() do
			if plr == player then
				continue
			end

			Packets.SquidInk:FireClient(plr, true)

			local connection: RBXScriptConnection
			connection = plr.PlayerGui.DescendantRemoving:Connect(function(instance: Instance)
				if instance.Name == "AbilityGui" then
					Packets.SquidInk:FireClient(plr, true)
					warn("Player is either Exploiting or experiencing a bug: " .. plr.Name)
				end
			end)

			AbilityEffectManager:applyEffect(plr, AbilitysConfig[ability].Duration, function()
				connection:Disconnect()
				Packets.SquidInk:FireClient(plr, false)
			end)
		end
	end
end)

gameManagerSignals.gameStart:Connect(function()
	for _, plr in Players:GetPlayers() do
		playerCooldowns[plr.UserId] = false
	end
end)

gameManagerSignals.ratingStart:Connect(function()
	for _, plr in Players:GetPlayers() do
		AbilityEffectManager:endAllEffects(plr)
	end
end)

Players.PlayerRemoving:Connect(function(player: Player, reason: Enum.PlayerExitReason)
	playerCooldowns[player.UserId] = nil
end)
