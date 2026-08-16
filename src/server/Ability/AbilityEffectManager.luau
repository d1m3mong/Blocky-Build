local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local gameManagerSignals = require(ReplicatedStorage.Shared.Signals.gameManagerSignals)
type Revert = () -> ()

local activeEffects: { [Player]: { Revert } } = {}

local module = {}

function module:applyEffect(target: Player, duration: number, revert: Revert)
	activeEffects[target] = activeEffects[target] or {}
	local list = activeEffects[target]
	table.insert(list, revert)

	local function runOnce()
		local idx = table.find(list, revert)
		if not idx then
			return
		end
		table.remove(list, idx)
		revert()
	end

	task.delay(duration, runOnce)
end

function module:endAllEffects(target: Player)
	local list = activeEffects[target]
	if not list then
		return
	end

	for _, revert in list do
		revert()
	end
	table.clear(list)
end

return module
