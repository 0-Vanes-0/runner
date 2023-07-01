class_name Weapon
extends Node2D

@export var weapon_resource: WeaponResource

var weapon_owner: ShootEntity.Owner
var shoot_rate_time: float
var spread_angle: int
var extra_spread_angle: int
var sprite: AnimatedSprite2D
var shoot_timer: float


func _init(weapon_resource: WeaponResource, weapon_owner: ShootEntity.Owner) -> void:
	sprite = AnimatedSprite2D.new()
	self.add_child(sprite)
	
	assert(weapon_resource != null, "weapon_resource is null")
	self.weapon_resource = weapon_resource
	shoot_rate_time = weapon_resource.shoot_rate_time
	shoot_timer = shoot_rate_time
	spread_angle = weapon_resource.spread_angle
	extra_spread_angle = 0
	sprite.sprite_frames = weapon_resource.sprite_frames if weapon_resource.sprite_frames != null else SpriteFrames.new()
	
	self.weapon_owner = weapon_owner


func _ready() -> void:
	sprite.centered = false
	sprite.position = Vector2.ZERO
	sprite.scale = Vector2(weapon_resource.scale_value, weapon_resource.scale_value)
	sprite.offset.y = -weapon_resource.get_sprite_size().y / 2
	
	if sprite.sprite_frames.has_animation("default"):
		sprite.play("default")


func _physics_process(delta: float) -> void:
	shoot_timer = shoot_timer + delta if not can_shoot() else shoot_rate_time


func shoot(start_position: Vector2, target_position: Vector2):
	if can_shoot():
		var sum_spread_angle: int = spread_angle + extra_spread_angle
		var angle: float = deg_to_rad(randf_range(-sum_spread_angle / 2, sum_spread_angle / 2))
		var spreaded_target_position: Vector2 = (target_position - start_position).rotated(angle)
		_spawn_entity(weapon_resource.shoot_entity_resource, weapon_owner, start_position, start_position + spreaded_target_position)
		self.look_at(target_position)
		shoot_timer = 0


func _spawn_entity(res: ShootEntityResource, owner: ShootEntity.Owner, start_position: Vector2, target_position: Vector2) -> void:
	assert(res.shoot_field_path != null)
	var shoot_field := Global.get_current_scene().get_node(res.shoot_field_path) as Node2D
	assert(shoot_field != null)
	if weapon_resource.shoot_entity_resource.entity_class == ShootEntityResource.EntityClasses.PROJECTILE_LINEAR:
		shoot_field.add_child(ProjectileLinear.new(res, owner, start_position, target_position))
		return
	elif weapon_resource.shoot_entity_resource.entity_class == ShootEntityResource.EntityClasses.PROJECTILE_RICO:
		shoot_field.add_child(ProjectileRico.new(res, owner, start_position, target_position))
		return
	print_debug("Unknown shoot_entity_resource class, ", weapon_resource.shoot_entity_resource.entity_class)


func can_shoot() -> bool:
	return shoot_timer >= shoot_rate_time


func add_extra_spread_angle(angle: int):
	extra_spread_angle = angle


func remove_extra_spread_angle():
	extra_spread_angle = 0
