class_name VertSlideEnemyState
extends EnemyState

signal need_kill_tween()

@export_range(0, 5) var max_bounces_amount: int = 2
@export_range(0.1, 5.0, 0.1) var one_floor_time: float = 1.0
@export_range(5, 180, 1, "degrees") var extra_spread_angle: int = 10
var target_floor: int
var path_length: int
var max_bounces: int


func enter():
	enemy.sprite.play("default")
	set_anim_looped()
	
	enemy.weapon.add_extra_spread_angle(extra_spread_angle)
	
	var alt_floors: Array[int] = FLOORS.duplicate()
	alt_floors.erase(enemy.current_floor)
	target_floor = alt_floors.pick_random()
	path_length = absi(enemy.current_floor - target_floor)
	max_bounces = randi_range(0, max_bounces_amount)
	var tween := create_tween()
	for i in (max_bounces + 1):
		if i % 2 == 0:
			tween.tween_property(
					enemy, "position:y",
					Global.ENEMY_Y_SPOTS[target_floor],
					one_floor_time * path_length
			)
		else:
			tween.tween_property(
					enemy, "position:y",
					Global.ENEMY_Y_SPOTS[enemy.current_floor],
					one_floor_time * path_length
			)
	tween.tween_callback(
			func():
				enemy.weapon.remove_extra_spread_angle()
				if max_bounces % 2 == 0:
					enemy.current_floor = target_floor
				transition_to_random_battle_state()
	)
	need_kill_tween.connect(tween.kill)


func physics_update(delta: float):
	if is_player_alive():
		shoot_at_player()
	else:
		state_machine.transition_to(enemy.state_go_away, true)


func exit():
	need_kill_tween.emit()
