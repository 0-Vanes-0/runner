class_name EnemyState
extends State

var enemy: Enemy


func _ready() -> void:
	assert(owner != null)
	await owner.ready
	enemy = owner as Enemy
	assert(enemy != null)
	
	enemy.health_comp.out_of_health.connect(
		func():
			state_machine.transition_to(enemy.state_dead)
	)


func get_weapon_position() -> Vector2:
	return enemy.position + enemy.weapon_marker.position


func get_player_position() -> Vector2:
	return enemy.player.get_health_comp_position()
