class_name PlayerState
extends State

var player: Player


func _ready():
	assert(owner != null)
	await owner.ready
	player = owner as Player
	assert(player != null)
	
	player.health_comp.out_of_health.connect(
		func():
			state_machine.transition_to(player.state_dead)
	)


func apply_player_gravity(delta: float):
	player.velocity.y += player.gravity * delta
	player.move_and_slide()


func get_colliding_platform() -> Platform:
	for i in player.get_slide_collision_count():
		var collider = player.get_slide_collision(i).get_collider()
		if collider is Platform:
			return collider
	return null
