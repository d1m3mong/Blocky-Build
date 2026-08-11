local themes = {}
themes.__index = themes

themes.themes = {
	-- Nature
	{
		Name = "Volcano",
		Difficulty = 3,
		Category = "Nature",
		Description = "Build a massive volcano with lava flowing down its sides.",
	},

	{
		Name = "Waterfall",
		Difficulty = 2,
		Category = "Nature",
		Description = "Create a beautiful waterfall surrounded by nature.",
	},

	{
		Name = "Treehouse",
		Difficulty = 2,
		Category = "Nature",
		Description = "Build a cozy house high up in the trees.",
	},

	{
		Name = "Flower Garden",
		Difficulty = 1,
		Category = "Nature",
		Description = "Create a colorful garden filled with beautiful flowers.",
	},

	{
		Name = "Jungle",
		Difficulty = 3,
		Category = "Nature",
		Description = "Build a dense jungle filled with trees, plants, and wildlife.",
	},

	{
		Name = "Desert Oasis",
		Difficulty = 3,
		Category = "Nature",
		Description = "Create a peaceful oasis hidden in a vast desert.",
	},

	{
		Name = "Mountain",
		Difficulty = 4,
		Category = "Nature",
		Description = "Build a tall and impressive mountain landscape.",
	},

	{
		Name = "Camping",
		Difficulty = 2,
		Category = "Nature",
		Description = "Create a cozy campsite surrounded by nature.",
	},

	-- Buildings
	{
		Name = "Castle",
		Difficulty = 4,
		Category = "Buildings",
		Description = "Build a mighty castle with towers, walls, and a grand entrance.",
	},

	{
		Name = "Modern House",
		Difficulty = 3,
		Category = "Buildings",
		Description = "Build a stylish modern house with large windows and unique architecture.",
	},

	{
		Name = "Farm",
		Difficulty = 2,
		Category = "Buildings",
		Description = "Create a working farm with a farmhouse, crops, and animals.",
	},

	{
		Name = "Skyscraper",
		Difficulty = 4,
		Category = "Buildings",
		Description = "Build a huge skyscraper that towers above the city.",
	},

	{
		Name = "School",
		Difficulty = 3,
		Category = "Buildings",
		Description = "Create a school with classrooms, hallways, and a playground.",
	},

	{
		Name = "Library",
		Difficulty = 3,
		Category = "Buildings",
		Description = "Build a large library filled with books and cozy reading areas.",
	},

	{
		Name = "Lighthouse",
		Difficulty = 3,
		Category = "Buildings",
		Description = "Build a lighthouse standing proudly beside the ocean.",
	},

	{
		Name = "Windmill",
		Difficulty = 2,
		Category = "Buildings",
		Description = "Create a classic windmill surrounded by fields.",
	},

	{
		Name = "Wizard Tower",
		Difficulty = 4,
		Category = "Buildings",
		Description = "Build a mysterious tower where a powerful wizard might live.",
	},

	-- Fantasy
	{
		Name = "Dragon",
		Difficulty = 5,
		Category = "Fantasy",
		Description = "Build a legendary dragon with impressive wings and details.",
	},

	{
		Name = "Magic Kingdom",
		Difficulty = 5,
		Category = "Fantasy",
		Description = "Create a magical kingdom filled with castles, towers, and fantasy buildings.",
	},

	{
		Name = "Fairy House",
		Difficulty = 2,
		Category = "Fantasy",
		Description = "Build a tiny magical home where a fairy could live.",
	},

	{
		Name = "Haunted Mansion",
		Difficulty = 4,
		Category = "Fantasy",
		Description = "Create a creepy mansion filled with spooky details.",
	},

	{
		Name = "Ancient Temple",
		Difficulty = 4,
		Category = "Fantasy",
		Description = "Build an ancient temple hidden deep in the wilderness.",
	},

	{
		Name = "Monster",
		Difficulty = 3,
		Category = "Fantasy",
		Description = "Create a terrifying monster with a unique design.",
	},

	-- Adventure
	{
		Name = "Pirate Ship",
		Difficulty = 4,
		Category = "Adventure",
		Description = "Build a legendary pirate ship ready to sail the seas.",
	},

	{
		Name = "Pirate Island",
		Difficulty = 4,
		Category = "Adventure",
		Description = "Create a pirate island with treasure, palm trees, and a hidden base.",
	},

	{
		Name = "Treasure Cave",
		Difficulty = 3,
		Category = "Adventure",
		Description = "Build a mysterious cave filled with hidden treasure.",
	},

	{
		Name = "Ancient Ruins",
		Difficulty = 4,
		Category = "Adventure",
		Description = "Create the remains of an ancient civilization.",
	},

	{
		Name = "Secret Base",
		Difficulty = 4,
		Category = "Adventure",
		Description = "Build a hidden secret base with traps and secret entrances.",
	},

	-- Vehicles
	{
		Name = "Race Car",
		Difficulty = 3,
		Category = "Vehicles",
		Description = "Build a fast racing car ready to compete on the track.",
	},

	{
		Name = "Spaceship",
		Difficulty = 4,
		Category = "Vehicles",
		Description = "Create a futuristic spaceship ready to explore the universe.",
	},

	{
		Name = "Airplane",
		Difficulty = 3,
		Category = "Vehicles",
		Description = "Build an airplane with detailed wings, engines, and cockpit.",
	},

	{
		Name = "Train",
		Difficulty = 3,
		Category = "Vehicles",
		Description = "Build a detailed train with multiple carriages.",
	},

	{
		Name = "Submarine",
		Difficulty = 4,
		Category = "Vehicles",
		Description = "Create a submarine designed to explore the deep ocean.",
	},

	{
		Name = "Rocket",
		Difficulty = 3,
		Category = "Vehicles",
		Description = "Build a rocket ready for an epic launch into space.",
	},

	-- Places
	{
		Name = "Amusement Park",
		Difficulty = 5,
		Category = "Places",
		Description = "Create an exciting amusement park with rides and attractions.",
	},

	{
		Name = "Zoo",
		Difficulty = 4,
		Category = "Places",
		Description = "Build a zoo with animal enclosures, paths, and visitor areas.",
	},

	{
		Name = "City",
		Difficulty = 5,
		Category = "Places",
		Description = "Create a busy city filled with buildings, roads, and landmarks.",
	},

	{
		Name = "Beach",
		Difficulty = 2,
		Category = "Places",
		Description = "Build a relaxing beach with sand, water, and fun activities.",
	},

	{
		Name = "Space Station",
		Difficulty = 5,
		Category = "Places",
		Description = "Create a futuristic space station orbiting far above Earth.",
	},

	{
		Name = "Winter Village",
		Difficulty = 3,
		Category = "Places",
		Description = "Build a cozy village covered in snow and surrounded by mountains.",
	},

	-- Food
	{
		Name = "Pizza",
		Difficulty = 1,
		Category = "Food",
		Description = "Build a giant delicious pizza with your favorite toppings.",
	},

	{
		Name = "Burger",
		Difficulty = 1,
		Category = "Food",
		Description = "Create a massive burger with layers of delicious ingredients.",
	},

	{
		Name = "Cake",
		Difficulty = 2,
		Category = "Food",
		Description = "Build a giant decorated cake for a special celebration.",
	},

	{
		Name = "Ice Cream Shop",
		Difficulty = 2,
		Category = "Food",
		Description = "Create a colorful ice cream shop with lots of different flavors.",
	},

	{
		Name = "Bakery",
		Difficulty = 3,
		Category = "Food",
		Description = "Build a cozy bakery filled with bread, cakes, and pastries.",
	},

	-- Seasonal
	{
		Name = "Christmas",
		Difficulty = 3,
		Category = "Seasonal",
		Description = "Create a magical Christmas scene filled with decorations and presents.",
	},

	{
		Name = "Halloween",
		Difficulty = 3,
		Category = "Seasonal",
		Description = "Build a spooky Halloween scene filled with pumpkins and decorations.",
	},

	{
		Name = "Snowman",
		Difficulty = 1,
		Category = "Seasonal",
		Description = "Build a funny or creative snowman with unique decorations.",
	},

	{
		Name = "Santa's Workshop",
		Difficulty = 4,
		Category = "Seasonal",
		Description = "Create Santa's magical workshop where presents are made.",
	},

	{
		Name = "Pumpkin Patch",
		Difficulty = 2,
		Category = "Seasonal",
		Description = "Build a pumpkin patch ready for the Halloween season.",
	},

	-- Sci-Fi
	{
		Name = "Robot",
		Difficulty = 3,
		Category = "Sci-Fi",
		Description = "Build a futuristic robot with mechanical details.",
	},

	{
		Name = "Alien",
		Difficulty = 3,
		Category = "Sci-Fi",
		Description = "Create a strange alien creature from another planet.",
	},

	{
		Name = "Alien Invasion",
		Difficulty = 5,
		Category = "Sci-Fi",
		Description = "Build a scene showing aliens invading a futuristic city.",
	},

	{
		Name = "Secret Laboratory",
		Difficulty = 4,
		Category = "Sci-Fi",
		Description = "Create a mysterious laboratory filled with futuristic technology.",
	},

	{
		Name = "Moon Base",
		Difficulty = 4,
		Category = "Sci-Fi",
		Description = "Build a futuristic base on the surface of the Moon.",
	},

	-- Funny
	{
		Name = "Giant Toilet",
		Difficulty = 2,
		Category = "Funny",
		Description = "Build the biggest and funniest toilet imaginable.",
	},

	{
		Name = "Messy Room",
		Difficulty = 2,
		Category = "Funny",
		Description = "Create an extremely messy bedroom filled with random objects.",
	},

	{
		Name = "Funny Face",
		Difficulty = 2,
		Category = "Funny",
		Description = "Build a giant funny face with a ridiculous expression.",
	},

	{
		Name = "Giant Chicken",
		Difficulty = 3,
		Category = "Funny",
		Description = "Create a gigantic chicken that towers over everything around it.",
	},

	{
		Name = "Boss Battle",
		Difficulty = 5,
		Category = "Funny",
		Description = "Build an epic scene showing a hero fighting a powerful boss.",
	},
}

export type Map = {
	Name: string,
	Difficulty: number,
	Category: string,
	Description: string,
}

function themes.getMapData(mapName: string): Map?
	for _, map in pairs(themes.themes) do
		if map.Name == mapName then
			print(map)
			return map
		end
	end

	return nil
end

return themes
