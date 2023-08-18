class_name DemonPassivity
extends Object

var _type: DemonPassivityResource.Types
var _value: float


func _init(resource: DemonPassivityResource) -> void:
	_type = resource.type
	_value = resource.value


func get_type() -> DemonPassivityResource.Types:
	return _type


func get_value() -> float:
	return _value


func get_value_as_percent() -> float:
	return _value / 100
