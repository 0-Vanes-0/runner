class_name PlayerState
extends State

var player: Player
var is_anim_looped := false


func _ready():
	assert(owner != null)
	await owner.ready
	player = owner as Player
	assert(player != null)
	
	player.health_comp.out_of_health.connect(
		func():
			state_machine.transition_to(player.state_dead)
	, CONNECT_ONE_SHOT)


func update(delta: float):
	if is_anim_looped:
		if not player.sprite.is_playing():
			player.sprite.play()


func physics_update(delta: float):
	if player.current_run_speed > 0 and player.platforms_left > 0:
		player.platforms_left -= (player.current_run_speed / Platform.SIZE.x) * delta


func set_anim_looped():
	is_anim_looped = true


func apply_player_gravity(delta: float):
	player.velocity.y += player.gravity * delta
	player.move_and_slide()


func get_colliding_platform() -> Platform:
	for i in player.get_slide_collision_count():
		var collider = player.get_slide_collision(i).get_collider()
		if collider is Platform:
			return collider
	return null


func eat_stamina(amount: float) -> bool:
	if player.stamina - amount >= 0:
		player.stamina -= amount
		return true
	else:
		return false
