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
@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D 
@onready var hitbox: Area2D = $Hitbox 


func _ready():
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.PLAYER, true)
	self.set_collision_mask_value(Global.Layers.PLATFORM, true)
	self.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
	
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


func _process(delta):
	self.velocity.y += gravity * delta
	dodge_timer = dodge_timer + delta if is_dodging() else DODGE_TIME
	
	move_and_slide()
	_play_animations()


func is_dodging() -> bool:
	return dodge_timer < DODGE_TIME


func _play_animations():
	if is_on_floor():
		if is_dodging():
			sprite.play("dodge") # TODO: Make const Dict with animation names
		else:
			sprite.play("run")
		
		if not is_jump_middle_on:
			is_jump_middle_on = true
	else:
		if is_jump_middle_on and abs(self.velocity.y) < JUMP_MIDDLE_VELOCITY:
			sprite.play("jump_middle")
		elif self.velocity.y < 0:
			sprite.play("jump_up")
		elif self.velocity.y > 0:
			sprite.play("jump_down")


func _move(direction: Vector2):
	if is_on_floor() and not is_dodging():
		# Jump down:
		if direction.y > 0 and _get_colliding_floor() > 0:
			is_jump_middle_on = false
			$CollisionShape2D.disabled = true
			await get_tree().create_timer(0.1).timeout
			$CollisionShape2D.disabled = false
		
		# Jump up:
		elif direction.y < 0 and _get_colliding_floor() < Global.floor_group_names.size() - 1 and _get_colliding_floor() > -1:
			self.velocity.y = direction.y * jump_speed
		
		# Dodge:
		elif direction.x > 0 and not is_dodging():
			dodge_timer = 0
			hitbox.monitorable = false
			await get_tree().create_timer(DODGE_TIME).timeout
			hitbox.monitorable = true


func _get_colliding_floor() -> int:
	for i in self.get_slide_collision_count():
		var collider = self.get_slide_collision(i).get_collider()
		if collider is Platform:
			var group_name: String = collider.get_groups().back()
			return Global.floor_group_names.find(group_name)
	return -1


func _tap_shoot(target_position: Vector2):
	if not is_dodging():
#		var start_position: Vector2 = $Weapon.position
		weapon.shoot(self.position + weapon.position, target_position)
