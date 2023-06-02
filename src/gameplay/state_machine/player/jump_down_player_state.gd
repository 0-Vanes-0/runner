class_name JumpDownPlayerState
extends PlayerState

const ANIM := "jump_down"
var is_passing_platform: bool


func can_go_to_state() -> bool:
	var platform := get_colliding_platform()
	return platform == null or platform.floor_number > 1


func enter(msg := ""):
	super.enter(msg)
	player.sprite.play(ANIM)
	player.sprite.set_frame_and_progress(0, 0.0)
	player.velocity.y = 0.0
	var platform := get_colliding_platform()
	if platform != null:
		is_passing_platform = true
		player.body_shape.disabled = true
		await get_tree().create_timer(Global.JUMP_DOWN_DISABLE_TIME).timeout
		player.body_shape.disabled = false
		is_passing_platform = false


func physics_update(delta: float):
#	if player.get_health() <= 0:
#		state_machine.transition_to("Dead")
	if not is_passing_platform and get_colliding_platform() != null:
		state_machine.transition_to(player.state_run)
	apply_player_gravity(delta)
