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
@export var fact_size_area: Area2D
@export var sprite: AnimatedSprite2D
@export var health_comp: HealthComponent
@export var weapon_marker: Marker2D
@export var state_machine: StateMachine
@export var status_handler: StatusHandler ## Parent node of all [Status]es.

var weapon: Weapon
#var clothes: Clothes
var battle_states: Array[EnemyState]
var state_go_away: GoAwayEnemyState
var state_dead: DeadEnemyState
var current_floor: int


func _ready() -> void:
	assert(weapon_resource)
	assert(sprite and health_comp and weapon_marker and state_machine and status_handler)
	
	Global.clean_layers(health_comp).set_collision_layer_value(Global.Layers.ENEMY, true)
	health_comp.set_collision_mask_value(Global.Layers.SHOOT_ENTITY_PLAYER, true)
	self.scale = get_adjust_scale()
	
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


func get_fact_size() -> Vector2:
	return ((fact_size_area.get_child(0) as CollisionShape2D).shape as RectangleShape2D).size


func get_game_size() -> Vector2:
	var game_y_size := size_y_percent / 100 * Global.SCREEN_HEIGHT
	return Vector2(game_y_size, game_y_size)


func get_adjust_scale() -> Vector2:
	return get_game_size() / get_fact_size()
