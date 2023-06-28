class_name LevelEndPlayerState
extends PlayerState

const ANIM_RUN := "run"
const ANIM_DEFAULT := "default"
const ANIM_FLY := "jump_down"


func enter():
	super.enter()
	player.sprite.play(ANIM_RUN)
	set_anim_looped()
	
	player.platforms_left = 0
	var run_speed := player.run_speed
	var tween := create_tween()
	tween.tween_property(
			player,
			"position:x",
			Global.screen_width / 2,
			Global.LEVEL_END_TIME
	)
	tween.parallel().tween_property(
			player,
			"position:y",
			Global.screen_height - Platform.SIZE.y,
			Global.LEVEL_END_TIME
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(
			player,
			"run_speed",
			0,
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
