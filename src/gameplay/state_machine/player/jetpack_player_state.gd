class_name JetpackPlayerState
extends PlayerState

const ANIM_J := "jump_middle"
const FORCE := 100.0


func enter():
	player.sprite.play(ANIM_J)


func physics_update(delta: float):
	super(delta)
	if player.is_jetpacking:
		player.velocity += Vector2.UP * FORCE * delta
	apply_player_gravity(delta)
