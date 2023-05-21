extends Node

signal loaded
signal error(message: String)

@export_group("Packed Scenes", "")
@export var platform: PackedScene
@export var game_scene: PackedScene

var counter := 0


func start_preload():
	var resources: Dictionary = {
		"platform": platform,
		"game_scene": game_scene,
	}
	for resource in resources.keys():
		if resources.get(resource) != null:
			counter += 1
		else:
			error.emit("Failed to load: " + resource)
	
	if counter == resources.size():
		loaded.emit()
