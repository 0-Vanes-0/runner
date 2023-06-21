class_name StartEnemyState
extends EnemyState

const ENTER_TIME := 1.5
var timer := 0.0


func enter():
	super.enter()
	enemy.position.x = Global.screen_width + enemy.get_game_size().x / 2
	enemy.position.y = Global.ENEMY_SPAWN_SPOTS[randi_range(0, 3)]
	enemy.sprite.play("default")
	set_anim_looped()
	
	var tween := get_tree().create_tween()
	tween.tween_property(
			enemy, 
			"position:x", 
			Global.screen_width * 0.8,
			ENTER_TIME
	)


func physics_update(delta: float):
	timer += delta
	if timer > ENTER_TIME:
		state_machine.transition_to(enemy.battle_states.pick_random())
