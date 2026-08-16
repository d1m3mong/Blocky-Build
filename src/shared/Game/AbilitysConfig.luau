export type AbilitiesType = {
	[string]: {
		Duration: number,
		Cost: number,
		Description: string,
	},
}

export type AbilityType = {
	Duration: number,
	Cost: number,
	Description: string,
	Cooldown: number,
}

return {
	["Freeze"] = {
		Duration = 3,
		Cost = 100,
		Description = "",
		Cooldown = 120,
	},
	["50/50"] = {
		Duration = 0.1,
		Cost = 500,
		Description = "",
		Cooldown = 180,
	},
	["Squid Ink"] = {
		Duration = 5,
		Cost = 50,
		Description = "",
		Cooldown = 90,
	},
	["Gravity"] = {
		Duration = 10,
		Cost = 15,
		Description = "",
		Cooldown = 80,
	},
	["Color Mix"] = {
		Duration = 0.1,
		Cost = 250,
		Description = "",
		Cooldown = 125,
	},
} :: AbilitiesType
