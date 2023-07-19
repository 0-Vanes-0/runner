## Player object, controled by device and interacting with game.
class_name Player
extends CharacterBody2D

signal call_level_end_objects ## Called when finishing level.
signal go_to_portal(portal_position: Vector2) ## Called when a portal is chosen. (WIP: Portal class as argument)
signal in_portal ## Called when player is inside portal.

var player_sensor: PlayerSensor ## Input object for actions with player object.
var shoot_sensor: ShootSensor ## Input object for shooting.

@export_group("Children")
@export var sprite: AnimatedSprite2D ## Sprite of current demon. (WIP: DemonSkin class)
@export var body_shape: CollisionShape2D ## Body of player, interacting with [Platform].
@export var health_comp: HealthComponent ## Health of player object. When [member HealthComponent.health] reaches 0, player dies.
@export var state_machine: StateMachine ## State machine stores behaviour logic of player object.

@export_group("States", "state_")
@export var state_run: RunPlayerState ## State when player runs.
@export var state_jump_up: JumpUpPlayerState ## State when player jumps up.
@export var state_jump_down: JumpDownPlayerState ## State when player falls or jumps down from platform.
@export var state_dodge: DodgePlayerState ## State when dodge is active.
@export var state_dead: DeadPlayerState ## State when [member HealthComponent.health] is 0.
@export var state_level_end: LevelEndPlayerState ## State when level is finished.

var jump_speed: float ## Describes how fast player jumps in pixels. Depends on [member gravity], do not change this value outside [method prepare_to_run]!
var run_speed: float ## Describes how fast [Segment]s are moving in pixels (player doesn't move horizontally actually :P ).
var dodge_time: float ## Describes how long is [DodgePlayerState].
var stamina: float ## This value is spent on jumps and dodges. Restores during [RunPlayerState].
var stamina_max: float ## Maximum value of [member stamina].
var weapon: Weapon ## Equipped [Weapon].
var weapon1: Weapon
var weapon2: Weapon

var platforms_left: int ## Simple counter of platforms left to finish a level.

## The more it is, the faster player moves vertically. Default value is here: [code]ProjectSettings.get_setting("physics/2d/default_gravity")[/code]
@onready var gravity: float = 1000


func _ready() -> void:
	assert(player_sensor and shoot_sensor and state_run and state_jump_up and state_jump_down and state_dodge and state_dead and state_level_end)
	
	# Setting collision layers listeners
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.PLAYER, true)
	self.set_collision_mask_value(Global.Layers.PLATFORM, true)
	self.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
	self.set_collision_mask_value(Global.Layers.BOUNDS, true)
	
	# Connecting input objects' signals:
	player_sensor.swipe.connect(
			func(direction: Vector2):
				if direction == Vector2.RIGHT:
					state_machine.transition_to(state_dodge)
				elif direction == Vector2.LEFT:
					if weapon1.is_active:
						weapon1.deactivate()
						weapon2.activate()
						weapon = weapon2
						weapon.ammo = weapon.ammo_max
					elif weapon2.is_active:
						weapon2.deactivate()
						weapon1.activate()
						weapon = weapon1
						weapon.ammo = weapon.ammo_max
				elif direction == Vector2.DOWN:
					weapon.reload()
				elif direction == Vector2.UP:
					print_debug("Use current ability")
	)
	player_sensor.tap_up.connect(state_machine.transition_to.bind(state_jump_up))
	player_sensor.tap_down.connect(state_machine.transition_to.bind(state_jump_down))
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
	var arr_copy := Preloader.base_weapon_resources.duplicate() as Array[WeaponResource]
	var wr: WeaponResource = arr_copy.pick_random()
	weapon1 = get_weapon(wr, true)
	self.add_child(weapon1)
	weapon = weapon1
	
	arr_copy.erase(wr)
	wr = arr_copy.pick_random()
	weapon2 = get_weapon(wr)
	self.add_child(weapon2)
	
	self.scale = get_game_size() / (sprite.sprite_frames.get_frame_texture("default", 0).get_size() * sprite.scale)

## Inits player without recreating new instance.
func prepare_to_run():
	self.position = Vector2(Global.SCREEN_WIDTH * 0.15, Global.SCREEN_HEIGHT / 2)
	var jump_height: float = (Global.SCREEN_HEIGHT - Platform.SIZE.y) / Global.MAX_FLOORS + Platform.SIZE.y
	jump_speed = sqrt(2 * gravity * jump_height)
	stamina = stamina_max
	state_machine.transition_to(state_run)


func get_game_size() -> Vector2:
	# WHEN I'LL HAVE BETTER PLAYER SPRITES - MAKE --> / 2
	return Vector2.ONE * Global.FLOORS_GAP


func get_health_comp_position() -> Vector2:
	return self.position + health_comp.position


func get_current_state() -> PlayerState:
	return state_machine.state


func get_weapon(weapon_resource: WeaponResource, need_activate := false) -> Weapon:
	var weapon := Weapon.new(weapon_resource, ShootEntity.Owner.PLAYER)
	weapon.name = weapon_resource.name
	weapon.position = health_comp.position
	if need_activate:
		weapon.activate()
	else:
		weapon.deactivate()
	return weapon
