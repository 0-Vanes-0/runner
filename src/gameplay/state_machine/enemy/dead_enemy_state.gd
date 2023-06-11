class_name DeadEnemyState
extends EnemyState

const ANIM := "dead"


func enter():
	super.enter()
	enemy.health_comp.monitorable = false
	enemy.sprite.animation_finished.connect(
		func():
			enemy.queue_free()
	)
	enemy.sprite.play(ANIM)
