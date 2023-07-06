class_name RunPlayerState
extends PlayerState

var stamina_regen := 15.0 # per second


func enter():
	player.sprite.play("run")
	set_anim_looped()


func physics_update(delta: float):
	if player.stamina < player.stamina_max:
		player.stamina += stamina_regen * delta
	else:
		player.stamina = player.stamina_max
	apply_player_gravity(delta)
	if get_colliding_platform() == null:
		state_machine.transition_to(player.state_jump_down)
