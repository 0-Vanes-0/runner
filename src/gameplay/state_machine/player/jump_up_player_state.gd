class_name JumpUpPlayerState
extends PlayerState


func can_go_to_state() -> bool:
	var platform := get_colliding_platform()
	var floor_number := 0 if platform == null else platform.floor_number
	return player.is_on_floor() and floor_number < Global.MAX_FLOORS


func enter():
	super.enter()
	player.sprite.play("jump_down")
	player.sprite.set_frame_and_progress(0, 0.0)
	player.velocity.y = Vector2.UP.y * player.jump_speed


func physics_update(delta: float):
	apply_player_gravity(delta)
	if player.velocity.y > 0:
		state_machine.transition_to(player.state_jump_down)
