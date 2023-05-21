class_name ShootEntity
extends Node2D

enum Owner {
	PLAYER, ENEMY
}
# Init variables
var resource: ShootEntityResource
var entity_owner: Owner
var start_position: Vector2
var target_position: Vector2


func _init(resource: ShootEntityResource, entity_owner: Owner, start_position: Vector2, target_position: Vector2):
	self.resource = resource
	self.entity_owner = entity_owner
	self.start_position = start_position
	self.target_position = target_position
