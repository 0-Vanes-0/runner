class_name Activity
extends Node2D

var rarity: Rarity
var activity_resource: ActivityResource
var reload_time: float
var reload_timer: float
var duration_time: float


func _init(activity_resource: ActivityResource, rarity: Rarity) -> void:
	self.rarity = rarity
	self.activity_resource = activity_resource
	self.reload_time = activity_resource.reload_time
	reload_timer = reload_time
	self.duration_time = activity_resource.duration_time


func _physics_process(delta: float) -> void:
	reload_timer = reload_timer + delta if reload_timer < reload_time else reload_time


func activate():
	if not is_reloading():
		reload_timer = 0.0
		activity_resource.action(rarity)
		await get_tree().create_timer(duration_time, false, true).timeout
		activity_resource.action_end(rarity)


func is_reloading() -> bool:
	return reload_timer < reload_time


func get_description() -> String:
	return activity_resource.get_description(rarity)


func get_preview() -> Texture2D:
	return activity_resource.get_preview()


func _get_player() -> Player:
	return get_parent() as Player
