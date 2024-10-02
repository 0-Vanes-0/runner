class_name LevelEndPlayerState
extends PlayerState

const ANIM_RUN := "run"
const ANIM_DEFAULT := "default"
const ANIM_FLY := "jump_down"
var is_x_right: bool = false


func enter():
	player.sprite.play(ANIM_RUN)
	set_anim_looped()
	
	player.platforms_left = 0
	var x_destination := Global.SCREEN_WIDTH / 2
	var current_x := float(player.position.x)
	
	var tween := create_tween()
	tween.tween_property(
			player, "run_speed",
			0,
			0.0
	)
	tween.tween_property(
			player, "position:x",
			x_destination,
			(x_destination - current_x) / player.current_run_speed
	)
	tween.tween_property(
			self, "is_x_right",
			true,
			0.0
	)
	tween.tween_property(
			player, "run_speed",
			player.current_run_speed,
			0.0
	)
	
	player.go_to_portal.connect(_on_go_to_portal, CONNECT_ONE_SHOT)


func physics_update(delta: float):
	super(delta)
	if player.stamina < player.stamina_max:
		player.stamina += player.stamina_regen * delta
	else:
		player.stamina = player.stamina_max
	apply_player_gravity(delta)

	if player.is_on_floor() and is_x_right:
		is_x_right = false
		player.current_run_speed = 0.0
		player.sprite.play(ANIM_DEFAULT)
		player.call_level_end_objects.emit()



func _on_go_to_portal(portal_position: Vector2):
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
			player, "position",
			portal_position,
			1.0
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	anon_tween.tween_callback(
			func():
				player.scale.x = abs(player.scale.x)
				player.scale.y = abs(player.scale.y)
				player.rotation_degrees = 0
				player.in_portal.emit()
				player.current_run_speed = player.run_speed
	)
