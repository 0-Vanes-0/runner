class_name DodgePlayerState
extends PlayerState

const ANIM := "dodge"


func enter():
	super.enter()
	var anim_frames_count := player.sprite.sprite_frames.get_frame_count(ANIM)
	var anim_fps := player.sprite.sprite_frames.get_animation_speed(ANIM)
	var original_speed: float = anim_frames_count / anim_fps
	player.sprite.play(ANIM, original_speed / player.dodge_time)
	player.sprite.set_frame_and_progress(0, 0.0)
	
	await player.health_comp.switch_collision(player.dodge_time)
	state_machine.transition_to(player.state_run)
