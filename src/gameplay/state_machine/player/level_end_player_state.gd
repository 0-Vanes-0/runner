class_name LevelEndPlayerState
extends PlayerState

const ANIM_RUN := "run"
const ANIM_DEFAULT := "default"
const ANIM_FLY := "jump_down"


func enter():
	super.enter()
	player.sprite.play(ANIM_RUN)
	set_anim_looped()
	var tween := create_tween()
	tween.tween_property(
		player,
		"position",
		Vector2(Global.screen_width / 2, Global.screen_height - Platform.SIZE.y),
		Global.LEVEL_END_TIME
	)
	tween.tween_property(
		player,
		"run_speed",
		0,
		0.0
	)
	tween.tween_callback(player.sprite.play.bind(ANIM_DEFAULT))
	tween.tween_callback(func(): player.call_level_end_objects.emit())
	
	player.go_to_portal.connect(
		func(portal_position: Vector2):
			player.sprite.play(ANIM_RUN)
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
			)
	, CONNECT_ONE_SHOT)
