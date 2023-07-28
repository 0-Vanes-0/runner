## This singleton stores all run data (seed) which is generated once.
## The new generation can be called only after dying of player.
extends Node

enum Rarity {
	NORMAL,
	RARE,
	EPIC,
	LEGENDARY,
}
const NORMAL_CHANCE := 50
const RARE_CHANCE := 30
const EPIC_CHANCE := 15
const LEGENDARY_CHANCE := 5
#var seed: String
## Current biome. (WIP: create Biome class?)
@export_range(1, 5) var biome_number: int = 1
## Current level.
@export_range(1, 9) var level_number: int = 1
## Amount of kills of Enemy by Player.
var kills_count: int = 0

## Flag for checking if seed generated.
var is_run_seed_generated: bool = false
## Structure: { int: { int: Array[int] } }
## The first int is biome number, the second int is level number,
## Array[int] is array with numbers of segments.
var segments_in_levels: Dictionary = {}
## Max biomes in game. (WIP: create Biome class?)
const BIOMES_COUNT := 1 #5
## Max levels in each biome. (WIP: create Biome class?)
const LEVELS_COUNT := 9
## Length of each level in Platforms. Value of index 0 is length of init level.
## Numeration of levels goes from 1 to 9.
const LEVEL_LENGTH: Array[int] = [20, 60, 90, 120, 150, 180, 210, 240, 270, 300]
## Structure: { int: int }
## The first int is biome number, the second int is amount of different segments from Preloader.
var BIOME_SEGMENT_TYPES_COUNT: Dictionary = {}

var demon_datas: Array[DemonData]


func setup_game_info():
	kills_count = 0
	biome_number = 1
	level_number = 1


func generate_game_info():
	for biome_i in (Preloader.segments.keys() as Array[int]):
		BIOME_SEGMENT_TYPES_COUNT[biome_i] = (Preloader.segments.get(biome_i) as Array[Segment]).size()
	
	for biome_i in range(1, BIOMES_COUNT + 1):
		segments_in_levels[biome_i] = {}
		for level_i in range(1, LEVELS_COUNT + 1):
			var segment_order: Array[int] = []
			var level_length: int = 0
			while level_length < LEVEL_LENGTH[level_i]:
				var segment_number: int = randi_range(0, BIOME_SEGMENT_TYPES_COUNT.get(biome_i) - 1)
				segment_order.append(segment_number)
				level_length += (Preloader.segments.get(biome_i) as Array[Segment])[segment_number].get_length()
			segments_in_levels[biome_i][level_i] = segment_order
	
	for i in 6:
		var rarity: Rarity = generate_rarity()
		var color: Color = SkinResource.COLORS[rarity]
		var weapon_resource := Preloader.base_weapon_resources[rarity]
		
		var demon_data := DemonData.new(
				Preloader.skin_resources.pick_random()
				, color
				, weapon_resource
		)
		demon_datas.append(demon_data)


func generate_rarity() -> Rarity:
	var random_value: int = randi_range(1, NORMAL_CHANCE + RARE_CHANCE + EPIC_CHANCE + LEGENDARY_CHANCE)
	if random_value < NORMAL_CHANCE:
		return Rarity.NORMAL
	elif random_value < NORMAL_CHANCE + RARE_CHANCE:
		return Rarity.RARE
	elif random_value < NORMAL_CHANCE + RARE_CHANCE + EPIC_CHANCE:
		return Rarity.EPIC
	else:
		return Rarity.LEGENDARY


func get_level_length(level_number: int) -> int:
	return LEVEL_LENGTH[clampi(level_number, 1, 9)]


func get_level_segments_numbers(biome_i: int, level_i: int) -> Array[int]:
	return segments_in_levels.get(biome_i).get(level_i)
