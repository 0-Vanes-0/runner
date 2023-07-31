class_name DeadPlayerState
extends PlayerState

signal died


func enter():
	died.emit()
	player.health_comp.call_deferred("turn_off_collision") # Fix???
	player.clear_statuses()
	player.sprite.play("dead")
	player.sprite.set_frame_and_progress(0, 0.0)
	player.run_speed = 0.0
	
	player.weapon.look_at(player.position + player.weapon.position + Vector2.RIGHT)
	var tween := get_tree().create_tween()
	tween.tween_property(
			player.weapon,
			"position",
			Vector2(player.weapon.position.x, player.body_shape.position.y),
			0.5
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)


func physics_update(delta: float):
	apply_player_gravity(delta)
