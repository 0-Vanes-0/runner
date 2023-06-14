extends Node

signal loaded
signal error(message: String)

@export_group("Game Screens")
@export var game_scene: PackedScene
@export var tilemap_scene: PackedScene

@export_group("Game Objects")
@export var platform_scene: PackedScene
@export var segment_scene: PackedScene

@export_group("Enemies", "enemy_")
@export var enemy_test_dragon: PackedScene

var segments: Array[Segment]
var default_segment: Segment

var counter := 0


func start_preload():
	var export_resources: Dictionary = {
		"game_scene": game_scene,
		"tilemap_scene": tilemap_scene,
		
		"platform_scene": platform_scene,
		"segment_scene": segment_scene,
		
		"enemy_test_dragon": enemy_test_dragon,
	}
	var runtime_resources: Dictionary = {
		"segments": segments,
	}
	for resource in export_resources.keys():
		if export_resources.get(resource) != null:
			counter += 1
		else:
			error.emit("Failed to load: " + resource)
	
	var tilemap := tilemap_scene.instantiate() as TileMap
	var non_empty := Vector2i(1, 0)
	for i in tilemap.get_layers_count():
		var segment_data: Array[Vector2i] = tilemap.get_used_cells_by_id(i, 0, non_empty)
		var segment := segment_scene.instantiate() as Segment
		var width := Platform.SIZE.x
		
		for v in segment_data:
			var floor_number: int = 4 - v.y
			var platfrom := Preloader.platform_scene.instantiate() as Platform
			platfrom.position.x = v.x * width
			platfrom.floor_number = floor_number
			segment.get_floor(floor_number).add_child(platfrom, true)
			segment.set_end_x(maxf(segment.get_width(), (v.x + 1) * width))
		
		if default_segment == null and tilemap.get_layer_name(i) == "DEFAULT":
			default_segment = segment
		else:
			segments.append(segment)
		
	counter += 1
	
	if counter == (export_resources.size() + runtime_resources.size()):
		loaded.emit()
