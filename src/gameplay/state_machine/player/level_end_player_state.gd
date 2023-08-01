class_name LevelEndPlayerState
extends PlayerState

const ANIM_RUN := "run"
const ANIM_DEFAULT := "default"
const ANIM_FLY := "jump_down"
var is_gravity_needed: bool = true
var is_x_right: bool = false
var tween: Tween


func enter():
	player.clear_statuses()
	player.sprite.play(ANIM_RUN)
	set_anim_looped()
	
	player.platforms_left = 0
	var run_speed := player.run_speed
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(
			player,
			"position:x",
			Global.SCREEN_WIDTH / 2,
			Global.LEVEL_END_TIME
	)
	tween.tween_property(
			player,
			"run_speed",
			0,
			0.0
	)
	tween.tween_property(
			self,
			"is_x_right",
			true,
			0.0
	)
	tween.tween_property(
			self,
			"is_gravity_needed",
			false,
			0.0
	)
	tween.tween_callback(player.sprite.play.bind(ANIM_DEFAULT))
	tween.tween_callback(
			func():
				player.call_level_end_objects.emit()
	)
	
	player.go_to_portal.connect(
		func(portal_position: Vector2):
			var anon_tween := create_tween()
			if portal_position.x - player.position.x < 0:
				anon_tween.tween_callback(
						func():
							player.scale.x = -abs(player.scale.x)
							player.scale.y = abs(player.scale.y)
							player.rotation_degrees = 0
				)
			anon_tween.tween_callback(player.sprite.play.bind(ANIM_FLY))
			anon_tween.tween_property(
					player,
					"position",
					portal_position,
					Global.LEVEL_END_TIME
			).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			anon_tween.tween_callback(
					func():
						player.scale.x = abs(player.scale.x)
						player.scale.y = abs(player.scale.y)
						player.rotation_degrees = 0
						player.in_portal.emit()
						player.run_speed = run_speed
			)
	, CONNECT_ONE_SHOT)


func physics_update(delta: float):
	apply_player_gravity(delta)
	if not player.is_on_floor() and is_x_right and tween.is_running():
		tween.pause()
	elif player.is_on_floor() and not tween.is_running():
		if tween.is_valid():
			tween.play() # Fix error in debugger
