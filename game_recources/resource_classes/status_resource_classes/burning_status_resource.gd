class_name BurningStatusResource
extends StatusResource

@export_range(1, 100) var base_damage: int = 1

func _init() -> void:
	tag = Tags.BURNING


func status_enter():
	pass


func tick_action(status: Status):
	if status.get_parent_health_comp() != null: # and status.get_parent_clothes != null and status.get_parent_clothes.get_type() == ClothesResource.Types.TISSUE
		status.parent_health_comp.take_damage(base_damage)


func status_exit():
	pass
