class_name DemonPassivityResource
extends Resource

enum Types {
	NONE = 0,
	HP_BUFF = 11, HP_REGEN = 12,
	STAMINA_BUFF = 21, STAMINA_REGEN = 22, GRAVITY_BUFF = 23,
	SPEED_BUFF = 31, SPEED_ACC_BUFF = 32,
}
@export var type: Types = Types.NONE
@export_range(0, 100, 0.1) var value: float


func _init() -> void:
	assert(type != Types.NONE, "Type is not set!")
