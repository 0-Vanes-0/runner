## This is class for enemies which fight with [Player].
class_name Enemy
extends Node2D
## Emitted when [member HealthComponent.health] is 0.
signal dead

# enum of types of enemies?
@export_range(1, 50) var size_y_percent: float = 25.0
@export var weapon_resource: WeaponResource ## WIP: Array of Weapons, pick random when spawn.
#@export var clothes: ClothesResource
@export_group("Children")
@export var sprite: AnimatedSprite2D
@export var health_comp: HealthComponent
@export var weapon_marker: Marker2D
@export var state_machine: StateMachine
@export var statuses: Node ## Parent node of all [Status]es.

var weapon: Weapon
#var clothes: Clothes
var battle_states: Array[EnemyState]
var state_go_away: GoAwayEnemyState
var state_dead: DeadEnemyState
var current_floor: int


func _ready() -> void:
	assert(size_y_percent and weapon_resource and sprite and health_comp and weapon_marker and state_machine and statuses)
	
	Global.clean_layers(health_comp).set_collision_layer_value(Global.Layers.ENEMY, true)
	health_comp.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_PLAYER, true)
	var game_y_size := size_y_percent / 100 * Global.SCREEN_HEIGHT
	self.scale = Vector2(game_y_size, game_y_size) / get_sprite_size()
	health_comp.create_hp_label()
	
	weapon = Weapon.new(weapon_resource, Rarity.new(Rarity.NORMAL), ShootEntity.Owner.ENEMY)
	weapon_marker.add_child(weapon)
	weapon.scale.x *= -1.0
	
	for state in state_machine.get_children() as Array[EnemyState]:
		if state is DeadEnemyState:
			state_dead = state
		elif state is GoAwayEnemyState:
			state_go_away = state
		elif not state is StartEnemyState:
			battle_states.append(state as EnemyState)


func get_sprite_size() -> Vector2:
	if sprite.sprite_frames != null and sprite.sprite_frames.has_animation("default"):
		var texture := sprite.sprite_frames.get_frame_texture("default", 0)
		assert(texture != null, "texture of 'default' is null")
		return texture.get_size()
	return Vector2.ZERO


func get_game_size() -> Vector2:
	var game_y_size := size_y_percent / 100 * Global.SCREEN_HEIGHT
	return Vector2(game_y_size, game_y_size)


func get_statuses() -> Array[Node]:
	return statuses.get_children()


func clear_statuses():
	for status in get_statuses() as Array[Status]:
		status.queue_free()
	sprite.modulate = health_comp.orig_modulate
