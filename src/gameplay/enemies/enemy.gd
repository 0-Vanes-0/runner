class_name Enemy
extends Node2D

# enum of types of enemies?
@export_range(1, 50) var size_y_percent: float = 25.0
@export var weapon_resource: WeaponResource # todo: Array of Weapons, pick random when spawn
var weapon: Weapon
var battle_states: Array[EnemyState]
var state_dead: DeadEnemyState

@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var health_comp := $HealthComponent as HealthComponent
@onready var weapon_marker := $WeaponMarker as Marker2D
@onready var state_machine := $StateMachine as StateMachine
@onready var player := $"../../Player" as Player


func _ready() -> void:
	assert(sprite)
	assert(health_comp)
	assert(weapon_marker)
	assert(state_machine)
	assert(player, "Player not found.")
	
	Global.clean_layers(health_comp).set_collision_layer_value(Global.Layers.ENEMY, true)
	health_comp.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_PLAYER, true)
	
	var game_y_size := size_y_percent / 100 * Global.screen_height
	self.scale = Vector2(game_y_size, game_y_size) / get_sprite_size()
	
	weapon = Weapon.new(weapon_resource, ShootEntity.Owner.ENEMY)
	weapon.name = "Weapon"
	weapon_marker.add_child(weapon)
	weapon.scale.x *= -1.0
	
	for state in state_machine.get_children():
		if state is EnemyState:
			if state is DeadEnemyState:
				state_dead = state
			elif not state is StartEnemyState:
				battle_states.append(state as EnemyState)


func get_sprite_size() -> Vector2:
	if sprite.sprite_frames != null and sprite.sprite_frames.has_animation("default"):
		var texture := sprite.sprite_frames.get_frame_texture("default", 0)
		assert(texture != null, "texture of 'default' is null")
		return texture.get_size()
	return Vector2.ZERO


func get_game_size() -> Vector2:
	var game_y_size := size_y_percent / 100 * Global.screen_height
	return Vector2(game_y_size, game_y_size)
