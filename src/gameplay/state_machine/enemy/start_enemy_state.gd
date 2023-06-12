class_name StartEnemyState
extends EnemyState

const ANIM := "default"
const ENTER_TIME := 1.0
var timer := 0.0


func enter():
	super.enter()
	enemy.position.x = Global.screen_width + enemy.get_game_size().x / 2
	enemy.position.y = Global.enemy_spawn_spots[randi_range(0, 3)]
	enemy.sprite.play(ANIM)
	
	var tween := get_tree().create_tween()
	tween.tween_property(
		enemy, 
		"position:x", 
		Global.screen_width - enemy.get_game_size().x,
		ENTER_TIME
	).set_ease(Tween.EASE_IN)


func physics_update(delta: float):
	timer += delta
	if timer > ENTER_TIME:
		state_machine.transition_to(enemy.battle_states.pick_random())


func update(delta: float):
	if not enemy.sprite.is_playing():
		enemy.sprite.play(ANIM)
