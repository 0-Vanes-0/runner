class_name DemonPassivityResource
extends Resource

enum Types {
	NONE = 0,
	HP_BUFF = 11,
	STAMINA_REGEN = 21, GRAVITY_BUFF = 22, JUMPS_STAMINA_COST_REDUCE = 23, DODGE_STAMINA_COST_REDUCE = 24,
	SPEED_BUFF = 31, SPEED_ACC_BUFF = 32,
}
@export var type: Types = Types.NONE
@export_range(0, 100, 0.1) var value: float
