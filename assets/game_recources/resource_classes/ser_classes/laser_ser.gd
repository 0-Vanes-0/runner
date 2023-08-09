class_name LaserSER
extends ShootEntityResource

#@export_range(0, 25, 0.1) var beam_width: float # percents of SCREEN_HEIGHT
@export var has_penetration: bool = false


func _init() -> void:
	self.exist_from_start = true
