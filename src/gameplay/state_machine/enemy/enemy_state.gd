class_name EnemyState
extends State

var enemy: Enemy
var is_anim_looped := false


func _ready() -> void:
	assert(owner != null)
	await owner.ready
	enemy = owner as Enemy
	assert(enemy != null)
	
	enemy.health_comp.out_of_health.connect(
			func():
				state_machine.transition_to(enemy.state_dead)
	, CONNECT_ONE_SHOT)


func update(delta: float):
	if is_anim_looped:
		if not enemy.sprite.is_playing():
			enemy.sprite.play()


func set_anim_looped():
	is_anim_looped = true


func get_weapon_position() -> Vector2:
	return enemy.position + enemy.weapon_marker.position


func get_player_position() -> Vector2:
	return Global.player.get_health_comp_position()


func is_player_alive() -> bool:
	return Global.player.health_comp.health > 0
