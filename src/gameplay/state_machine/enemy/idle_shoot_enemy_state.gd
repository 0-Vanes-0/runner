class_name IdleShootEnemyState
extends EnemyState

@export_range(0, 20) var shoot_times: int = 5
var shoot_counter: int


func enter():
	enemy.sprite.play("default")
	set_anim_looped()
	shoot_counter = 0


func physics_update(delta: float):
	if is_player_alive():
		shoot_counter = shoot_at_player(shoot_times, shoot_counter)
		if shoot_counter == shoot_times:
			transition_to_random_battle_state()
	else:
		enemy.state_machine.transition_to(enemy.state_go_away, true)
