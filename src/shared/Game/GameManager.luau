local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.Packages.jecs)
local packet = require(ReplicatedStorage.Packages.packet)
local signal = require(ReplicatedStorage.Packages.signal)
local trove = require(ReplicatedStorage.Packages.trove)
local BlocksManager = require(ReplicatedStorage.Shared.Blocks.BlocksManager)
local Packets = require(ReplicatedStorage.Shared.Packets)
local Ecs = require(ReplicatedStorage.Shared.Ecs.World)

local world = Ecs.world
local isInGame = Ecs.isInGame
local placedBlocks = Ecs.placedBlocks
local playerRef = Ecs.playerRef
const spawnPart = Ecs.spawnPart

local gameManager = {}
gameManager.__index = gameManager

export type gameManager = typeof(gameManager.new()) & {
	gameState: string,
}

function gameManager.new(): typeof(setmetatable({}, gameManager))
	local self = {}
	setmetatable(self, gameManager)

	self.gameState = "intermission"
	self.signal = signal.new()

	return self
end

function gameManager.startGame(self: gameManager)
	print "Starting Game"

	if self.gameState ~= "intermission" then
		warn("MEOW")
		return
	end

	if #Players:GetPlayers() < 2 then
		--return
	end

	for _, player in Players:GetPlayers() do
		print(player.UserId, " game has been initialized!")

		BlocksManager:clearBlocks(player)

		local entity = world:entity()

		world:set(entity, isInGame, true)
		world:set(entity, placedBlocks, 0)

		world:set(entity, playerRef, player)
	end

	self:tpPlayersToGrid()

	self:startCountdown()
end

const offset = CFrame.new(0, 3, 0)

function gameManager.tpPlayersToGrid(self: gameManager, certainPlayer: Player?): ()
	if certainPlayer then
		local targetPart: BasePart? = nil

		for _entity, part, ownerValue in world:query(spawnPart, Ecs.owner) do
			if ownerValue == certainPlayer.UserId then
				targetPart = part
				break
			end
		end

		if not targetPart then
			warn("[GameManager]: No target Part for: ", certainPlayer.Name, " found")
			return
		end

		for _, player in Players:GetPlayers() do
			local chr: Model? = player.Character
			if not chr then
				continue
			end

			chr:PivotTo(targetPart.CFrame * offset)
		end

		return
	end

	for _, player in Players:GetPlayers() do
		local character = player.Character
		if not character then
			continue
		end

		for _entity, part, ownerValue in world:query(spawnPart, Ecs.owner) do
			if ownerValue == player.UserId then
				character:PivotTo(part.CFrame * offset)
				break
			end
		end
	end
end

const initalTime = 300

function gameManager:startCountdown()
	self.gameState = "started"
	local currentTime = initalTime

	task.spawn(function()
		while currentTime >= 0 do
			for _, player in Players:GetPlayers() do
				Packets.UpdateTimer:FireClient(player, currentTime)
			end

			currentTime -= 1
			task.wait(1)
		end

		self:rating()
	end)
end

function gameManager.rating(self: gameManager)
	if self.gameState ~= "started" then
		return
	end

	print "RATING"

	self.gameState = "rating"

	for _Entity, player: Player in world:query(playerRef) do
		self:tpPlayersToGrid(player)

		--TODO: Promp Rate
		task.wait(10)
	end

	self:result()
end

function gameManager.result(self: gameManager)
	if self.gameState ~= "rating" then
		return
	end

	print "RESULT"

	self.gameState = "result"

	task.wait(5)

	self:intermission()
end

const intermissionTime = 60

function gameManager.intermission(self: gameManager)
	print "INTERMISSION"

	local currentTime = intermissionTime

	self.gameState = "intermission"

	--TODO: Vote Theme

	while task.wait(1) do
		currentTime -= 1

		for _, player in Players:GetPlayers() do
			Packets.UpdateTimer:FireClient(player, currentTime)
		end

		if currentTime <= 0 then
			break
		end
	end

	print "MEOW"

	self:startGame()
end

function gameManager.getGameState(self: gameManager): string
	return self.gameState
end

function gameManager.inGame(self: gameManager, player: Player): boolean
	for _Enitity, plr in world:query(playerRef) do
		if plr == player then
			return true
		end
	end

	return false
end

return gameManager
