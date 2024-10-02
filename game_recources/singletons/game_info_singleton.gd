## This singleton stores all run data (seed) which is generated once.
## The new generation can be called only after dying of player.
extends Node

#var seed: String
## Current biome. (WIP: create Biome class?)
var biome_number: int = 1
## Current level.
var level_number: int = 1
var current_reward: Reward
## Amount of kills of Enemy by Player.
var kills_count: int = 0
## Amount of experience.
var experience: int = 0

## Flag for checking if seed generated.
var is_run_seed_generated: bool = false
## Structure: { int: { int: Array[int] } }
## The first int is biome number, the second int is level number,
## Array[int] is array with numbers of segments.
var _segments_in_levels: Dictionary = {}
## Structure: { int: { int: Array[Reward] } }
var rewards_in_levels: Dictionary = {}
## Max biomes in game. (WIP: create Biome class?)
const BIOMES_COUNT := 1 #5
## Max levels in each biome. (WIP: create Biome class?)
const LEVELS_COUNT := 9
## Length of each level in Platforms. Value of index 0 is length of init level.
## Numeration of levels goes from 1 to 9.
const _LEVEL_LENGTH: Array[int] = [20, 60, 90, 120, 150, 180, 210, 240, 270, 300]
## Structure: { int: int }
## The first int is biome number, the second int is amount of different segments from Preloader.
var BIOME_SEGMENT_TYPES_COUNT: Dictionary = {}

var demon_datas: Array[DemonData]


func setup_game_info():
	experience = 0
	kills_count = 0
	biome_number = 0
	level_number = 1
	current_reward = Reward.generate_reward(Reward.WEAPON)


func generate_game_info():
	for biome_i in Preloader.segments.keys() as Array[int]:
		BIOME_SEGMENT_TYPES_COUNT[biome_i] = (Preloader.segments.get(biome_i) as Array[Segment]).size()
	
	for biome_i in range(0, BIOMES_COUNT + 1):
		_segments_in_levels[biome_i] = {}
		rewards_in_levels[biome_i] = {}
		for level_i in range(1, LEVELS_COUNT + 1):
			var segment_order: Array[int] = []
			var level_length: int = 0
			while level_length < _LEVEL_LENGTH[level_i]:
				var segment_number: int = randi_range(0, BIOME_SEGMENT_TYPES_COUNT.get(biome_i) - 1)
				segment_order.append(segment_number)
				level_length += (Preloader.segments.get(biome_i) as Array[Segment])[segment_number].get_length()
			_segments_in_levels[biome_i][level_i] = segment_order
			
			var choice_array: Array[Reward] = []
			for i in randi_range(2, 3):
				var test_rewards: Array[int] = [ Reward.DEMON_PASSIVITY, Reward.WEAPON, Reward.ACTIVITY ] # WIP!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				choice_array.append(Reward.generate_reward(test_rewards.pick_random()))
			rewards_in_levels[biome_i][level_i] = choice_array
	
	for i in 20:
		var rarity := Rarity.generate_rarity()
		var skin_res: SkinResource = Preloader.skin_resources.pick_random()
		demon_datas.append(DemonData.new(rarity, skin_res))


func get_level_length(level_number: int) -> int:
	return _LEVEL_LENGTH[clampi(level_number, 1, 9)]


func get_level_segments_numbers(biome_i: int, level_i: int) -> Array[int]:
	return _segments_in_levels.get(biome_i).get(level_i)


func get_rewards_array(biome_i: int, level_i: int) -> Array[Reward]:
	return rewards_in_levels.get(biome_i).get(level_i)
