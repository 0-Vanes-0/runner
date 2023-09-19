## This is main scene. It handles [member current_scene], only one can exist.
class_name SceneHandler
extends Node

signal scene_changed(current_scene: Node)

var current_scene: Node ## Current scene on screen. Can be changed by [method switch_to_scene].

@onready var load_control := $Control as Control


func _ready() -> void:
	if not Global.game_res_loaded:
		Preloader.loaded.connect(
				func():
					Global.game_res_loaded = true
					current_scene = Preloader.main_menu_scene.instantiate()
					self.add_child(current_scene)
					scene_changed.emit(current_scene)
					load_control.queue_free()
		, CONNECT_ONE_SHOT)
		Preloader.start_preload()

## Firstly removes current scene from tree and queues it for freeing, then instantiates a new [param scene].
func switch_to_scene(scene: PackedScene):
	get_tree().node_removed.connect(
			func(node: Node):
				node.queue_free()
	, CONNECT_ONE_SHOT)
	self.remove_child(current_scene)
	current_scene = scene.instantiate()
	self.add_child(current_scene)
	scene_changed.emit(current_scene)
