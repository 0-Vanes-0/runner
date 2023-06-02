class_name RunPlayerState
extends PlayerState

const ANIM := "run"


func enter(msg := ""):
	super.enter(msg)
	player.sprite.play(ANIM)
	player.sprite.set_frame_and_progress(0, 0.0)


func physics_update(delta: float):
#	if player.get_health() <= 0:
#		state_machine.transition_to("Dead")
	apply_player_gravity(delta)
	if get_colliding_platform() == null:
		state_machine.transition_to(player.state_jump_down)


func update(delta: float):
	if not player.sprite.is_playing():
		player.sprite.play(ANIM)
	
