## Player object, controled by device and interacting with game.
class_name Player
extends CharacterBody2D

signal call_level_end_objects ## Called when finishing level.
signal go_to_portal(portal_position: Vector2) ## Called when a portal is chosen. (WIP: Portal class as argument)
signal in_portal ## Called when player is inside portal.
signal hp_max_changed(value: int)
signal stamina_max_changed(value: int)
signal ammo_max_changed(value: int)

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
#@export var state_jetpack: JetpackPlayerState ## State when player is using jetpack.

var jump_speed: float ## Describes how fast player jumps in pixels. Depends on [member gravity], do not change this value outside [method prepare_to_run]!
var run_speed: float ## Describes how fast [Segment]s are moving in pixels (player doesn't move horizontally actually :P ).
var current_run_speed: float
var dodge_time: float ## Describes how long is [DodgePlayerState].
var stamina: float ## This value is spent on jumps and dodges. Restores during [RunPlayerState].
var stamina_max: float = 100.0 ## Maximum value of [member stamina].
var stamina_regen: float
var gravity: float ## The more it is, the faster player moves vertically.

var weapon: Weapon ## Equipped [Weapon].
var weapon1: Weapon
var weapon2: Weapon
var passivities: Array[DemonPassivity]
var activity: Activity

var platforms_left: float ## Simple counter of platforms left to finish a level.
var is_jetpacking: bool = false


func _ready() -> void:
	assert(player_sensor and shoot_sensor)
	assert(state_run and state_jump_up and state_jump_down and state_dodge and state_dead and state_level_end) # and state_jetpack
	assert(fact_size_area and sprite and body_shape and weapon_marker and health_comp and state_machine and status_handler)
	self.name = "Player"
	
	# Setting collision layers listeners
	Global.clean_layers(self).set_collision_layer_value(Global.Layers.PLAYER, true)
	self.set_collision_mask_value(Global.Layers.PLATFORM, true)
	self.set_collision_mask_value(Global.Layers.BOUNDS, true)
	Global.clean_layers(health_comp).set_collision_layer_value(Global.Layers.PLAYER, true)
	health_comp.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_ENEMY, true)
	
	self.scale = get_adjust_scale()
	
	# Connecting input objects' signals:
	player_sensor.switch.connect(
			func():
				if weapon1 != null and weapon2 != null:
					if weapon1.is_active:
						activate_weapon2()
					elif weapon2.is_active:
						activate_weapon1()
					shoot_sensor.stop_progress_reload()
	)
	player_sensor.dodge.connect(
			func():
				state_machine.transition_to(state_dodge)
	)
	player_sensor.activity.connect(
			func():
				if activity != null:
					activity.activate()
	)
	player_sensor.jump_up.connect(
			func():
				state_machine.transition_to(state_jump_up)
	)
	player_sensor.jump_down.connect(
			func():
				state_machine.transition_to(state_jump_down)
	)
#	player_sensor.jetpack_on.connect(
#			func():
#				state_machine.transition_to(state_jetpack)
#				is_jetpacking = true
#	)
#	player_sensor.jetpack_off.connect(
#			func():
#				is_jetpacking = false
#	)
	
	shoot_sensor.shoot_activated.connect(
			func(target_position_y: float):
				if not state_machine.state in [DodgePlayerState, DeadPlayerState, LevelEndPlayerState]:
					var from_vector := weapon.get_start_shoot_position()
					var to_vector := Vector2(Global.ENEMY_X_POSITION, Global.camera.get_screen_center_position().y + target_position_y)
					weapon.shoot(from_vector, to_vector)
					if weapon.is_reloading:
						shoot_sensor.progress_reload(weapon.reload_time)
				
				else:
					weapon.stop_shoot()
	)

	shoot_sensor.shoot_disabled.connect(
			func():
				weapon.stop_shoot()
				weapon.reload()
				shoot_sensor.progress_reload(weapon.reload_time)
	)

## Inits player without recreating new instance.
func prepare_to_run():
	self.position = Vector2(Global.SCREEN_WIDTH * 0.25, Global.SCREEN_HEIGHT / 2)
	var jump_height: float = (Global.SCREEN_HEIGHT - Platform.SIZE.y) / Global.MAX_SCREEN_FLOORS + Platform.SIZE.y
	jump_speed = sqrt(2 * gravity * jump_height)
	stamina = stamina_max
	state_machine.transition_to(state_run)


func apply_player_data():
	var data := Global.player_data as DemonData
	data.skin_resource.apply_to_sprite(sprite)
	sprite.scale = Vector2.ONE * get_fact_size().y / sprite.sprite_frames.get_frame_texture("default", 0).get_size().y
	sprite.modulate = data.color
	
	health_comp.health_max = data.base_hp
	run_speed = data.base_speed
	current_run_speed = run_speed
	stamina_max = data.base_stamina
	gravity = data.base_gravity
	dodge_time = data.dodge_time
	stamina_regen = data.base_stamina_regen
	
	# Adding Weapon:
	weapon1 = get_weapon(data.weapon_resource, data.start_weapon_rarity, true)
	weapon = weapon1
	ammo_max_changed.emit()
	weapon_marker.add_child(weapon1)


func apply_demon_passivity(resource: DemonPassivityResource, rarity: Rarity):
	var passivity := DemonPassivity.new(resource, rarity)
	match passivity.get_type():
		DemonPassivityResource.Types.HP_BUFF:
			var buff: int = roundi(Global.player_data.base_hp * passivity.get_value_as_percent())
			health_comp.health_max += buff
			health_comp.health += buff
			hp_max_changed.emit(health_comp.health_max)
		DemonPassivityResource.Types.STAMINA_BUFF:
			var buff: int = roundi(Global.player_data.base_stamina * passivity.get_value_as_percent())
			stamina_max += buff
			stamina_max_changed.emit(stamina_max)
		DemonPassivityResource.Types.GRAVITY_BUFF:
			var buff: int = roundi(Global.player_data.base_gravity * passivity.get_value_as_percent())
			gravity += buff
		DemonPassivityResource.Types.SPEED_BUFF:
			var buff: int = roundi(Global.player_data.base_speed * passivity.get_value_as_percent())
			run_speed += buff
		_:
			assert(false, "Unknown type of passivity: " + str(passivity.get_type()))
	passivities.append(passivity)


func apply_weapon_passivity(choosed_weapon: Weapon, resource: WeaponPassivityResource, rarity: Rarity):
	var passivity := WeaponPassivity.new(resource, rarity)
	match passivity.get_type():
		WeaponPassivityResource.Types.DAMAGE_BUFF:
			var buff: int = roundi(choosed_weapon.damage * passivity.get_value_as_percent())
			choosed_weapon.damage += buff
		WeaponPassivityResource.Types.SHOOT_RATE_BUFF:
			var reduce: int = roundi(choosed_weapon.shoot_rate_time * passivity.get_value_as_percent())
			choosed_weapon.shoot_rate_time -= reduce
		WeaponPassivityResource.Types.AMMO_BUFF:
			var buff: int = roundi(choosed_weapon.ammo_max * passivity.get_value_as_percent())
			choosed_weapon.ammo_max += buff
		WeaponPassivityResource.Types.RELOAD_TIME_BUFF:
			var reduce: int = roundi(choosed_weapon.reload_time * passivity.get_value_as_percent())
			choosed_weapon.reload_time -= reduce
		_:
			assert(false, "Unknown type of passivity: " + str(passivity.get_type()))


func get_game_size() -> Vector2:
	return Vector2.ONE * Global.FLOORS_GAP / 2


func get_fact_size() -> Vector2:
	return ((fact_size_area.get_child(0) as CollisionShape2D).shape as RectangleShape2D).size


func get_adjust_scale() -> Vector2:
	return get_game_size() / get_fact_size()


func get_health_comp_position() -> Vector2:
	return self.position + health_comp.position


func get_current_state() -> PlayerState:
	return state_machine.state as PlayerState


func get_meters_per_sec() -> String:
	return str(run_speed / Platform.SIZE.x).pad_decimals(2)


func get_gravity_percent() -> String:
	return str(gravity / 10.0).pad_decimals(0)


func get_weapon(weapon_resource: WeaponResource, weapon_rarity: Rarity, need_activate := false) -> Weapon:
	var weapon := Weapon.new(weapon_resource, weapon_rarity, ShootEntity.Owner.PLAYER)
	if need_activate:
		weapon.activate()
	else:
		weapon.deactivate()
	return weapon


func get_current_stats() -> String:
	var text := ""
	var stats := {}
	for passivity in passivities:
		if not stats.keys().has(passivity.get_type()):
			stats[passivity.get_type()] = 0.0
		stats[passivity.get_type()] += passivity.get_value()
	
	for p in stats.keys():
		text += DemonPassivityResource.get_text(p, stats.get(p)) + "\n"
	return text


func activate_weapon1(): # WIP !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! COMMON CODE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if weapon.existing_shoot_entity != null:
		weapon.stop_shoot()
	if weapon2 != null:
		weapon2.deactivate()
	weapon1.activate()
	weapon = weapon1
	weapon.ammo = weapon.ammo_max
	ammo_max_changed.emit(weapon1.ammo_max)
	player_sensor.update_switch_icon(weapon.get_preview())


func activate_weapon2():
	if weapon.existing_shoot_entity != null:
		weapon.stop_shoot()
	weapon1.deactivate()
	weapon2.activate()
	weapon = weapon2
	weapon.ammo = weapon.ammo_max
	ammo_max_changed.emit(weapon2.ammo_max)
	player_sensor.update_switch_icon(weapon.get_preview())

