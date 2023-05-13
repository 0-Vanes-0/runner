class_name ShootEntity
extends Node2D

enum ShootType {
	PROJECTILE_LINEAR, HITSCAN
}
var type: ShootType

# Init variables
var entity_owner: Object
var start_position: Vector2
var target_position: Vector2
var damage: int



func _init(entity_owner: Object, start_position: Vector2, target_position: Vector2, damage: int):
	self.entity_owner = entity_owner
	self.start_position = start_position
	self.target_position = target_position
	self.damage = damage
