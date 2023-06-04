class_name DeadPlayerState
extends PlayerState

const ANIM := "dead"


func enter():
	super.enter()
	player.sprite.play(ANIM)
	player.sprite.set_frame_and_progress(0, 0.0)
	player.run_speed = 0.0
	
	player.weapon.look_at(player.position + player.weapon.position + Vector2.RIGHT)
	var tween := get_tree().create_tween()
	tween.tween_property(
		player.weapon,
		"position",
		Vector2(player.weapon.position.x, player.body_shape.position.y),
		0.5
	).set_ease(Tween.EASE_IN)


func physics_update(delta: float):
	apply_player_gravity(delta)
