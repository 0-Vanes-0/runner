class_name ShootEntity
extends Node2D

enum Owner {
	PLAYER = 1, ENEMY = 2
}
# Init variables
var resource: ShootEntityResource
var entity_owner: Owner
var start_position: Vector2
var target_position: Vector2
var damage: int
var status_resource: StatusResource


func _init(resource: ShootEntityResource, entity_owner: Owner, start_position: Vector2, target_position: Vector2, damage: int, status_resource: StatusResource = null) -> void:
	self.resource = resource
	self.status_resource = status_resource
	self.damage = damage
	self.entity_owner = entity_owner
	self.start_position = start_position
	self.target_position = target_position


func create_animated_sprite(resource: ShootEntityResource) -> AnimatedSprite2D:
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = resource.sprite_frames
	var game_size: Vector2 = Vector2(resource.size_x_percent, resource.size_y_percent) / 100 * Global.SCREEN_HEIGHT
	sprite.scale = Vector2(game_size / resource.get_sprite_size())
	return sprite


func create_collision_object(obj: CollisionObject2D, entity_owner: Owner) -> CollisionObject2D:
	Global.clean_layers(obj)
	if entity_owner == Owner.PLAYER:
		obj.set_collision_layer_value(Global.Layers.SHOOT_ENTITY_PLAYER, true)
		obj.set_collision_mask_value(Global.Layers.ENEMY, true)
	elif entity_owner == Owner.ENEMY:
		obj.set_collision_layer_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
		obj.set_collision_mask_value(Global.Layers.PLAYER, true)
	return obj


func add_status(target: Node):
	if status_resource != null:
		if target is Enemy: # target is Player or
			target.status_handler.add_status(status_resource)
