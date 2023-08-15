class_name Status
extends Node

signal deleted

var tag: StatusResource.Tags = StatusResource.Tags.EMPTY

var timer := 0.0
var tick_time: float
var time_passed := 0.0
var time_max := 0.0
var ticks_counter := 0
var ticks_count_max := 0
var tick_action: Callable

var parent: Node
var parent_health_comp: HealthComponent
#var parent_clothes: Clothes


func _init(status_resource: StatusResource) -> void:
	self.tag = status_resource.tag
	self.tick_time = status_resource.tick_time
	self.tick_action = Callable(status_resource.tick_action)
	match status_resource.off_type:
		StatusResource.OffType.TICKS_COUNT:
			self.ticks_count_max = status_resource.ticks_count_max
		StatusResource.OffType.TIME:
			self.time_max = status_resource.time_max


func _ready() -> void:
	parent = (get_parent() as StatusHandler).get_parent()
	if parent is Player:
		parent_health_comp = parent.health_comp
#		parent_clothes = parent.clothes
	elif parent is Enemy:
		parent_health_comp = parent.health_comp
#		parent_clothes = parent.clothes


func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= tick_time:
		tick_action.call(self)
		
		if ticks_count_max > 0:
			ticks_counter += 1
			if ticks_counter >= ticks_count_max:
				delete_status()
		if time_max > 0.0:
			time_passed += timer
			if time_passed > time_max:
				delete_status()
		
		timer = 0.0


func delete_status():
	deleted.emit()
	self.queue_free()
