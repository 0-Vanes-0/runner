class_name BurningStatusResource
extends StatusResource

@export_range(1, 100) var base_damage: int = 0

func _init() -> void:
	tick_action = func(status: Status):
		if status.parent_health_comp != null:
			status.parent_health_comp.take_damage(base_damage)
