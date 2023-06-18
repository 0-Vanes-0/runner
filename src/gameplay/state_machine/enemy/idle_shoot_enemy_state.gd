class_name IdleShootEnemyState
extends EnemyState


func enter():
	super.enter()
	enemy.sprite.play("default")
	set_anim_looped()


func physics_update(delta: float):
	if is_player_alive():
		enemy.weapon.shoot(get_weapon_position(), get_player_position())
	else:
		enemy.state_machine.transition_to(enemy.state_go_away, true)
