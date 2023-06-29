class_name DeadEnemyState
extends EnemyState


func enter():
	super.enter()
	enemy.health_comp.call_deferred("turn_off_collision") # Fix???
	enemy.sprite.animation_finished.connect(
			func():
				enemy.queue_free()
	, CONNECT_ONE_SHOT)
	enemy.sprite.play("dead")
	enemy.dead.emit()
