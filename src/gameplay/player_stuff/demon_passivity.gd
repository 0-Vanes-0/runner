class_name DemonPassivity
extends Object

var _type: DemonPassivityResource.Types
var _value: float


func _init(type: DemonPassivityResource.Types, value: float) -> void:
	_type = type
	_value = value


func get_type() -> DemonPassivityResource.Types:
	return _type


func get_value() -> int:
	return _value
