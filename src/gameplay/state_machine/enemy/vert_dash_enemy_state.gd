class_name VertDashEnemyState
extends EnemyState

const DASH_TIME := 1.5
var tween: Tween


func enter():
	enemy.sprite.play("default")
	set_anim_looped()
	var alt_floors: Array[int] = FLOORS.duplicate()
	alt_floors.erase(enemy.current_floor)
	enemy.current_floor = alt_floors.pick_random()
	tween = create_tween()
	tween.tween_property(
			enemy, "position:y",
			Global.ENEMY_Y_SPOTS[enemy.current_floor],
			DASH_TIME
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(0.5)
	tween.tween_callback(transition_to_random_battle_state)


func physics_update(delta: float):
	if is_player_alive():
		pass
	else:
		state_machine.transition_to(enemy.state_go_away, true)


func exit():
	tween.kill()
