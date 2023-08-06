class_name DeadEnemyState
extends EnemyState


func enter():
	enemy.health_comp.call_deferred("turn_off_collision") # Fix???
	enemy.status_handler.clear_statuses()
	enemy.sprite.modulate = enemy.health_comp.orig_modulate
	enemy.sprite.animation_finished.connect(
			func():
				enemy.queue_free()
	, CONNECT_ONE_SHOT)
	enemy.sprite.play("dead")
	enemy.dead.emit()
