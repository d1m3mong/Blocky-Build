local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VotingManager = require(script.Parent.VotingManager)
local WinnerTable = require(script.Parent.WinnerTable)
local jecs = require(ReplicatedStorage.Packages.jecs)
local packet = require(ReplicatedStorage.Packages.packet)
local sift = require(ReplicatedStorage.Packages.sift)
local signal = require(ReplicatedStorage.Packages.signal)
local trove = require(ReplicatedStorage.Packages.trove)
local BlocksManager = require(ReplicatedStorage.Shared.Blocks.BlocksManager)
local Packets = require(ReplicatedStorage.Shared.Packets)
local Ecs = require(ReplicatedStorage.Shared.Ecs.World)
local gameManagerSignals = require(ReplicatedStorage.Shared.Signals.gameManagerSignals)
local VotingSingleton = require(ReplicatedStorage.Shared.VotingSingleton)
local data = require(ReplicatedStorage.Shared.data).server

local world = Ecs.world
local isInGame = Ecs.isInGame
local placedBlocks = Ecs.placedBlocks
local playerRef = Ecs.playerRef
const spawnPart = Ecs.spawnPart

local gameManager = {}
gameManager.__index = gameManager

export type gameManager = typeof(gameManager.new()) & {
	gameState: string,
	signal: any,
	votes: {},
}

function gameManager.new(): typeof(setmetatable({}, gameManager))
	local self = {}
	setmetatable(self, gameManager)

	self.gameState = "intermission"
	self.signal = signal.new()
	self.votes = {}

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

	gameManagerSignals.gameStart:Fire()
	table.clear(self.votes)

	for _, player in Players:GetPlayers() do
		print(player.UserId, " game has been initialized!")

		Packets.UpdateGameState:FireClient(player, "started")
		BlocksManager:clearBlocks(player)

		local entity = world:entity()

		world:set(entity, isInGame, true)
		world:set(entity, placedBlocks, 0)

		world:set(entity, playerRef, player)
	end

	self:tpPlayersToGrid()

	self:startCountdown()
end

const offset = CFrame.new(0, 3, 25)

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

const initalTime = 6

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

	gameManagerSignals.ratingStart:Fire()

	for _, player in Players:GetPlayers() do
		Packets.UpdateGameState:FireClient(player, "rating")
	end

	local connection

	connection = Packets.RatePlayer.OnServerEvent:Connect(
		function(ownPlayer: Player, votedPlayer: Instance, stars: number)
			if self.gameState ~= "rating" then
				return
			end

			if not votedPlayer:IsA("Player") then
				return
			end

			if ownPlayer == votedPlayer then
				--return
			end

			if stars < 1 or stars > 5 then
				return
			end

			self.votes[votedPlayer.UserId] = self.votes[votedPlayer.UserId] or {}

			self.votes[votedPlayer.UserId][ownPlayer.UserId] = stars

			print(ownPlayer.Name, "rated", votedPlayer.Name, "with", stars)
		end
	)

	for _Entity, player in world:query(playerRef) do
		self:tpPlayersToGrid(player)

		for _, plr in Players:GetPlayers() do
			Packets.PrompPlayerRate:FireClient(plr, player)
		end

		task.wait(10)
	end

	connection:Disconnect()

	for _, plr in Players:GetPlayers() do
		Packets.PrompRate:FireClient(plr, false)
	end

	self:result()
end

type VoteEntry = {
	UserId: number,
	Votes: number,
}

local function sortPlayersByVotes(self: gameManager): { VoteEntry }
	local sorted: { VoteEntry } = {}

	for userId, votes in self.votes do
		local totalVotes = 0

		for target, vote in votes do
			totalVotes += vote
		end

		sorted = sift.List.push(sorted, {
			UserId = userId,
			Votes = totalVotes,
		})
	end

	table.sort(sorted, function(a, b)
		return a.Votes > b.Votes
	end)

	return sorted
end

local function nominate(sortedList: { { number } }): { VoteEntry }
	local nominated = {}

	for i = 1, #sortedList do
		nominated = sift.List.push(nominated, {
			UserId = sortedList[i].UserId,
			Votes = sortedList[i].Votes,
		})
	end

	return nominated
end

function gameManager.result(self: gameManager)
	if self.gameState ~= "rating" then
		return
	end

	print "RESULT"

	self.gameState = "result"

	local sortedList = sortPlayersByVotes(self)

	for _, playerData in sortedList do
		local success, playerInstance: Player? = pcall(Players.GetPlayerByUserId, Players, playerData.UserId)
		if not success then
			warn("[GameManager]: Pcall to optain the Player Instance Failed" .. success)
			continue
		end

		if playerInstance then
			data[playerInstance].Votes(function(Old: number)
				return Old + playerData.Votes
			end)
		end
	end

	local nominatedPlayers: { VoteEntry } = nominate(sortedList)

	print(nominatedPlayers)

	local winnersData = {}
	for i = 1, #nominatedPlayers do
		winnersData = sift.List.push(winnersData, {
			UserId = nominatedPlayers[i].UserId,
			Votes = nominatedPlayers[i].Votes,
		})
	end

	for _, player in Players:GetPlayers() do
		Packets.UpdateGameState:FireClient(player, "result")
		Packets.ShowWinners:FireClient(player, winnersData)

		task.delay(6, function()
			Packets.ReplicateNominations:FireClient(player, nominatedPlayers)
			Packets.ResultState:FireClient(player, true)
		end)
	end

	for i = 1, #nominatedPlayers do
		local userId = nominatedPlayers[i].UserId

		if not userId then
			warn("[GameManager]: Couldnt identify Player data NominatedList!")
			continue
		end

		local success, playerInstance: Player? = pcall(Players.GetPlayerByUserId, Players, userId)
		if not success then
			warn("[GameManager]: Pcall to optain the Player Instance Failed" .. success)
			continue
		end

		if playerInstance then
			data[playerInstance].currency.Coins(function(Old: number)
				return Old + WinnerTable[i].Reward.Coins
			end)

			data[playerInstance].currency.Wins(function(Old: number)
				return Old + WinnerTable[i].Reward.Wins
			end)
		end

		print(playerInstance)
	end

	task.wait(15)

	for _, player in Players:GetPlayers() do
		Packets.ResultState:FireClient(player, false)
	end

	self:intermission(VotingSingleton)
end

const intermissionTime = 10

function gameManager.intermission(self: gameManager, votingManager: VotingManager.VotingManager)
	print "INTERMISSION"

	local currentTime = intermissionTime

	self.gameState = "intermission"

	--TODO: Vote Theme
	local winning = votingManager:startVote()
	for _, plr: Player in Players:GetPlayers() do
		Packets.UpdateGameState:FireClient(plr, "intermission")
		Packets.GetWinningMapData:FireClient(plr, winning)
	end

	while task.wait(1) do
		currentTime -= 1

		for _, player in Players:GetPlayers() do
			Packets.UpdateTimer:FireClient(player, currentTime)
		end

		if currentTime <= 0 then
			break
		end
	end

	print(winning)

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
