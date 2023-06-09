class_name IdleShootEnemyState
extends EnemyState

const ANIM := "default"


func enter():
	connections.append_array(enemy.battle_states)
	super.enter()
	enemy.sprite.play(ANIM)


func physics_update(delta: float):
	enemy.weapon.shoot(enemy.position + enemy.weapon_marker.position, enemy.player.get_hitbox_position())


func update(delta: float):
	if not enemy.sprite.is_playing():
		enemy.sprite.play(ANIM)
