class_name DodgePlayerState
extends PlayerState


func enter():
	super.enter()
	var anim_frames_count := player.sprite.sprite_frames.get_frame_count("dodge")
	var anim_fps := player.sprite.sprite_frames.get_animation_speed("dodge")
	var original_speed: float = anim_frames_count / anim_fps
	player.sprite.play("dodge", original_speed / player.dodge_time)
	player.sprite.set_frame_and_progress(0, 0.0)
	
	await player.health_comp.switch_collision(player.dodge_time)
	state_machine.transition_to(player.state_run)


func exit():
	player.health_comp.turn_on_collision()
