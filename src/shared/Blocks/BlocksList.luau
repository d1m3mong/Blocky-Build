local BlocksFolder = script.Parent.Blocks

type blockData = { Model: Part? }
type dict = { [string]: blockData }

local function assignModel(Blocklist: dict)
	for index, value in Blocklist do
		local model = BlocksFolder:FindFirstChild(index)
		if not model then
			warn("[BlocksList]: No Model found for" .. index)
			continue
		end

		value.Model = model
	end
end

local Blocks = {}

Blocks.BlockList = {
	["White Wool"] = {
		Image = "rbxassetid://106505410969469",
		Color = Color3.fromRGB(255, 255, 255),
	},
	["Black Wool"] = {
		Image = "rbxassetid://123620496520656",
		Color = Color3.fromRGB(0, 0, 0),
	},
	["Gray Wool"] = {
		Image = "rbxassetid://108146257015770",
		Color = Color3.fromRGB(125, 125, 125),
	},
}

assignModel(Blocks.BlockList)

return Blocks
