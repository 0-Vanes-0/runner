class_name Player
extends CharacterBody2D

signal call_level_end_objects
signal go_to_portal(portal_position: Vector2)
signal in_portal

# Input objects
@export var player_sensor: PlayerSensor
@export var shoot_sensor: ShootSensor
# Children Nodes
@export_group("Children")
@export var sprite: AnimatedSprite2D
@export var body_shape: CollisionShape2D
@export var health_comp: HealthComponent
@export var state_machine: StateMachine
# References to states from StateMachine
@export_group("States", "state_")
@export var state_run: RunPlayerState
@export var state_jump_up: JumpUpPlayerState
@export var state_jump_down: JumpDownPlayerState
@export var state_dodge: DodgePlayerState
@export var state_dead: DeadPlayerState
@export var state_level_end: LevelEndPlayerState

var jump_speed: float
var run_speed: float
var dodge_time: float
var stamina: float
var stamina_max: float
var weapon: Weapon

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	assert(player_sensor and shoot_sensor and state_run and state_jump_up and state_jump_down and state_dodge and state_dead and state_level_end)
	
	# "Global" is singleton script
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.PLAYER, true)
	self.set_collision_mask_value(Global.Layers.PLATFORM, true)
	self.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
	self.set_collision_mask_value(Global.Layers.BOUNDS, true)
	
	# Connecting input objects' signals:
	player_sensor.movement.connect(
			func(direction: Vector2):
				if direction.x > 0:
					state_machine.transition_to(state_dodge)
				elif direction.y > 0:
					state_machine.transition_to(state_jump_down)
				elif direction.y < 0:
					state_machine.transition_to(state_jump_up)
	)
	shoot_sensor.shoot_activated.connect(
			func(target_position: Vector2):
				if(
					not state_machine.state is DodgePlayerState 
					and not state_machine.state is DeadPlayerState
					and not state_machine.state is LevelEndPlayerState
				):
					weapon.shoot(self.position + weapon.position, target_position)
	)
	
	# Adding Weapon:
	weapon = Weapon.new(preload("res://assets/game_recources/weapons/crossbow.tres"), ShootEntity.Owner.PLAYER)
	weapon.name = "Weapon"
	self.add_child(weapon)
	weapon.position = health_comp.position
	
	self.scale = get_game_size() / (sprite.sprite_frames.get_frame_texture("default", 0).get_size() * sprite.scale)


func get_game_size() -> Vector2:
	# WHEN I'LL HAVE BETTER PLAYER SPRITES - MAKE --> / 2
	return Vector2.ONE * Global.FLOORS_GAP


func get_health_comp_position() -> Vector2:
	return self.position + health_comp.position
