class_name Player
extends CharacterBody2D

const JUMP_MIDDLE_VELOCITY := 200.0
const DODGE_TIME := 1.0

@export var player_sensor: PlayerSensor
@export var shoot_sensor: ShootSensor
@export var shoot_field: Node2D

var jump_speed: float
var dodge_timer: float
var weapon: Weapon

@onready var is_jump_middle_on: bool = false
@onready var is_jumping_down: bool = false
@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D 
@onready var hitbox: Area2D = $Hitbox 


func _ready():
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.PLAYER, true)
	self.set_collision_mask_value(Global.Layers.PLATFORM, true)
	self.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
	self.set_collision_mask_value(Global.Layers.BOUNDS, true)
	
	dodge_timer = DODGE_TIME
	
	if player_sensor == null:
		print_debug("PlayerSensor is null")
	else:
		player_sensor.swipe.connect(_move)
	
	if shoot_sensor == null:
		print_debug("ShootSensor is null")
	else:
		shoot_sensor.tap.connect(_tap_shoot)
	
	if shoot_field == null:
		print_debug("ShootField is null")
	
	weapon = Weapon.new(preload("res://assets/game_recources/weapons/crossbow.tres"), shoot_field)
	self.add_child(weapon)
	weapon.position = hitbox.position


func _physics_process(delta):
	self.velocity.y += gravity * delta
	dodge_timer = dodge_timer + delta if is_dodging() else DODGE_TIME
	move_and_slide()
	_check_flags()


func _process(delta):
	_play_animations()


func is_dodging() -> bool:
	return dodge_timer < DODGE_TIME


func _check_flags():
	if self.is_on_floor():
		is_jump_middle_on = false
		is_jumping_down = false


func _play_animations():
	if is_on_floor():
		if is_dodging():
			sprite.play("dodge") # TODO: Make const Dict with animation names
		else:
			sprite.play("run")
	else:
		if is_jump_middle_on and abs(self.velocity.y) < JUMP_MIDDLE_VELOCITY:
			sprite.play("jump_middle")
		elif self.velocity.y < 0:
			sprite.play("jump_up")
		elif self.velocity.y > 0:
			sprite.play("jump_down")


func _move(direction: Vector2):
	var platform := _get_colliding_platform()
	var floor_number := 0 if platform == null else platform.floor_number
	if not is_dodging():
		if direction.y > 0 and not is_jumping_down:
			# Jump down:
			self.velocity.y = direction.y
			is_jumping_down = true
			if platform != null and floor_number > 1:
				platform.toggle_collision()
		
		if is_on_floor():
			# Jump up:
			if direction.y < 0 and floor_number < Global.MAX_FLOORS:
				self.velocity.y = direction.y * jump_speed
				is_jump_middle_on = true
			
			# Dodge:
			elif direction.x > 0 and not is_dodging():
				dodge_timer = 0
				hitbox.monitorable = false
				await get_tree().create_timer(DODGE_TIME).timeout
				hitbox.monitorable = true


func _get_colliding_platform() -> Platform:
	for i in self.get_slide_collision_count():
		var collider = self.get_slide_collision(i).get_collider()
		if collider is Platform:
			return collider
	return null


func _tap_shoot(target_position: Vector2):
	if not is_dodging():
#		var start_position: Vector2 = $Weapon.position
		weapon.shoot(self.position + weapon.position, target_position)
