## This node spawns [ShootEntity] on [method shoot]. Weapon can be obtained by [Player] or [Enemy].
class_name Weapon
extends Node2D

@export var _weapon_resource: WeaponResource ## Stored info about weapon.

var weapon_rarity: Rarity
var weapon_owner: ShootEntity.Owner ## Current owner of weapon.
var damage: int ## Damage dealing by [Player] or [Enemy].
var shoot_rate_time: float ## [member WeaponResource.shoot_rate_time].
var spread_angle: int ## [member WeaponResource.spread_angle]
## Additional spread angle affecting [member spread_angle].
## [br]Manipulate this var only with [method add_extra_spread_angle] and [method remove_extra_spread_angle].
var extra_spread_angle: int
var sprite: AnimatedSprite2D
var shoot_timer: float ## Timer used for [member shoot_rate_time].
var ammo: int ## Amount of [ShootEntity] left before reloading.
var ammo_max: int ## [member WeaponResource.ammo_max].
var reload_time: float ## [member WeaponResource.reload_time]
var is_reloading: bool = false ## Flag for checking if is [method reload] processing.
var is_active: bool = false ## Flag for checking if it belongs to [member Player.weapon] currently.
var existing_shoot_entity: ShootEntity


func _init(weapon_resource: WeaponResource, weapon_rarity: Rarity, weapon_owner: ShootEntity.Owner) -> void:
	sprite = AnimatedSprite2D.new()
	self.add_child(sprite)
	
	assert(weapon_resource != null, "weapon_resource is null")
	_weapon_resource = weapon_resource
	self.name = weapon_resource.name
	self.damage = weapon_resource.get_damage(weapon_rarity) if weapon_owner == ShootEntity.Owner.PLAYER else weapon_resource.damage_from_enemy
	self.ammo_max = weapon_resource.get_ammo_max(weapon_rarity)
	self.ammo = self.ammo_max
	self.reload_time = weapon_resource.get_reload_time(weapon_rarity)
	self.shoot_rate_time = weapon_resource.get_shoot_rate_time(weapon_rarity)
	shoot_timer = self.shoot_rate_time
	self.spread_angle = weapon_resource.spread_angle
	extra_spread_angle = 0
	sprite.sprite_frames = weapon_resource.sprite_frames if weapon_resource.sprite_frames != null else SpriteFrames.new()
	
	self.weapon_rarity = weapon_rarity
	self.weapon_owner = weapon_owner


func _ready() -> void:
	sprite.centered = false
	sprite.position = Vector2.ZERO
	sprite.offset.y = -_weapon_resource.get_sprite_size().y / 2
	sprite.scale = Vector2(_weapon_resource.sprite_scale_value, _weapon_resource.sprite_scale_value)
	
	if sprite.sprite_frames.has_animation("default"):
		sprite.play("default")
	
	if _weapon_resource.shoot_entity_resource.exist_from_start:
		if _is_entity_class(ShootEntityResource.EntityClasses.LASER):
			self.existing_shoot_entity = Laser.new(
					_weapon_resource.shoot_entity_resource, 
					weapon_owner, 
					get_start_shoot_position(), 
					get_start_shoot_position(), 
					damage,
					shoot_rate_time,
					_weapon_resource.status_resource
			)
			(self.existing_shoot_entity as Laser).shooted.connect(
					func():
						self.ammo -= 1
			)
			self.add_child(existing_shoot_entity)
			self.existing_shoot_entity.toggle_shoot_entity(false)


func _physics_process(delta: float) -> void:
	shoot_timer = shoot_timer + delta if not is_shoot_time_ok() else shoot_rate_time

## Spawns [ShootEntity].
func shoot(start_position: Vector2, target_position: Vector2):
	if not is_reloading:
		if ammo > 0:
			if existing_shoot_entity != null:
				existing_shoot_entity.toggle_shoot_entity(true, target_position)
			elif is_shoot_time_ok():
				var sum_spread_angle: int = spread_angle + extra_spread_angle
				var angle: float = deg_to_rad(randf_range(-sum_spread_angle / 2, sum_spread_angle / 2))
				var spreaded_target_position: Vector2 = (target_position - start_position).rotated(angle)
				_spawn_entity(start_position, start_position + spreaded_target_position)
				self.look_at(target_position)
				shoot_timer = 0
				ammo -= 1
		else:
			reload()
			if existing_shoot_entity != null:
				existing_shoot_entity.toggle_shoot_entity(false)


func stop_shoot():
	assert(existing_shoot_entity)
	existing_shoot_entity.toggle_shoot_entity(false)


func _spawn_entity(start_position: Vector2, target_position: Vector2) -> void:
	var ser: ShootEntityResource = _weapon_resource.shoot_entity_resource
	var sr: StatusResource = _weapon_resource.status_resource
	var shoot_field: Node2D = Global.get_game_scene().get_shoot_field()
	assert(shoot_field != null)
	if _is_entity_class(ShootEntityResource.EntityClasses.PROJECTILE_LINEAR):
		shoot_field.add_child(
				ProjectileLinear.new(ser, weapon_owner, start_position, target_position, damage, sr)
		, true)
		return
	elif _is_entity_class(ShootEntityResource.EntityClasses.PROJECTILE_RICO):
		shoot_field.add_child(
				ProjectileRico.new(ser, weapon_owner, start_position, target_position, damage, sr)
		, true)
		return
	elif _is_entity_class(ShootEntityResource.EntityClasses.HITSCAN):
		shoot_field.add_child(
				Hitscan.new(ser, weapon_owner, start_position, target_position, damage, sr)
		, true)
		return
	print_debug("Unknown shoot_entity_resource class, ", _weapon_resource.shoot_entity_resource.entity_class)

## Waits until [member reload_time] passes and restores [member ammo] to [member ammo_max].
func reload():
	if reload_time > 0.0:
		if not is_reloading:
			is_reloading = true
			var color = self.modulate
			self.modulate.a = 0.5
			await get_tree().create_timer(reload_time).timeout
			ammo = ammo_max
			self.modulate = color
			is_reloading = false
	else:
		ammo = ammo_max

## For checking if [member shoot_timer] is more than [member shoot_rate_time].
func is_shoot_time_ok() -> bool:
	return shoot_timer >= shoot_rate_time


func add_extra_spread_angle(angle: int):
	extra_spread_angle = angle


func remove_extra_spread_angle():
	extra_spread_angle = 0


func _is_entity_class(entity_class: ShootEntityResource.EntityClasses) -> bool:
	return _weapon_resource.shoot_entity_resource.entity_class == entity_class


func activate():
	self.show()
	self.is_active = true


func deactivate():
	self.hide()
	self.is_active = false


func get_start_shoot_position() -> Vector2:
	var grandpa = (get_parent() as Marker2D).get_parent()
	assert(grandpa is Player or grandpa is Enemy)
	return grandpa.position + get_parent().position


func get_ammo_snap_step() -> int:
	return _weapon_resource.ammo_snap_step


func get_description() -> String:
	return _weapon_resource.get_description(weapon_rarity, true)


func get_preview() -> Texture2D:
	return sprite.sprite_frames.get_frame_texture("default", 0)
