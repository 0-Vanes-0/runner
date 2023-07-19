class_name PreloaderSingleton
extends Node

signal loaded

@export_group("Game Screens")
@export var main_menu_scene: PackedScene
@export var game_scene: PackedScene
@export var tilemap_scene: PackedScene

@export_group("Game Objects")
@export var player: PackedScene
@export var platform_scene: PackedScene
@export var segment_scene: PackedScene

@export_group("Weapons")
@export var base_weapon_resources: Array[WeaponResource]

@export_group("Enemies", "enemy_")
@export var enemy_test_dragon: PackedScene

var segments: Dictionary # int: Array[Segment]
var default_segment: Segment

var export_counter := 0
var segments_counter := 0


func start_preload():
	var export_resources: Dictionary = {
		"main_menu_scene": main_menu_scene,
		"game_scene": game_scene,
		"tilemap_scene": tilemap_scene,
		
		"player": player,
		"platform_scene": platform_scene,
		"segment_scene": segment_scene,
		
		"enemy_test_dragon": enemy_test_dragon,
	}
	
	for resource in (export_resources.keys() as Array[String]):
		if export_resources.get(resource) != null:
			export_counter += 1
		else:
			print_debug("Failed to load: " + resource)
	
	for wr in base_weapon_resources:
		if wr != null:
			export_counter += 1
	
	var non_empty := Vector2i(1, 0)
	var segment_tilemap := tilemap_scene.instantiate() as SegmentTileMap
	for n in segment_tilemap.get_biomes_tilemaps().size():
		var biome_tilemap := segment_tilemap.get_biomes_tilemaps()[n]
		var segment_array: Array[Segment] = []
		for i in biome_tilemap.get_layers_count():
			var segment_data: Array[Vector2i] = biome_tilemap.get_used_cells_by_id(i, 0, non_empty)
			var segment := segment_scene.instantiate() as Segment
			var width := Platform.SIZE.x
			
			for v in segment_data:
				var floor_number: int = 4 - v.y
				var platfrom := Preloader.platform_scene.instantiate() as Platform
				platfrom.position.x = v.x * width
				platfrom.order_number = v.x
				platfrom.floor_number = floor_number
				segment.get_floor(floor_number).add_child(platfrom, true)
				segment.set_end_x(maxf(segment.get_width(), (v.x + 1) * width))
			
			if biome_tilemap.get_layer_name(i) == "DEFAULT":
				if default_segment == null:
					default_segment = segment
			else:
				segment_array.append(segment)
			
		segments[n+1] = segment_array
		segments_counter += 1
	
	
	
	var load_result: int = (
			export_counter
			+ segments_counter
	)
	var load_goal: int = (
			export_resources.size()
			+ base_weapon_resources.size()
			+ segment_tilemap.get_biomes_tilemaps().size()
	)
	if load_result == load_goal:
		loaded.emit()
	else:
		print_debug(
				"Signal 'loaded' condition failed:", "\n",
				"\t", "export_resources: ", export_counter, "/", export_resources.size(), "\n",
				"\t", "segments: ", segments_counter, "/", segment_tilemap.get_biomes_tilemaps().size(), "\n",
		)


func get_segments_by_biome(biome_number: int) -> Array[Segment]:
	return segments[biome_number] as Array[Segment]
