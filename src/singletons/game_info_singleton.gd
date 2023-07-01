extends Node

@export_range(1, 5) var biome_number: int = 1
@export_range(1, 9) var level_number: int = 1
var kills_count: int = 0

var is_run_seed_generated: bool = false
var segments_in_levels: Dictionary = {} # int: int: Array[int]
const BIOMES_COUNT := 1 #5
const LEVELS_COUNT := 9
const LEVEL_LENGTH: Array[int] = [20, 60, 90, 120, 150, 180, 210, 240, 270, 300]
var BIOME_SEGMENT_TYPES_COUNT: Dictionary = {} # int: int


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


func get_level_length(level_number: int) -> int:
	return LEVEL_LENGTH[clampi(level_number, 1, 9)]


func get_level_segments_numbers(biome_i: int, level_i: int) -> Array[int]:
	return segments_in_levels.get(biome_i).get(level_i)
