class_name StartEnemyState
extends EnemyState

signal need_kill_tween

const ENTER_TIME := 1.5


func enter():
	enemy.current_floor = range(1, Global.MAX_FLOORS + 1).pick_random()
	enemy.position.x = Global.SCREEN_WIDTH + enemy.get_game_size().x / 2
	enemy.position.y = Global.ENEMY_Y_SPOTS[enemy.current_floor]
	enemy.sprite.play("default")
	set_anim_looped()
	
	var tween := get_tree().create_tween()
	tween.tween_property(
			enemy, "position:x", 
			Global.ENEMY_X_POSITION,
			ENTER_TIME
	)
	tween.tween_callback(transition_to_random_battle_state)
	need_kill_tween.connect(
			func():
				tween.kill()
	, CONNECT_ONE_SHOT)


func exit():
	need_kill_tween.emit()
