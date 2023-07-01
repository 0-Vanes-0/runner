class_name SceneHandler
extends Node

var current_scene: Node


func _ready() -> void:
	current_scene = Preloader.main_menu_scene.instantiate()
	self.add_child(current_scene)


func switch_to_scene(scene: PackedScene):
	get_tree().node_removed.connect(
			func(node: Node):
				node.queue_free()
	, CONNECT_ONE_SHOT)
	self.remove_child(current_scene)
	current_scene = scene.instantiate()
	self.add_child(current_scene)
