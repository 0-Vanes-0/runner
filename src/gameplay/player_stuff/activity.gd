class_name Activity
extends Node2D

var activity_resource: ActivityResource
var reload_time: float
var reload_timer: float
var duration_time: float


func _init(activity_resource: ActivityResource) -> void:
	self.activity_resource = activity_resource
	self.reload_time = activity_resource.reload_time
	reload_timer = reload_time
	self.duration_time = activity_resource.duration_time


func _physics_process(delta: float) -> void:
	reload_timer = reload_timer + delta if reload_timer < reload_time else reload_time


func activate():
	if not is_reloading():
		reload_timer = 0.0
		activity_resource.action()
		await get_tree().create_timer(duration_time)
		activity_resource.action_end()


func is_reloading() -> bool:
	return reload_timer < reload_time


func _get_player() -> Player:
	return get_parent() as Player
