class_name StartEnemyState
extends EnemyState

const ENTER_TIME := 1.5


func enter():
	enemy.current_floor = FLOORS.pick_random()
	enemy.position.x = Global.screen_width + enemy.get_game_size().x / 2
	enemy.position.y = Global.ENEMY_Y_SPOTS[enemy.current_floor]
	enemy.sprite.play("default")
	set_anim_looped()
	
	var tween := get_tree().create_tween()
	tween.tween_property(
			enemy, 
			"position:x", 
			Global.screen_width * 0.8,
			ENTER_TIME
	)
	tween.tween_callback(transition_to_random_battle_state)
