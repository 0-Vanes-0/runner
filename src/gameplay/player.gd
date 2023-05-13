class_name Player
extends CharacterBody2D

@export var player_control: PlayerSensor
@export var shoot_control: ShootSensor
@export var shoot_field: Node2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_speed: float


func _ready():
	if player_control == null:
		print_debug("PlayerSensor is null")
	else:
		player_control.swipe.connect(_move_vert)
	
	if shoot_control == null:
		print_debug("ShootSensor is null")
	else:
		shoot_control.tap.connect(_tap_shoot)
	
	if shoot_field == null:
		print_debug("ShootField is null")


func _process(delta):
	self.velocity.y += gravity * delta
	move_and_slide()
	if self.position.y > Global.screen_height * 2:
		get_tree().reload_current_scene()


func _move_vert(direction: Vector2):
	if is_on_floor():
		# Jump down:
		if direction.y > 0 and _get_colliding_floor() > 0:
			$CollisionShape2D.disabled = true
			await get_tree().create_timer(0.1).timeout
			$CollisionShape2D.disabled = false
		
		# Jump up:
		elif direction.y < 0 and _get_colliding_floor() < Global.floor_group_names.size() - 1 and _get_colliding_floor() > -1:
			self.velocity.y = direction.y * jump_speed


func _get_colliding_floor() -> int:
	for i in self.get_slide_collision_count():
		var collider = self.get_slide_collision(i).get_collider()
		if collider is Platform:
			var group_name: String = collider.get_groups().back()
			return Global.floor_group_names.find(group_name)
	return -1


func _tap_shoot(position: Vector2):
	var projectile := Projectile.new(self, position, Vector2.ZERO, 0, Preloader.fire_orb_texture)
	shoot_field.add_child(projectile)
#	var spawn_spr := Sprite2D.new()
#	spawn_spr.texture = Preloader.fire_orb_texture
#	spawn_spr.position = position
#	get_tree().current_scene.add_child(spawn_spr)
