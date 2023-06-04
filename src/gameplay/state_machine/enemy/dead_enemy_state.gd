class_name DeadEnemyState
extends EnemyState

const ANIM := "dead"


func enter():
	super.enter()
	enemy.sprite.animation_finished.connect(
		func():
			self.queue_free()
	)
	enemy.sprite.play(ANIM)
