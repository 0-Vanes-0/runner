class_name WeaponPassivity
extends Object

var _rarity: Rarity
var _type: WeaponPassivityResource.Types
var _value: float


func _init(resource: WeaponPassivityResource, rarity: Rarity) -> void:
	_rarity = rarity
	_type = resource.type
	_value = resource.get_value(rarity)


func get_type() -> WeaponPassivityResource.Types:
	return _type


func get_value() -> float:
	return _value


func get_value_as_percent() -> float:
	return _value / 100
