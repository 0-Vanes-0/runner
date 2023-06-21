class_name GoAwayEnemyState
extends EnemyState


func enter():
	super.enter()
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
