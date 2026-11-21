local themes = {}
themes.__index = themes

themes.themes = {
	{
		Name = "Giant Toilet",
		Difficulty = 1,
		Category = "Funny",
		Description = "Build the most majestic toilet in the world.",
	},
	{
		Name = "Funny Face",
		Difficulty = 1,
		Category = "Funny",
		Description = "Build a face with the silliest expression you can think of.",
	},
	{
		Name = "Messy Room",
		Difficulty = 2,
		Category = "Funny",
		Description = "Build a bedroom so messy that nobody dares to enter.",
	},
	{
		Name = "Chicken With Legs Too Long",
		Difficulty = 2,
		Category = "Funny",
		Description = "Build a chicken with absurdly long legs.",
	},
	{
		Name = "Banana Phone",
		Difficulty = 1,
		Category = "Funny",
		Description = "Build a banana that is secretly a phone.",
	},
	{
		Name = "Potato King",
		Difficulty = 2,
		Category = "Funny",
		Description = "Build a potato wearing a crown and ruling over its kingdom.",
	},
	{
		Name = "Sleeping Giant Cat",
		Difficulty = 2,
		Category = "Funny",
		Description = "Build a huge cat taking a nap in the weirdest position.",
	},
	{
		Name = "Cursed Sandwich",
		Difficulty = 1,
		Category = "Funny",
		Description = "Build a sandwich with ingredients nobody should combine.",
	},
	{
		Name = "Duck Army",
		Difficulty = 2,
		Category = "Funny",
		Description = "Build a tiny army of very serious ducks.",
	},
	{
		Name = "Evil Broccoli",
		Difficulty = 1,
		Category = "Funny",
		Description = "Build a broccoli with a evil plan.",
	},

	{
		Name = "Pizza",
		Difficulty = 1,
		Category = "Food",
		Description = "Build a pizza with the strangest toppings possible.",
	},
	{
		Name = "Burger",
		Difficulty = 1,
		Category = "Food",
		Description = "Build a burger with way too many layers.",
	},
	{
		Name = "Ice Cream Tower",
		Difficulty = 1,
		Category = "Food",
		Description = "Build an ice cream cone with as many scoops as you can.",
	},
	{
		Name = "Birthday Cake",
		Difficulty = 2,
		Category = "Food",
		Description = "Build a cake that looks too good to eat.",
	},
	{
		Name = "Hot Dog Dog",
		Difficulty = 1,
		Category = "Food",
		Description = "Build a dog that is also a hot dog.",
	},
	{
		Name = "Donut House",
		Difficulty = 2,
		Category = "Food",
		Description = "Build a tiny house made out of donuts.",
	},

	{
		Name = "Dragon",
		Difficulty = 3,
		Category = "Fantasy",
		Description = "Build a dragon. Friendly, grumpy or sleepy, you decide.",
	},
	{
		Name = "Fairy House",
		Difficulty = 2,
		Category = "Fantasy",
		Description = "Build a tiny home where a fairy could live.",
	},
	{
		Name = "Wizard Hat",
		Difficulty = 1,
		Category = "Fantasy",
		Description = "Build the pointiest wizard hat ever made.",
	},
	{
		Name = "Friendly Monster",
		Difficulty = 2,
		Category = "Fantasy",
		Description = "Build a monster that is much cuter than scary.",
	},
	{
		Name = "Unicorn",
		Difficulty = 2,
		Category = "Fantasy",
		Description = "Build a unicorn with the most magical horn.",
	},
	{
		Name = "Ghost Party",
		Difficulty = 2,
		Category = "Fantasy",
		Description = "Build ghosts having a party at midnight.",
	},

	{
		Name = "Robot",
		Difficulty = 2,
		Category = "Sci-Fi",
		Description = "Build a robot that is slightly broken.",
	},
	{
		Name = "Alien",
		Difficulty = 2,
		Category = "Sci-Fi",
		Description = "Build an alien visiting Earth for the first time.",
	},
	{
		Name = "Rocket",
		Difficulty = 2,
		Category = "Sci-Fi",
		Description = "Build a rocket ready for an epic launch.",
	},
	{
		Name = "UFO",
		Difficulty = 1,
		Category = "Sci-Fi",
		Description = "Build a flying saucer abducting something silly.",
	},
	{
		Name = "Moon Cheese",
		Difficulty = 1,
		Category = "Sci-Fi",
		Description = "Build a moon that is actually made of cheese.",
	},

	{
		Name = "Snowman",
		Difficulty = 1,
		Category = "Seasonal",
		Description = "Build the most creative snowman you can imagine.",
	},
	{
		Name = "Christmas Tree",
		Difficulty = 2,
		Category = "Seasonal",
		Description = "Build a Christmas tree with unusual decorations.",
	},
	{
		Name = "Pumpkin Face",
		Difficulty = 1,
		Category = "Seasonal",
		Description = "Build a pumpkin with a spooky or silly face.",
	},
	{
		Name = "Present Pile",
		Difficulty = 1,
		Category = "Seasonal",
		Description = "Build a huge pile of presents. What is inside?",
	},

	{
		Name = "Treehouse",
		Difficulty = 2,
		Category = "Nature",
		Description = "Build a cozy house up in a tree.",
	},
	{
		Name = "Volcano",
		Difficulty = 2,
		Category = "Nature",
		Description = "Build a volcano that is just about to erupt.",
	},
	{
		Name = "Flower",
		Difficulty = 1,
		Category = "Nature",
		Description = "Build the biggest and most colorful flower.",
	},
	{
		Name = "Sad Cloud",
		Difficulty = 1,
		Category = "Nature",
		Description = "Build a cloud that is having a really bad day.",
	},
	{
		Name = "Tiny Island",
		Difficulty = 2,
		Category = "Nature",
		Description = "Build a tiny island with one palm tree and one big secret.",
	},

	{
		Name = "Pirate Ship",
		Difficulty = 3,
		Category = "Adventure",
		Description = "Build a pirate ship with a very silly crew.",
	},
	{
		Name = "Treasure Chest",
		Difficulty = 1,
		Category = "Adventure",
		Description = "Build a treasure chest. Is it a trap?",
	},
	{
		Name = "Sandcastle",
		Difficulty = 2,
		Category = "Adventure",
		Description = "Build a sandcastle before the tide comes in.",
	},
	{
		Name = "Mini Castle",
		Difficulty = 3,
		Category = "Adventure",
		Description = "Build a small castle with one very strange room.",
	},

	{
		Name = "Race Car",
		Difficulty = 2,
		Category = "Vehicles",
		Description = "Build the fastest-looking car you can imagine.",
	},
	{
		Name = "Flying Bathtub",
		Difficulty = 2,
		Category = "Vehicles",
		Description = "Build a bathtub that can fly.",
	},
	{
		Name = "Submarine",
		Difficulty = 2,
		Category = "Vehicles",
		Description = "Build a submarine for exploring the deep sea.",
	},
	{
		Name = "Chair On Wheels",
		Difficulty = 1,
		Category = "Vehicles",
		Description = "Build the most ridiculous vehicle made from a chair.",
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
			return map
		end
	end

	return nil
end

return themes
