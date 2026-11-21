local BlocksFolder = script.Parent.Blocks

type blockData = { Model: Part? }
type dict = { [string]: blockData }

local function assignModel(Blocklist: dict)
	for index, value in Blocklist do
		local model = BlocksFolder:FindFirstChild(index)
		if not model then
			model = Instance.new("Part")
			model.Name = index
			model.Size = Vector3.new(5, 5, 5)

			model.Parent = script.Parent.Blocks
		end

		value.Model = model
	end
end

local Blocks = {}

Blocks.BlockOrder = {
	"Gray Wool",
	"Black Wool",
	"White Wool",
	"Green Wool",
	"Yellow Wool",
	"Red Wool",
	"Blue Wool",
}

Blocks.CustomName = "Custom Wool"
Blocks.CustomSlot = 9

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
	["Green Wool"] = {
		Image = "rbxassetid://101770830912229",
		Color = Color3.fromRGB(4, 255, 0),
	},
	["Yellow Wool"] = {
		Image = "rbxassetid://96177044508474",
		Color = Color3.fromRGB(255, 240, 74),
	},
	["Red Wool"] = {
		Image = "rbxassetid://136728219008279",
		Color = Color3.fromRGB(255, 0, 4),
	},
	["Blue Wool"] = {
		Image = "rbxassetid://138619958185056",
		Color = Color3.fromRGB(0, 115, 255),
	},
	["Rainbow Wool"] = {
		Image = "rbxassetid://120991031326232",
		Color = Color3.fromRGB(255, 255, 255),
	},
	["Custom Wool"] = {
		Image = "rbxassetid://128142292445534",
		Color = Color3.fromRGB(255, 255, 255),
	},
}

assignModel(Blocks.BlockList)

return Blocks
