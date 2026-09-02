local bannedPlayers = {}
bannedPlayers.__index = bannedPlayers

type banData = { [number]: {
	banTime: DateTime,
	reason: string,
	sentence: number,
} }

function bannedPlayers:add(player: Player, data: banData)
	if bannedPlayers[player.UserId] then
		return
	end

	bannedPlayers[player.UserId] = {
		banTime = data.banData,
		reason = data.reason,
		sentence = data.sentence,
	}
end

return {
	banned = bannedPlayers,
}
