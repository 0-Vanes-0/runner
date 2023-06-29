class_name EnemyState
extends State

const FLOORS: Array[int] = [1, 2, 3, 4]
var enemy: Enemy
var is_anim_looped := false


func _ready() -> void:
	assert(owner != null)
	await owner.ready
	enemy = owner as Enemy
	assert(enemy != null)
	
	enemy.health_comp.out_of_health.connect(
			func():
				state_machine.transition_to(enemy.state_dead, true)
	, CONNECT_ONE_SHOT)
	
	connections.resize(1)


func update(delta: float):
	if is_anim_looped:
		if not enemy.sprite.is_playing():
			enemy.sprite.play()


func set_anim_looped():
	is_anim_looped = true


func get_weapon_position() -> Vector2:
	return enemy.position + enemy.weapon_marker.position


func get_player_position() -> Vector2:
	return Global.player.get_health_comp_position()


func is_player_alive() -> bool:
	return Global.player.health_comp.health > 0


func transition_to_random_battle_state():
	if not state_machine.state is DeadEnemyState:
		state_machine.transition_to(enemy.battle_states.pick_random(), true)


func shoot_at_player(shoot_times: int = -1, shoot_counter: int = 0) -> int:
	if enemy.weapon.can_shoot():
		enemy.weapon.shoot(get_weapon_position(), get_player_position())
		if shoot_times != -1:
			shoot_counter += 1
	return shoot_counter if shoot_times != -1 else 0
