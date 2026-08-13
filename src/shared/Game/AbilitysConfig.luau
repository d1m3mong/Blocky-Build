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
}

return {
	["Freeze"] = {
		Duration = 3,
		Cost = 100,
		Description = "",
	},
	["50/50"] = {
		Duration = 0.1,
		Cost = 500,
		Description = "",
	},
	["Squid Ink"] = {
		Duration = 5,
		Cost = 50,
		Description = "",
	},
	["Gravity"] = {
		Duration = 10,
		Cost = 15,
		Description = "",
	},
} :: AbilitiesType
