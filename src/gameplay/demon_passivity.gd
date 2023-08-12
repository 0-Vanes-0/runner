class_name DemonPassivity
extends Object

const HP_BUFF: int = 1
const HP_REGEN: int = 1
const STAMINA_BUFF: int = 1
const STAMINA_REGEN: int = 1
const GRAVITY_BUFF: int = 1
const SPEED_BUFF: int = 1
const SPEED_ACC_BUFF: int = 1

var _type: int
var _value: float


func _init(type: int, value: float) -> void:
	_type = type
	_value = value


func get_type() -> int:
	return _type


func get_value() -> int:
	return _value
