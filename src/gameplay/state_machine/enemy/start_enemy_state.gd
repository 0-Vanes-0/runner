class_name StartEnemyState
extends EnemyState

const ANIM := "default"
const ENTER_TIME := 1.0
var timer := 0.0


func enter():
	super.enter()
	enemy.position.x = Global.screen_width + enemy.get_game_size().x / 2
	enemy.position.y = randf_range(enemy.get_game_size().y / 2, Global.screen_height - enemy.get_game_size().y / 2)
	enemy.sprite.play(ANIM)
	
	var tween := get_tree().create_tween()
	tween.tween_property(
		enemy, 
		"position", 
		Vector2(Global.screen_width - enemy.get_game_size().x / 2, enemy.position.y),
		ENTER_TIME
	).set_ease(Tween.EASE_IN)


func physics_update(delta: float):
	timer += delta
	if timer > ENTER_TIME:
		state_machine.transition_to(enemy.battle_states.pick_random())


func update(delta: float):
	if not enemy.sprite.is_playing():
		enemy.sprite.play(ANIM)
