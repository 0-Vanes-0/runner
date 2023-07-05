class_name DodgePlayerState
extends PlayerState

var stamina_cost := 25.0


func can_go_to_state() -> bool:
	return eat_stamina(stamina_cost)


func enter():
	super.enter()
	var anim_frames_count := player.sprite.sprite_frames.get_frame_count("dodge")
	var anim_fps := player.sprite.sprite_frames.get_animation_speed("dodge")
	var original_speed: float = anim_frames_count / anim_fps
	player.sprite.play("dodge", original_speed / player.dodge_time)
	player.sprite.set_frame_and_progress(0, 0.0)
	
	player.health_comp.switched_collision.connect(
			func():
				if state_machine.state is DodgePlayerState:
					state_machine.transition_to(player.state_run)
	, CONNECT_ONE_SHOT)
	player.health_comp.switch_collision(player.dodge_time)


func exit():
	player.health_comp.turn_on_collision()
