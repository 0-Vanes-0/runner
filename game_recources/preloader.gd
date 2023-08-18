extends Node

signal loaded

@export var reward_resource: RewardResource

@export_group("Game Screens")
@export var main_menu_scene: PackedScene
@export var game_scene: PackedScene
@export var segment_tilemap_scene: PackedScene

@export_group("Game Objects")
@export var player: PackedScene
@export var platform_scene: PackedScene
@export var segment_scene: PackedScene
@export var chest: PackedScene

@export_group("UIs")
@export var choose_demon_button: PackedScene
@export var main_menu_button_group: ButtonGroup

@export_group("Enemies", "enemy_")
@export var enemy_sphere_mage: PackedScene

@export_group("Skin Resources")
@export var biker_skin: SkinResource
@export var cyborg_skin: SkinResource
@export var white_skin: SkinResource

@export_group("Weapon Resources")
@export var autorifle_wr: WeaponResource
@export var crossbow_wr: WeaponResource
@export var revolver_wr: WeaponResource
@export var fire_ring_wr: WeaponResource
@export var test_laser: WeaponResource

var base_weapon_resources: Array[WeaponResource]
var skin_resources: Array[SkinResource]
var segments: Dictionary # { int: Array[Segment] }
var default_segment: Segment



func start_preload():
	var export_counter := 0
	var segments_counter := 0
	
	var all_res: Array[Dictionary] = []
	var all_res_size := 0
	all_res.append({
		"main_menu_scene": main_menu_scene,
		"game_scene": game_scene,
		"segment_tilemap_scene": segment_tilemap_scene,
		
		"player": player,
		"platform_scene": platform_scene,
		"segment_scene": segment_scene,
		"chest": chest,
		
		"choose_demon_button": choose_demon_button,
		"main_menu_button_group": main_menu_button_group,
		
		"enemy_sphere_mage": enemy_sphere_mage,
	})
	all_res.append({
		"fire_ring_wr": fire_ring_wr,
		"crossbow_wr": crossbow_wr,
		"revolver_wr": revolver_wr,
		"autorifle_wr": autorifle_wr,
		"test_laser": test_laser,
	})
	base_weapon_resources.append_array(all_res[1].values())
	all_res.append({
		"biker_skin": biker_skin,
		"white_skin": white_skin,
		"cyborg_skin": cyborg_skin,
	})
	skin_resources.append_array(all_res[2].values())
	
	for dict in all_res:
		all_res_size += dict.size()
		for resource in dict.keys():
			if dict.get(resource) != null:
				export_counter += 1
			else:
				assert(false, "Failed to load: " + resource)
	
	var non_empty := Vector2i(1, 0)
	var segment_tilemap := segment_tilemap_scene.instantiate() as SegmentTileMap
	for n in segment_tilemap.get_biomes_tilemaps().size():
		var biome_tilemap := segment_tilemap.get_biomes_tilemaps()[n]
		var segment_array: Array[Segment] = []
		for i in biome_tilemap.get_layers_count():
			var segment_data: Array[Vector2i] = biome_tilemap.get_used_cells_by_id(i, 0, non_empty)
			var segment := segment_scene.instantiate() as Segment
			var width := Platform.SIZE.x
			
			for v in segment_data:
				var floor_number: int = 4 - v.y
				var platfrom := platform_scene.instantiate() as Platform
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
			all_res_size
			+ segment_tilemap.get_biomes_tilemaps().size()
	)
	if load_result == load_goal:
		loaded.emit()
	else:
		print_debug(
				"Signal 'loaded' condition failed:", "\n",
				"\t", "export_resources: ", export_counter, "/", all_res_size, "\n",
				"\t", "segments: ", segments_counter, "/", segment_tilemap.get_biomes_tilemaps().size(), "\n",
		)


func get_segments(biome_number: int) -> Array[Segment]:
	return segments[biome_number] as Array[Segment]
