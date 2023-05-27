class_name Weapon
extends Node2D

@export var weapon_resource: WeaponResource

#var shoot_entities: Array[ShootEntity] = []
var shoot_field: Node2D
var shoot_rate_time: float
var spread_angle: int
var sprite: AnimatedSprite2D
var shoot_timer: float


func _init(weapon_resource: WeaponResource, shoot_field: Node2D):
	sprite = AnimatedSprite2D.new()
	self.add_child(sprite)
	
	if weapon_resource != null:
		self.weapon_resource = weapon_resource
		shoot_rate_time = weapon_resource.shoot_rate_time
		shoot_timer = shoot_rate_time
		spread_angle = weapon_resource.spread_angle
		sprite.sprite_frames = weapon_resource.sprite_frames
	else:
		print_debug("weapon_resource is null")
	
	self.shoot_field = shoot_field


func _ready():
	sprite.centered = false
	sprite.position = Vector2.ZERO
	sprite.scale = Vector2(weapon_resource.scale_value, weapon_resource.scale_value)
	sprite.offset.y = -weapon_resource.get_sprite_size().y / 2
	
	sprite.play("default")


func _process(delta):
	shoot_timer = shoot_timer + delta if _is_shoot_paused() else shoot_rate_time


func shoot(start_position: Vector2, target_position: Vector2):
	if not _is_shoot_paused():
		var angle: float = deg_to_rad(spread_angle / 2 * randf()) * (1 if randi_range(0, 1) == 1 else -1)
		var entity := _init_entity(weapon_resource.shoot_entity_resource, ShootEntity.Owner.PLAYER, start_position, target_position.rotated(angle))
#		shoot_entities.append(entity)
		shoot_field.add_child(entity)
		shoot_timer = 0


func _init_entity(res: ShootEntityResource, owner: ShootEntity.Owner, start_position, target_position) -> ShootEntity:
	if weapon_resource.shoot_entity_resource.entity_class == ShootEntityResource.EntityClasses.PROJECTILE_LINEAR:
		return ProjectileLinear.new(res, owner, start_position, target_position)
	elif weapon_resource.shoot_entity_resource.entity_class == ShootEntityResource.EntityClasses.PROJECTILE_RICO:
		return ProjectileRico.new(res, owner, start_position, target_position)
	print_debug("Unknown shoot_entity_resource class, ", weapon_resource.shoot_entity_resource.entity_class)
	return Node2D.new()


func _is_shoot_paused() -> bool:
	return shoot_timer < shoot_rate_time
