class_name JumpDownPlayerState
extends PlayerState

## Time in seconds which describes how long the collision of [Player] with platforms
## would be turned off during this state.
const JUMP_DOWN_DISABLE_TIME := 0.1
var is_passing_platform: bool


func can_go_to_state() -> bool:
	var platform := get_colliding_platform()
	return platform == null or platform.floor_number > 1 and eat_stamina(player.jumps_stamina_cost)


func enter():
	player.sprite.play("jump_down")
	player.sprite.set_frame_and_progress(0, 0.0)
	player.velocity.y = 0.0
	var platform := get_colliding_platform()
	if platform != null:
		player.velocity.y = player.jump_speed / 6
		is_passing_platform = true
		player.body_shape.disabled = true
		await get_tree().create_timer(JUMP_DOWN_DISABLE_TIME).timeout
		player.body_shape.disabled = false
		is_passing_platform = false


func physics_update(delta: float):
	if not is_passing_platform and get_colliding_platform() != null:
		state_machine.transition_to(player.state_run)
	apply_player_gravity(delta)
