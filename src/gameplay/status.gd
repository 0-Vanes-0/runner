class_name Status
extends Node

var timer := 0.0
var tick_time: float
var time_passed := 0.0
var time_max := 0.0
var ticks_counter := 0
var ticks_count_max := 0
var tick_action: Callable
var tick_action_counter := 0
var tick_action_count_max := 0

var parent: Node
var parent_health_comp: HealthComponent


func _init(status_resource: StatusResource) -> void:
	self.tick_time = status_resource.tick_time
	self.tick_action = Callable(status_resource.tick_action)
	self.tick_action_count_max = status_resource.status_count_max
	match status_resource.off_type:
		StatusResource.OffType.TICKS_COUNT:
			self.ticks_count_max = status_resource.ticks_count_max
		StatusResource.OffType.TIME:
			self.time_max = status_resource.time_max


func _ready() -> void:
	parent = get_parent()
	if parent is Player:
		parent_health_comp = parent.health_comp
	elif parent is Enemy:
		parent_health_comp = parent.health_comp


func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= tick_time:
		for i in tick_action_counter:
			tick_action.call(self)
		
		if ticks_count_max > 0:
			ticks_counter += 1
			if ticks_counter >= ticks_count_max:
				self.queue_free()
		if time_max > 0.0:
			time_passed += timer
			if time_passed > time_max:
				self.queue_free()
		
		timer = 0.0
