class_name ShootEntity
extends Node2D

enum Owner {
	PLAYER = 1, ENEMY = 2
}
# Init variables
var resource: ShootEntityResource
var damage: int
var entity_owner: Owner
var start_position: Vector2
var target_position: Vector2


func _init(resource: ShootEntityResource, entity_owner: Owner, start_position: Vector2, target_position: Vector2) -> void:
	self.resource = resource
	self.damage = resource.damage
	self.entity_owner = entity_owner
	self.start_position = start_position
	self.target_position = target_position


#func do_damage(to: HealthComponent):
