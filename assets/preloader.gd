extends Node

signal loaded
signal error(message: String)

@export_dir var sprites_dir: String

@export_group("Packed Scenes", "")
@export var platform: PackedScene
@export var game_scene: PackedScene

@export_group("Textures", "")
@export var fire_orb_texture: Texture2D

var counter := 0



func start_preload():
	var resources: Dictionary = {
		"sprites_dir": sprites_dir,
		"platform": platform,
		"game_scene": game_scene,
		"fire_orb_texture": fire_orb_texture,
	}
	for name in resources.keys():
		if resources.get(name) != null:
			counter += 1
		else:
			error.emit("Failed to load: " + name)
	
	if counter == resources.size():
		loaded.emit()
