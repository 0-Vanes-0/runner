class_name BurningStatusResource
extends StatusResource

@export_range(1, 100) var base_damage: int = 1

func _init() -> void:
	tag = Tags.BURNING
	tick_action = func(status: Status) -> void:
		if status.parent_health_comp != null:
			status.parent_health_comp.take_damage(base_damage)
