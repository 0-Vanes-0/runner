class_name JumpUpPlayerState
extends PlayerState

const STAMINA_COST: int = 10

func can_go_to_state() -> bool:
	var platform := get_colliding_platform()
	var floor_number := 0 if platform == null else platform.floor_number
	return 0 < floor_number and floor_number < Global.MAX_FLOORS and eat_stamina(STAMINA_COST)


func enter():
	player.sprite.play("jump_up")
	player.sprite.set_frame_and_progress(0, 0.0)
	player.velocity.y = Vector2.UP.y * player.jump_speed
	


func physics_update(delta: float):
	apply_player_gravity(delta)
	if player.velocity.y > 0:
		state_machine.transition_to(player.state_jump_down)
