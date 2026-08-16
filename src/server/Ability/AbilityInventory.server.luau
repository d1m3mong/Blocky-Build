local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packet = require(ReplicatedStorage.Packages.packet)
local AbilitysConfig = require(ReplicatedStorage.Shared.Game.AbilitysConfig)
local Packets = require(ReplicatedStorage.Shared.Packets)
local data = require(ReplicatedStorage.Shared.data).server

local function equipAbility(player: Player, abilityName: string)
	local playerData = data.Service:waitForData(player)

	if not playerData then
		warn("[AbilityInventory]: No playerData found!")
		return
	end

	local abilities = playerData.Abilities()
	local ability = abilities[abilityName]

	if not ability then
		warn("[AbilityInventory]: Player doesn't own:", abilityName)
		return
	end

	if ability.Equipped then
		local newAbilities = table.clone(abilities)
		newAbilities[abilityName] = table.clone(ability)
		newAbilities[abilityName].Equipped = false

		playerData.Abilities(newAbilities)

		print("Dequipped:", abilityName)
		return abilityName, false
	end

	local newAbilities = table.clone(abilities)

	for name, ownedAbility in newAbilities do
		if ownedAbility.Equipped then
			newAbilities[name] = table.clone(ownedAbility)
			newAbilities[name].Equipped = false
		end
	end

	newAbilities[abilityName] = table.clone(ability)
	newAbilities[abilityName].Equipped = true

	playerData.Abilities(newAbilities)

	print("Equipped:", abilityName)

	return abilityName, true
end

local function purchaseAbility(player: Player, abilityName: string)
	local playerData = data.Service:waitForData(player)
	if not playerData then
		warn("[AbilityInventory]: No playerData found!")
		return
	end

	local abilities = playerData.Abilities()
	if abilities[abilityName] then
		warn("[AbilityInventory]: Tried to purchase an already owned Ability")
		return equipAbility(player, abilityName)
	end

	local cost = AbilitysConfig[abilityName].Cost
	if playerData.currency.Coins() < cost then
		warn("[AbilityInventory]: Player dosnt have enough money to afford ability!")
		return
	end

	playerData.currency.Coins(function(old: number)
		return old - cost
	end)

	local newAbilities = table.clone(abilities)

	for name, v in newAbilities do
		if v.Equipped then
			newAbilities[name] = table.clone(v)
			newAbilities[name].Equipped = false
		end
	end

	newAbilities[abilityName] = {
		Equipped = true,
	}

	playerData.Abilities(newAbilities)

	print(player.Name .. ": bought " .. abilityName .. ". Coins remaining: " .. playerData.currency.Coins())

	return abilityName, true
end

Packets.PurchaseAbility.OnServerEvent:Connect(function(player: Player, abilityName: string)
	local name, equipped = purchaseAbility(player, abilityName)
	if name then
		Packets.UpdateAbility:FireClient(player, name, equipped)
	end
end)

Packets.EquipAbility.OnServerEvent:Connect(function(player: Player, abilityName: string)
	local name, equipped = equipAbility(player, abilityName)
	if name then
		Packets.UpdateAbility:FireClient(player, name, equipped)
	end
end)
