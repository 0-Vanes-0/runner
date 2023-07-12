## This is main scene. It handles [member current_scene], only one can exist.
class_name SceneHandler
extends Node

var current_scene: Node ## Current scene on screen. Can be changed by [method switch_to_scene].


func _ready() -> void:
	current_scene = Preloader.main_menu_scene.instantiate()
	self.add_child(current_scene)

## Firstly removes current scene from tree and queues it for freeing, then instantiates a new [param scene].
func switch_to_scene(scene: PackedScene):
	get_tree().node_removed.connect(
			func(node: Node):
				node.queue_free()
	, CONNECT_ONE_SHOT)
	self.remove_child(current_scene)
	current_scene = scene.instantiate()
	self.add_child(current_scene)
