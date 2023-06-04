class_name DodgePlayerState
extends PlayerState

const ANIM := "dodge"
var timer: float


func enter():
	super.enter()
	var anim_frames_count := player.sprite.sprite_frames.get_frame_count(ANIM)
	var anim_fps := player.sprite.sprite_frames.get_animation_speed(ANIM)
	var original_speed: float = anim_frames_count / anim_fps
	player.sprite.play(ANIM, original_speed / player.dodge_time)
	player.sprite.set_frame_and_progress(0, 0.0)
	timer = 0.0
	player.hitbox.monitorable = false


func physics_update(delta: float):
#	if player.get_health() <= 0:
#		state_machine.transition_to("Dead")
	timer += delta
	if timer > player.dodge_time:
		player.hitbox.monitorable = true
		state_machine.transition_to(player.state_run)
