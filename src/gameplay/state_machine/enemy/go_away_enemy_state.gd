class_name GoAwayEnemyState
extends EnemyState


func can_go_to_state() -> bool:
	return not state_machine.state is DeadEnemyState


func enter():
	enemy.health_comp.turn_off_collision()
	enemy.status_handler.clear_statuses()
	enemy.sprite.modulate = enemy.health_comp.orig_modulate
	enemy.sprite.play("default")
	set_anim_looped()
	var tween := create_tween()
	tween.tween_property(
			enemy,
			"position:x",
			-enemy.get_game_size().x,
			1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(enemy.queue_free)
