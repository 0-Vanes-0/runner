class_name DemonData
extends Object

var skin_resource: SkinResource
var color: Color
var weapon_resource: WeaponResource


func _init(skin_resource: SkinResource, color: Color, weapon_resource: WeaponResource) -> void:
	self.skin_resource = skin_resource
	self.color = color
	self.weapon_resource = weapon_resource
