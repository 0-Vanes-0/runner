class_name IdleShootEnemyState
extends EnemyState

const ANIM := "default"


func enter():
	super.enter()
	enemy.sprite.play(ANIM)


func physics_update(delta: float):
	if enemy.get_player().health_comp.health > 0:
		enemy.weapon.shoot(get_weapon_position(), get_player_position())
	else:
		enemy.state_machine.transition_to(enemy.state_go_away, true)


func update(delta: float):
	if not enemy.sprite.is_playing():
		enemy.sprite.play()
