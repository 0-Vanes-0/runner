class_name Status
extends Node

signal deleted

var tag: StatusResource.Tags = StatusResource.Tags.EMPTY

var status_resource: StatusResource
var timer := 0.0
var tick_time: float
var time_passed := 0.0
var time_max := 0.0
var ticks_counter := 0
var ticks_count_max := 0

var parent: Node


func _init(status_resource: StatusResource) -> void:
	self.status_resource = status_resource
	self.tag = status_resource.tag
	self.tick_time = status_resource.tick_time
	match status_resource.off_type:
		StatusResource.OffType.TICKS_COUNT:
			self.ticks_count_max = status_resource.ticks_count_max
		StatusResource.OffType.TIME:
			self.time_max = status_resource.time_max


func _ready() -> void:
	parent = (get_parent() as StatusHandler).get_parent()
	assert(parent is Player or parent is Enemy)
	status_resource.status_enter()


func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= tick_time:
		status_resource.tick_action(self)
		
		if ticks_count_max > 0:
			ticks_counter += 1
			if ticks_counter >= ticks_count_max:
				delete_status()
		if time_max > 0.0:
			time_passed += timer
			if time_passed >= time_max:
				delete_status()
		
		timer = 0.0


func get_parent_health_comp() -> HealthComponent:
	return parent.health_comp


#func get_parent_clothes() -> Clothes:
#	return parent.clothes


func delete_status():
	status_resource.status_exit()
	deleted.emit()
	self.queue_free()
