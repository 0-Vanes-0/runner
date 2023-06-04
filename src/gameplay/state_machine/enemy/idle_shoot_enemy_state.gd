class_name IdleShootEnemyState
extends EnemyState

const ANIM := "default"


func enter():
	connections.append_array(enemy.battle_states)
	super.enter()
	enemy.sprite.play(ANIM)


func physics_update(delta: float):
	enemy.weapon.shoot(enemy.position + enemy.weapon_marker.position, Vector2(0, Global.screen_height / 2))


func update(delta: float):
	if not enemy.sprite.is_playing():
		enemy.sprite.play(ANIM)
