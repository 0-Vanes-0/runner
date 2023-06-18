class_name RunPlayerState
extends PlayerState


func enter():
	super.enter()
	player.sprite.play("run")
	set_anim_looped()


func physics_update(delta: float):
	apply_player_gravity(delta)
	if get_colliding_platform() == null:
		state_machine.transition_to(player.state_jump_down)
