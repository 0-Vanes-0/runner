class_name IdleShootEnemyState
extends EnemyState

const ANIM := "default"


func enter():
	super.enter()
	enemy.sprite.play(ANIM)


func physics_update(delta: float):
	enemy.weapon.shoot(get_weapon_position(), get_player_position())


func update(delta: float):
	if not enemy.sprite.is_playing():
		enemy.sprite.play()
