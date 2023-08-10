## Player object, controled by device and interacting with game.
class_name Player
extends CharacterBody2D

signal call_level_end_objects ## Called when finishing level.
signal go_to_portal(portal_position: Vector2) ## Called when a portal is chosen. (WIP: Portal class as argument)
signal in_portal ## Called when player is inside portal.

var player_sensor: PlayerSensor ## Input object for actions with player object.
var shoot_sensor: ShootSensor ## Input object for shooting.

@export_group("Children")
@export var fact_size_area: Area2D
@export var sprite: AnimatedSprite2D ## Sprite of current demon. (WIP: DemonSkin class)
@export var body_shape: CollisionShape2D ## Body of player, interacting with [Platform].
@export var weapon_marker: Marker2D
@export var health_comp: HealthComponent ## Health of player object. When [member HealthComponent.health] reaches 0, player dies.
@export var state_machine: StateMachine ## State machine stores behaviour logic of player object.
@export var status_handler: StatusHandler ## Parent node of all [Status]es.

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
var gravity: float
var weapon: Weapon ## Equipped [Weapon].
var weapon1: Weapon
var weapon2: Weapon

var platforms_left: int ## Simple counter of platforms left to finish a level.

## The more it is, the faster player moves vertically. Default value is here: [code]ProjectSettings.get_setting("physics/2d/default_gravity")[/code]


func _ready() -> void:
	assert(
			player_sensor and shoot_sensor 
			and state_run and state_jump_up and state_jump_down and state_dodge and state_dead and state_level_end
			and sprite and body_shape and health_comp and state_machine and status_handler
	)
	self.name = "Player"
	
	# Setting collision layers listeners
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.PLAYER, true)
	self.set_collision_mask_value(Global.Layers.PLATFORM, true)
	self.set_collision_mask_value(Global.Layers.BOUNDS, true)
	Global.clean_layers(health_comp).set_collision_layer_value(Global.Layers.PLAYER, true)
	health_comp.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
	
	self.scale = get_adjust_scale()
	
	# Connecting input objects' signals:
	player_sensor.swipe.connect(
			func(direction: Vector2):
				if direction == Vector2.RIGHT:
					state_machine.transition_to(state_dodge)
				elif direction == Vector2.LEFT:
					if weapon1 != null and weapon2 != null:
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
					weapon.shoot(weapon.get_start_shoot_position(), target_position)
				
				elif weapon.existing_shoot_entity != null:
					weapon.stop_shoot()
	)
	shoot_sensor.shoot_disabled.connect(
			func():
				if weapon.existing_shoot_entity != null:
					weapon.stop_shoot()
	)

## Inits player without recreating new instance.
func prepare_to_run():
	self.position = Vector2(Global.SCREEN_WIDTH * 0.15, Global.SCREEN_HEIGHT / 2)
	var jump_height: float = (Global.SCREEN_HEIGHT - Platform.SIZE.y) / Global.MAX_FLOORS + Platform.SIZE.y
	jump_speed = sqrt(2 * gravity * jump_height)
	stamina = stamina_max
	state_machine.transition_to(state_run)


func apply_player_data():
	Global.player_data.skin_resource.apply_to_sprite(sprite)
	sprite.scale = Vector2.ONE * get_fact_size().y / sprite.sprite_frames.get_frame_texture("default", 0).get_size().y
	sprite.modulate = Global.player_data.color
	
	health_comp.health = Global.player_data.base_hp
	run_speed = Global.player_data.base_speed
	stamina_max = Global.player_data.base_stamina
	gravity = Global.player_data.base_gravity
	
	# Adding Weapon:
	weapon1 = get_weapon(Global.player_data.weapon_resource, Global.player_data.start_weapon_rarity, true)
	weapon = weapon1
	weapon_marker.add_child(weapon1)
	
#	weapon2 = get_weapon(wr)
#	self.add_child(weapon2)


func get_game_size() -> Vector2:
	return Vector2.ONE * Global.FLOORS_GAP / 2


func get_fact_size() -> Vector2:
	return ((fact_size_area.get_child(0) as CollisionShape2D).shape as RectangleShape2D).size


func get_adjust_scale() -> Vector2:
	return get_game_size() / get_fact_size()


func get_health_comp_position() -> Vector2:
	return self.position + health_comp.position


func get_current_state() -> PlayerState:
	return state_machine.state


func get_weapon(weapon_resource: WeaponResource, weapon_rarity: Rarity, need_activate := false) -> Weapon:
	var weapon := Weapon.new(weapon_resource, weapon_rarity, ShootEntity.Owner.PLAYER)
	weapon.name = weapon_resource.name
	if need_activate:
		weapon.activate()
	else:
		weapon.deactivate()
	return weapon
